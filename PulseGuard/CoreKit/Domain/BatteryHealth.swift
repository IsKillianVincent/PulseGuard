//
//  BatteryHealth.swift
//  PulseGuard
//
//  Created by Killian VINCENT on 22/08/2025.
//

import Foundation

struct BatteryHealth: Equatable {
    let date: Date
    let cycleCount: Int
    let designCapacitymAh: Int
    let maxCapacitymAh: Int
    let onACPower: Bool
    let isCharging: Bool
    let temperatureC: Double?

    var healthRatio: Double {
        guard designCapacitymAh > 0 else { return 0 }
        return min(1.0, Double(maxCapacitymAh) / Double(designCapacitymAh))
    }

    var healthPercentText: String { "\(Int(round(healthRatio * 100)))%" }
    var designText: String { designCapacitymAh > 0 ? "\(designCapacitymAh) mAh" : "—" }
    var maxText: String { maxCapacitymAh > 0 ? "\(maxCapacitymAh) mAh" : "—" }
}
