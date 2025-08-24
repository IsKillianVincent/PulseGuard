//
//  IOPowerAdapterReader.swift
//  PulseGuard
//
//  Created by Killian VINCENT on 24/08/2025.
//

import Foundation
import IOKit.ps

public final class IOPowerAdapterReader: PowerAdapterReading {
    public init() {}

    public func current() -> PowerAdapterInfo {
        var out = PowerAdapterInfo()

        let blob = IOPSCopyPowerSourcesInfo().takeRetainedValue()
        let list = IOPSCopyPowerSourcesList(blob).takeRetainedValue() as NSArray

        if let ps = list.firstObject as CFTypeRef?,
           let desc = IOPSGetPowerSourceDescription(blob, ps).takeUnretainedValue() as? [String: Any] {

            let state = desc[kIOPSPowerSourceStateKey as String] as? String
            out.isACPresent = (state == kIOPSACPowerValue)
            if let ch = desc[kIOPSIsChargingKey as String] as? Bool { out.isCharging = ch }
        }

        if let dict = IOPSCopyExternalPowerAdapterDetails()?.takeRetainedValue() as? [String: Any] {
            out.wattage     = (dict[kIOPSPowerAdapterWattsKey as String] as? NSNumber)?.intValue
            out.serial      = dict[kIOPSPowerAdapterSerialNumberKey as String] as? String
            out.description = dict[kIOPSPowerAdapterIDKey as String].map { "\($0)" }

            if let num = dict[kIOPSPowerAdapterFamilyKey as String] as? NSNumber {
                out.familyCode = num.uint32Value
            }
        }

        return out
    }
}
