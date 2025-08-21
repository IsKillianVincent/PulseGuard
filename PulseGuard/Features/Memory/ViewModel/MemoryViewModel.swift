//
//  MemoryViewModel.swift
//  PulseGuard
//
//  Created by Killian VINCENT on 22/08/2025.
//


import Foundation
import SwiftUI

@MainActor
final class MemoryViewModel: ObservableObject {
    @Published var snapshot: MemorySnapshot? = nil
    @Published var history: [HistoryPoint] = []

    private let reader: MemoryReading
    private var timer: Timer?

    init(reader: MemoryReading) { self.reader = reader }

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
        history.append(HistoryPoint(date: s.date, value: s.usedRatio * 100))
        if history.count > 300 { history.removeFirst(history.count - 300) }
    }

    var pressureColor: Color {
        switch snapshot?.pressure {
        case .critical: return .red
        case .high:     return .orange
        case .medium:   return .yellow
        case .low:      fallthrough
        default:        return .green
        }
    }
}
