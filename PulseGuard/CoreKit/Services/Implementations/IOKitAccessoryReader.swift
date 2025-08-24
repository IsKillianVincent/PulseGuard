//
//  IOKitAccessoryReader.swift
//  PulseGuard
//
//  Created by Killian VINCENT on 24/08/2025.
//

import Foundation
import IOKit

public final class IOKitAccessoryReader: AccessoryReading {
    public init() {}

    public func current() -> [AccessoryInfo] {
        var out: [AccessoryInfo] = []
        let match = IOServiceMatching("AppleDeviceManagementHIDEventService")
        var it: io_iterator_t = 0
        guard IOServiceGetMatchingServices(kIOMainPortDefault, match, &it) == KERN_SUCCESS else { return out }
        defer { IOObjectRelease(it) }

        func s(_ e: io_registry_entry_t, _ k: String) -> String? {
            IORegistryEntryCreateCFProperty(e, k as CFString, kCFAllocatorDefault, 0)?
                .takeRetainedValue() as? String
        }
        func n(_ e: io_registry_entry_t, _ k: String) -> NSNumber? {
            IORegistryEntryCreateCFProperty(e, k as CFString, kCFAllocatorDefault, 0)?
                .takeRetainedValue() as? NSNumber
        }
        func path(_ e: io_registry_entry_t) -> String? {
            var c = [CChar](repeating: 0, count: 512)
            let r = IORegistryEntryGetPath(e, kIOServicePlane, &c)
            return r == KERN_SUCCESS ? String(cString: c) : nil
        }
        func cat(_ name: String) -> AccessoryInfo.Category {
            let n = name.lowercased()
            if n.contains("keyboard") || n.contains("clavier") { return .keyboard }
            if n.contains("mouse")    || n.contains("souris")  { return .mouse }
            if n.contains("trackpad")                        { return .trackpad }
            if n.contains("airpods") || n.contains("head")   { return .headphones }
            return .other
        }

        var obj = IOIteratorNext(it)
        while obj != 0 {
            let name = s(obj, "Product") ?? s(obj, "ProductName") ?? "Accessory"
            let transport = (s(obj, "Transport") ?? "").lowercased()
            let connection: AccessoryInfo.Connection =
                transport == "usb" ? .usb : (transport == "bluetooth" ? .bluetooth : .other)
            let vendor = s(obj, "Manufacturer") ?? s(obj, "Vendor")
            let batt = (n(obj, "BatteryPercent") ?? n(obj, "BatteryPercentCase"))?.intValue
            let charging = (n(obj, "IsCharging"))?.boolValue
            let id = path(obj) ?? UUID().uuidString

            out.append(.init(
                id: id,
                name: name,
                connection: connection,
                category: cat(name),
                batteryPercent: batt.map { max(0, min(100, $0)) },
                isCharging: charging,
                vendor: vendor,
                isConnected: nil,
                rssi: nil,
                lastSeen: nil
            ))
            IOObjectRelease(obj)
            obj = IOIteratorNext(it)
        }

        return out.sorted { ($0.category.rawValue, $0.name.lowercased()) < ($1.category.rawValue, $1.name.lowercased()) }
    }
}
