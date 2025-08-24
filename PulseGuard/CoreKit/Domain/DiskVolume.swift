//
//  DiskVolume.swift
//  PulseGuard
//
//  Created by Killian VINCENT on 22/08/2025.
//

import Foundation

struct DiskVolume: Identifiable, Equatable {
    let id = UUID()
    let name: String
    let total: Int64
    let free: Int64
    let isInternal: Bool

    var used: Int64 { max(0, total - free) }
    var usedRatio: Double { total == 0 ? 0 : Double(used) / Double(total) }

    var totalText: String { ByteCountFormatter.string(fromByteCount: total, countStyle: .decimal) }
    var usedText:  String { ByteCountFormatter.string(fromByteCount: used,  countStyle: .decimal) }
    var freeText:  String { ByteCountFormatter.string(fromByteCount: free,  countStyle: .decimal) }
}
