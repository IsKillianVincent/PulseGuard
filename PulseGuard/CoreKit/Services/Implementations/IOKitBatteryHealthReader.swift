//
//  IOKitBatteryHealthReader.swift
//  PulseGuard
//
//  Created by Killian VINCENT on 22/08/2025.
//


import Foundation
import IOKit.ps
import IOKit

final class IOKitBatteryHealthReader: BatteryHealthReading {

    func read() -> BatteryHealth? {
        return readViaIORegistry() ?? readViaPowerSources()
    }

    private func readViaPowerSources() -> BatteryHealth? {
        guard let snap = IOPSCopyPowerSourcesInfo()?.takeRetainedValue(),
              let list = IOPSCopyPowerSourcesList(snap)?.takeRetainedValue() as? [CFTypeRef]
        else { return nil }

        let onAC = (IOPSGetProvidingPowerSourceType(snap)?.takeRetainedValue() as String?) == kIOPSACPowerValue

        for src in list {
            guard let desc = IOPSGetPowerSourceDescription(snap, src)?
                    .takeUnretainedValue() as? [String: Any],
                  (desc[kIOPSTypeKey] as? String) == kIOPSInternalBatteryType
            else { continue }

            let maxCap  = (desc[kIOPSMaxCapacityKey] as? Int) ?? (desc["MaxCapacity"] as? Int ?? 0)
            let charging = (desc[kIOPSIsChargingKey] as? Bool) ?? false

            let design  = (desc["DesignCapacity"] as? Int) ?? 0
            let cycles  = (desc["CycleCount"] as? Int) ?? 0
            let tempC: Double? = nil

            if maxCap > 0 || design > 0 || cycles > 0 {
                return BatteryHealth(date: Date(),
                                     cycleCount: cycles,
                                     designCapacitymAh: design,
                                     maxCapacitymAh: maxCap,
                                     onACPower: onAC,
                                     isCharging: charging,
                                     temperatureC: tempC)
            }
        }
        return nil
    }

    private func firstInt(_ dict: [String: Any], _ keys: [String]) -> Int {
        for k in keys {
            if let v = dict[k] as? Int, v > 0 { return v }
        }
        return 0
    }

    private func readViaIORegistry() -> BatteryHealth? {
        let svc = IOServiceGetMatchingService(kIOMainPortDefault, IOServiceMatching("AppleSmartBattery"))
        guard svc != 0 else { return nil }
        defer { IOObjectRelease(svc) }

        var unmanaged: Unmanaged<CFMutableDictionary>?
        guard IORegistryEntryCreateCFProperties(svc, &unmanaged, kCFAllocatorDefault, 0) == KERN_SUCCESS,
              let dict = unmanaged?.takeRetainedValue() as? [String: Any]
        else { return nil }

        let maxRaw = firstInt(dict, ["AppleRawMaxCapacity", "AppleRawFullChargeCapacity"])
        let maxCap = maxRaw > 0 ? maxRaw : firstInt(dict, ["MaxCapacity", "FullChargeCapacity"])

        var design = firstInt(dict, ["AppleRawDesignCapacity"])
        if design == 0 { design = firstInt(dict, ["NominalChargeCapacity"]) }
        if design == 0 { design = firstInt(dict, ["DesignCapacity"]) }

        if design > 0, design <= 200, maxCap > 2000 {
            let nominal = firstInt(dict, ["NominalChargeCapacity"])
            design = nominal > 0 ? nominal : max(maxCap, design)
        }

        let cycles   = firstInt(dict, ["CycleCount"])
        let charging = (dict["IsCharging"] as? Bool) ?? false
        let onAC     = (dict["ExternalConnected"] as? Bool) ?? false

        var tempC: Double? = nil
        if let t = dict["Temperature"] as? Int { tempC = Double(t) / 10.0 - 273.15 }

        if design == 0 && maxCap == 0 && cycles == 0 { return nil }

        return BatteryHealth(date: Date(),
                             cycleCount: cycles,
                             designCapacitymAh: design,
                             maxCapacitymAh: maxCap,
                             onACPower: onAC,
                             isCharging: charging,
                             temperatureC: tempC)
    }

}
