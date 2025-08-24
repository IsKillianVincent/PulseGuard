//
//  MemoryPressure.swift
//  PulseGuard
//
//  Created by Killian VINCENT on 22/08/2025.
//

import Foundation

enum MemoryPressure: String, Equatable {
    case low = "Low", medium = "Medium", high = "High", critical = "Critical"
}

struct MemorySnapshot: Equatable {
    let date: Date
    let totalBytes: UInt64
    let usedBytes: UInt64
    let freeBytes: UInt64
    let wiredBytes: UInt64
    let compressedBytes: UInt64
    let pressure: MemoryPressure

    var usedRatio: Double { totalBytes == 0 ? 0 : Double(usedBytes) / Double(totalBytes) }
    var usedPercentText: String { "\(Int(round(usedRatio * 100))) %" }
    var totalText: String { ByteCountFormatter.string(fromByteCount: Int64(totalBytes), countStyle: .binary) }
    var usedText:  String { ByteCountFormatter.string(fromByteCount: Int64(usedBytes),  countStyle: .binary) }
    var freeText:  String { ByteCountFormatter.string(fromByteCount: Int64(freeBytes),  countStyle: .binary) }
}
