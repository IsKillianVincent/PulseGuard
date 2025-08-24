//
//  PowerAdapterViewModel.swift
//  PulseGuard
//
//  Created by Killian VINCENT on 24/08/2025.
//


import Foundation

@MainActor
final class PowerAdapterViewModel: ObservableObject {
    @Published private(set) var info = PowerAdapterInfo()
    private let reader: PowerAdapterReading
    private var task: Task<Void,Never>?

    init(reader: PowerAdapterReading) {
        self.reader = reader
        refresh()
    }

    func start(pollInterval: TimeInterval = 5.0) {
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
    private func refresh() { info = reader.current() }
}
