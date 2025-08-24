//
//  IOBluetoothAccessoryReader.swift
//  PulseGuard
//
//  Created by Killian VINCENT on 24/08/2025.
//
import Foundation
import IOBluetooth

public final class IOBluetoothAccessoryReader: AccessoryReading {
    public init() {}

    public func current() -> [AccessoryInfo] {
        guard let list = IOBluetoothDevice.pairedDevices() as? [IOBluetoothDevice] else { return [] }

        let items: [AccessoryInfo] = list.compactMap { dev -> AccessoryInfo? in
            // Sur certaines versions c’est une MÉTHODE, pas une propriété
            guard dev.isConnected() else { return nil }

            let name = dev.name ?? "Bluetooth Device"

            // RSSI: 127 == invalide
            let rssiValue: Int? = {
                if dev.responds(to: NSSelectorFromString("rssi")) {
                    let v = Int(dev.rssi())   // <-- APPEL !
                    return v == 127 ? nil : v
                } else {
                    let v = Int(dev.rssi())
                    return v == 127 ? nil : v
                }
            }()

            return AccessoryInfo(
                id: dev.addressString ?? UUID().uuidString,
                name: name,
                connection: .bluetooth,
                category: Self.guessCategory(name),
                batteryPercent: nil,
                isCharging: nil,
                vendor: nil,
                isConnected: true,
                rssi: rssiValue,
                lastSeen: Date()
            )
        }

        return items.sorted { $0.name.lowercased() < $1.name.lowercased() }
    }

    private static func guessCategory(_ name: String) -> AccessoryInfo.Category {
        let n = name.lowercased()
        if n.contains("keyboard") || n.contains("clavier") { return .keyboard }
        if n.contains("mouse") || n.contains("souris")     { return .mouse }
        if n.contains("trackpad")                          { return .trackpad }
        if n.contains("airpods") || n.contains("head") || n.contains("buds") { return .headphones }
        return .other
    }
}
