//
//  NetworkViewModel.swift
//  PulseGuard
//
//  Created by Killian VINCENT on 22/08/2025.
//


import Foundation
import SwiftUI

@MainActor
final class NetworkViewModel: ObservableObject {
    @Published var snapshot: NetworkSnapshot? = nil
    @Published var history: [HistoryPoint] = []   // Down en % de l’échelle dynamique

    private let reader: NetworkReading
    private var timer: Timer?

    // Échelle auto pour la sparkline (paliers 1, 10, 100, 1000 KB/s…)
    private var scale: Double = 1024 // 1 KB/s

    init(reader: NetworkReading) { self.reader = reader }

    func start(pollInterval: TimeInterval = 1.0) {
        timer?.invalidate()
        tick()
        timer = Timer.scheduledTimer(withTimeInterval: max(0.5, pollInterval), repeats: true) { [weak self] _ in
            Task { @MainActor in self?.tick() }
        }
        if let t = timer { RunLoop.main.add(t, forMode: .common) }
    }
    func stop() { timer?.invalidate(); timer = nil }

    private func tick() {
        guard let s = reader.sample() else { return }
        snapshot = s

        // échelle dynamique ~*10 quand on dépasse 85 %
        let downKBs = s.downBps / 1024.0
        while downKBs > scale * 0.85 { scale *= 10 }
        while downKBs < scale * 0.085 && scale > 1024 { scale /= 10 }

        let pct = min(100, (downKBs / scale) * 100.0)
        history.append(HistoryPoint(date: s.date, value: pct))
        if history.count > 300 { history.removeFirst(history.count - 300) }
    }

    // MARK: - Formats
    var upText: String  { formatRate(snapshot?.upBps ?? 0) }
    var downText: String{ formatRate(snapshot?.downBps ?? 0) }
    var ifaceText: String {
        guard let s = snapshot else { return "—" }
        return s.address.map { "\(s.interface) • \($0)" } ?? s.interface
    }

    private func formatRate(_ bps: Double) -> String {
        if bps >= 1_000_000 { return String(format: "%.2f MB/s", bps / 1_000_000) }
        if bps >= 1_000 {     return String(format: "%.1f KB/s", bps / 1_000) }
        return String(format: "%.0f B/s", bps)
    }
}
