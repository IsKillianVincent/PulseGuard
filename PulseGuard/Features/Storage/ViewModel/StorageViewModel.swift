//
//  StorageViewModel.swift
//  PulseGuard
//
//  Created by Killian VINCENT on 22/08/2025.
//


import Foundation

@MainActor
final class StorageViewModel: ObservableObject {
    @Published var vols: [DiskVolume] = []

    private let reader: StorageReading
    private var timer: Timer?

    init(reader: StorageReading) { self.reader = reader }

    func start(pollInterval: TimeInterval = 30) {
        timer?.invalidate()
        tick()
        timer = Timer.scheduledTimer(withTimeInterval: max(10, pollInterval), repeats: true) { [weak self] _ in
            Task { @MainActor in self?.tick() }
        }
        if let t = timer { RunLoop.main.add(t, forMode: .common) }
    }

    func stop() { timer?.invalidate(); timer = nil }

    private func tick() { vols = reader.volumes() }
}
