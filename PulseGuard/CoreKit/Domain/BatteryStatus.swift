//
//  BatteryStatus.swift
//  PulseGuard
//
//  Created by Killian VINCENT on 22/08/2025.
//

import Foundation

struct BatteryStatus: Equatable {
    let levelPercent: Int   // 0...100
    let isCharging: Bool
    let onACPower: Bool
}
