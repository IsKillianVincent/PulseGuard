//
//  CombinedAccessoryReader.swift
//  PulseGuard
//
//  Created by Killian VINCENT on 24/08/2025.
//

import Foundation

public final class CombinedAccessoryReader: AccessoryReading {
    private let readers: [any AccessoryReading]

    public init(_ readers: [any AccessoryReading]) {
        self.readers = readers
    }

    // Varargs pratique
    public convenience init(_ readers: any AccessoryReading...) {
        self.init(readers)
    }

    public func current() -> [AccessoryInfo] {
        func key(_ s: String) -> String {
            s.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        }
        var merged: [String: AccessoryInfo] = [:]

        for r in readers {
            for item in r.current() {
                let k = key(item.name)
                if var base = merged[k] {
                    base = AccessoryInfo(
                        id: base.id,
                        name: base.name,
                        connection: (base.connection == .bluetooth || item.connection == .bluetooth) ? .bluetooth : base.connection,
                        category: base.category == .other ? item.category : base.category,
                        batteryPercent: base.batteryPercent ?? item.batteryPercent,
                        isCharging: base.isCharging ?? item.isCharging,
                        vendor: base.vendor ?? item.vendor,
                        isConnected: item.isConnected ?? base.isConnected,
                        rssi: item.rssi ?? base.rssi,
                        lastSeen: [base.lastSeen, item.lastSeen].compactMap { $0 }.max()
                    )
                    merged[k] = base
                } else {
                    merged[k] = item
                }
            }
        }

        return Array(merged.values).sorted {
            ( ($0.isConnected ?? false) ? 0 : 1, $0.name.lowercased() ) <
            ( ($1.isConnected ?? false) ? 0 : 1, $1.name.lowercased() )
        }
    }
}
