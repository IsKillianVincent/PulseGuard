//
//  CPUModels.swift
//  PulseGuard
//
//  Created by Killian VINCENT on 22/08/2025.
//

import Foundation

struct CPUCoreLoad: Equatable {
    let user: Double   // 0...1
    let system: Double // 0...1
    let idle: Double   // 0...1
    var total: Double { user + system }
}

struct CPUSnapshot: Equatable {
    let date: Date
    let total: CPUCoreLoad
    let perCore: [CPUCoreLoad]
    let loadAvg1: Double
    let loadAvg5: Double
    let loadAvg15: Double
}
