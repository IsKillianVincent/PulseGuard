//
//  BatteryHealthViewModel.swift
//  PulseGuard
//
//  Created by Killian VINCENT on 22/08/2025.
//


import Foundation
import SwiftUI

@MainActor
final class BatteryHealthViewModel: ObservableObject {
    @Published var health: BatteryHealth? = nil
    private let reader: BatteryHealthReading
    private var timer: Timer?

    init(reader: BatteryHealthReading) { self.reader = reader }

    func start(pollInterval: TimeInterval = 60) {
        timer?.invalidate()
        tick()
        timer = Timer.scheduledTimer(withTimeInterval: max(15, pollInterval), repeats: true) { [weak self] _ in
            Task { @MainActor in self?.tick() }
        }
        if let t = timer { RunLoop.main.add(t, forMode: .common) }
    }
    func stop() { timer?.invalidate(); timer = nil }

    private func tick() { health = reader.read() }

    var capacityLine: String {
        guard let h = health, h.designCapacitymAh > 0 else { return "—" }
        return "\(h.maxText) / \(h.designText) (\(h.healthPercentText))"
    }

    var tempText: String? {
        guard let t = health?.temperatureC else { return nil }
        return String(format: "%.1f ℃", t)
    }

    var accent: Color {
        guard let ratio = health?.healthRatio else { return .green }
        switch ratio {
        case ..<0.80: return .orange
        case ..<0.90: return .yellow
        default:      return .green
        }
    }
}
