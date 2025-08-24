//
//  BatteryViewModel.swift
//  PulseGuard
//
//  Created by Killian VINCENT on 22/08/2025.
//

import Foundation
import SwiftUI

@MainActor
final class BatteryViewModel: ObservableObject {
    @Published var status: BatteryStatus? = nil
    @Published var currentAdvice: ChargeAdvice = .keepAsIs
    @Published var history: [HistoryPoint] = []
    @Published var flashKey: Bool = false
    @Published var notifStatusText: String = "—"
    @Published var silenceUntil: Date? = nil

    private let reader: BatteryReading
    private let notifier: Notifying
    private let settings: SettingsStore

    private var timer: Timer?
    private var lastNotifiedAdvice: ChargeAdvice?
    private var lastNotificationDate: Date?
    private let notificationCooldown: TimeInterval = 15 * 60

    init(reader: BatteryReading, notifier: Notifying, settings: SettingsStore) {
        self.reader = reader
        self.notifier = notifier
        self.settings = settings
    }

    func start(pollInterval: TimeInterval) {
        notifier.requestAuth { _ in }
        timer?.invalidate()
        tick()
        timer = Timer.scheduledTimer(withTimeInterval: max(10, pollInterval), repeats: true) { [weak self] _ in
            Task { @MainActor in self?.tick() }
        }
        if let t = timer { RunLoop.main.add(t, forMode: .common) }
    }
    func stop() { timer?.invalidate(); timer = nil }
    func forceCheck() { tick() }

    private func tick() {
        guard let s = reader.read() else { return }
        status = s
        history.append(HistoryPoint(date: Date(), value: Double(s.levelPercent)))
        if history.count > 240 { history.removeFirst(history.count - 240) }

        let policy = settings.effectivePolicy
        let newAdvice = policy.advice(for: s)
        currentAdvice = newAdvice

        if newAdvice != .keepAsIs, newAdvice != lastNotifiedAdvice {
            let okCooldown = (lastNotificationDate == nil) || (Date().timeIntervalSince(lastNotificationDate!) >= notificationCooldown)
            if okCooldown && !isSilenced {
                let title = (newAdvice == .plugIn) ? "Brancher le chargeur" : "Débrancher le chargeur"
                let body  = "Batterie \(s.levelPercent)% • " + (s.onACPower ? "sur secteur" : "sur batterie")
                notifier.notify(title, body: body)
                lastNotificationDate = Date()
                flashKey.toggle()
            }
            lastNotifiedAdvice = newAdvice
        }
    }

    var isSilenced: Bool { (silenceUntil ?? .distantPast) > Date() }
    func silence(for duration: TimeInterval) { silenceUntil = Date().addingTimeInterval(duration) }
    func cancelSilence() { silenceUntil = nil }
    var silenceRemainingDescription: String? {
        guard let until = silenceUntil, until > Date() else { return nil }
        let m = Int(until.timeIntervalSinceNow.rounded()) / 60
        return m >= 60 ? String(format: "%dh%02d", m/60, m%60) : "\(max(m,1)) min"
    }

    var shouldPulse: Bool { isSilenced ? false : (status?.isCharging == true || currentAdvice != .keepAsIs) }
    var menuTitleShort: String { status.map { "\($0.levelPercent)%" } ?? "—" }
    var menuTint: Color {
        guard let s = status else { return .primary }
        let p = settings.effectivePolicy
        if (p.lowerIdeal...p.upperIdeal).contains(s.levelPercent) { return .green }
        if s.levelPercent <= p.plugThreshold && !s.onACPower { return .orange }
        if s.levelPercent >= p.unplugThreshold && s.onACPower { return .yellow }
        return .primary
    }
    var menuIcon: String {
        guard let s = status else { return "waveform.path.ecg" }
        if s.isCharging { return "battery.100.bolt" }
        if s.onACPower  { return "battery.100" }
        switch s.levelPercent {
        case 0...20:   return "battery.25"
        case 21...50:  return "battery.50"
        case 51...80:  return "battery.75"
        default:       return "battery.100"
        }
    }

    var detailLineShort: String {
        guard let s = status else { return "—" }
        let p = settings.effectivePolicy
        switch currentAdvice {
        case .plugIn:  return "Brancher (≤ \(p.plugThreshold)%)"
        case .unplug:  return "Débrancher (≥ \(p.unplugThreshold)%)"
        case .keepAsIs:
            return (p.lowerIdeal...p.upperIdeal).contains(s.levelPercent) ? "Dans la zone" : "Rien à faire"
        }
    }

    var etaDescription: String? {
        guard history.count >= 3, let s = status else { return nil }
        let win = history.suffix(10)
        guard let first = win.first, let last = win.last else { return nil }
        let dt = last.date.timeIntervalSince(first.date); guard dt > 0 else { return nil }
        let rate = (last.value - first.value) / dt
        guard rate != 0 else { return nil }
        let p = settings.effectivePolicy
        if s.onACPower {
            let target = Double(max(p.unplugThreshold, s.levelPercent))
            guard target > Double(s.levelPercent) else { return nil }
            let secs = (target - Double(s.levelPercent)) / rate
            return secs.isFinite && secs > 0 ? "≈ \(format(secs)) jusqu’à \(p.unplugThreshold)%" : nil
        } else {
            let target = Double(min(p.plugThreshold, s.levelPercent))
            guard target < Double(s.levelPercent) else { return nil }
            let secs = (target - Double(s.levelPercent)) / rate
            return secs.isFinite && secs > 0 ? "≈ \(format(secs)) jusqu’à \(p.plugThreshold)%" : nil
        }
    }
    private func format(_ seconds: Double) -> String {
        let s = Int(seconds.rounded()); let h = s / 3600; let m = (s % 3600) / 60
        return h > 0 ? "\(h)h\(String(format:"%02d",m))" : "\(max(m,1)) min"
    }
}
