//
//  SystemReading.swift
//  PulseGuard
//
//  Created by Killian VINCENT on 22/08/2025.
//

import Foundation

final class SystemReader: SystemReading {
    func sample() -> ThermalSnapshot {
        ThermalSnapshot(
            date: Date(),
            state: ProcessInfo.processInfo.thermalState,
            uptime: ProcessInfo.processInfo.systemUptime
        )
    }
}
