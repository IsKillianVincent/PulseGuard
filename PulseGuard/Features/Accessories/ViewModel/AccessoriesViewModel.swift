//
//  AccessoriesViewModel.swift
//  PulseGuard
//
//  Created by Killian VINCENT on 24/08/2025.
//

import Foundation

@MainActor
final class AccessoriesViewModel: ObservableObject {
    @Published private(set) var accessories: [AccessoryInfo] = []
    private let reader: any AccessoryReading
    private var task: Task<Void, Never>?

    init(reader: any AccessoryReading) {
        self.reader = reader
        refresh()
    }

    func start(pollInterval: TimeInterval = 30) {
        stop()
        task = Task { [weak self] in
            guard let self else { return }
            while !Task.isCancelled {
                await MainActor.run { self.refresh() }
                try? await Task.sleep(nanoseconds: UInt64(pollInterval * 1_000_000_000))
            }
        }
    }

    func stop() { task?.cancel(); task = nil }
    private func refresh() { accessories = reader.current() }
}
