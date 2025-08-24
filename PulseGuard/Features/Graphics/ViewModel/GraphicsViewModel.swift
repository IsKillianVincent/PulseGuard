//
//  GraphicsViewModel.swift
//  PulseGuard
//
//  Created by Killian VINCENT on 24/08/2025.
//

import Foundation
import Combine

@MainActor
final class GraphicsViewModel: ObservableObject {
    @Published private(set) var status = GPUStatus(name: "—")

    private let reader: GPUReading
    private var task: Task<Void, Never>?

    init(reader: GPUReading) {
        self.reader = reader
    }

    func start(pollInterval: TimeInterval = 1.0) {
        task?.cancel()
        task = Task { [weak self] in
            guard let self else { return }
            while !Task.isCancelled {
                let s = reader.readGPU()
                await MainActor.run { self.status = s }
                try? await Task.sleep(nanoseconds: UInt64(pollInterval * 1_000_000_000))
            }
        }
    }

    func stop() {
        task?.cancel()
        task = nil
    }
}
