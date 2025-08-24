//
//  CPUViewModel.swift
//  PulseGuard
//
//  Created by Killian VINCENT on 22/08/2025.
//

import Foundation
import SwiftUI

@MainActor
final class CPUViewModel: ObservableObject {
    @Published var snapshot: CPUSnapshot? = nil
    @Published var history: [HistoryPoint] = []

    private let reader: CPUReading
    private var timer: Timer?

    init(reader: CPUReading) { self.reader = reader }

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
        history.append(HistoryPoint(date: s.date, value: s.total.total))
        if history.count > 120 { history.removeFirst(history.count - 120) }
    }

    var totalPercentText: String {
        guard let s = snapshot else { return "— %" }
        return "\(Int(round(s.total.total * 100))) %"
    }
}
