//
//  BatteryStatus.swift
//  PulseGuard
//
//  Created by Killian VINCENT on 22/08/2025.
//

import Foundation

struct BatteryStatus: Equatable {
    let levelPercent: Int
    let isCharging: Bool
    let onACPower: Bool
}
