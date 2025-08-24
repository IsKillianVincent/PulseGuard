//
//  MetalGPUReader.swift
//  PulseGuard
//
//  Created by Killian VINCENT on 24/08/2025.
//

import Foundation
import Metal

public final class MetalGPUReader: GPUReading {

    private let device: MTLDevice?

    public init(device: MTLDevice? = MTLCreateSystemDefaultDevice()) {
        self.device = device
    }

    public func readGPU() -> GPUStatus {
        guard let dev = device else {
            return GPUStatus(name: "No GPU")
        }

        let used = UInt64(dev.currentAllocatedSize)

        let total = dev.recommendedMaxWorkingSetSize > 0
            ? UInt64(dev.recommendedMaxWorkingSetSize)
            : nil

        return GPUStatus(
            name: dev.name,
            load: nil,
            memoryUsedBytes: used,
            memoryTotalBytes: total,
            temperatureC: nil,
            date: Date()
        )
    }
}
