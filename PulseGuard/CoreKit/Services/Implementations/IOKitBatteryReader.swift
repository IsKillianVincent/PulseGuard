//
//  IOKitBatteryReader.swift
//  PulseGuard
//
//  Created by Killian VINCENT on 22/08/2025.
//

import Foundation
import IOKit.ps

struct IOKitBatteryReader: BatteryReading {
    func read() -> BatteryStatus? {
        guard let snapshot = IOPSCopyPowerSourcesInfo()?.takeRetainedValue() else { return nil }
        let global = IOPSGetProvidingPowerSourceType(snapshot)?.takeRetainedValue() as String?
        let onAC = (global == kIOPSACPowerValue)

        guard let sources = IOPSCopyPowerSourcesList(snapshot)?.takeRetainedValue() as? [CFTypeRef] else { return nil }
        for src in sources {
            guard let desc = IOPSGetPowerSourceDescription(snapshot, src)?
                    .takeUnretainedValue() as? [String: Any] else { continue }
            guard (desc[kIOPSTypeKey] as? String) == kIOPSInternalBatteryType else { continue }

            let current = (desc[kIOPSCurrentCapacityKey] as? Int) ?? 0
            let maxCap  = Swift.max((desc[kIOPSMaxCapacityKey] as? Int) ?? 100, 1)
            let percent = Int(round(Double(current) / Double(maxCap) * 100.0))
            let isCharging = (desc[kIOPSIsChargingKey] as? Bool) ?? false
            let clamped = Swift.min(Swift.max(percent, 0), 100)
            return BatteryStatus(levelPercent: clamped, isCharging: isCharging, onACPower: onAC)
        }
        return nil
    }
}
