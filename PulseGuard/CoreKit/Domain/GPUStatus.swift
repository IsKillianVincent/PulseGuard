//
//  GPUStatus.swift
//  PulseGuard
//
//  Created by Killian VINCENT on 24/08/2025.
//

import Foundation

public struct GPUStatus: Equatable, Sendable {
    public var name: String
    public var load: Double?
    public var memoryUsedBytes: UInt64?
    public var memoryTotalBytes: UInt64?
    public var temperatureC: Double?
    public var date: Date

    public init(name: String,
                load: Double? = nil,
                memoryUsedBytes: UInt64? = nil,
                memoryTotalBytes: UInt64? = nil,
                temperatureC: Double? = nil,
                date: Date = .init()) {
        self.name = name
        self.load = load
        self.memoryUsedBytes = memoryUsedBytes
        self.memoryTotalBytes = memoryTotalBytes
        self.temperatureC = temperatureC
        self.date = date
    }
}

public extension GPUStatus {
    var usedPercent: Double? {
        guard let u = memoryUsedBytes, let t = memoryTotalBytes, t > 0 else { return nil }
        return Double(u) / Double(t)
    }
}
