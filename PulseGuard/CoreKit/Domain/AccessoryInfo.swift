//
//  AccessoryInfo.swift
//  PulseGuard
//
//  Created by Killian VINCENT on 24/08/2025.
//

import Foundation

public struct AccessoryInfo: Identifiable, Equatable {
    public enum Connection: String { case bluetooth, usb, other }
    public enum Category: String { case keyboard, mouse, trackpad, headphones, other }

    public let id: String
    public let name: String
    public let connection: Connection
    public let category: Category

    public let batteryPercent: Int?
    public let isCharging: Bool?
    public let vendor: String?

    public let isConnected: Bool?
    public let rssi: Int?
    public let lastSeen: Date?

    public init(id: String,
                name: String,
                connection: Connection,
                category: Category,
                batteryPercent: Int? = nil,
                isCharging: Bool? = nil,
                vendor: String? = nil,
                isConnected: Bool? = nil,
                rssi: Int? = nil,
                lastSeen: Date? = nil) {
        self.id = id
        self.name = name
        self.connection = connection
        self.category = category
        self.batteryPercent = batteryPercent
        self.isCharging = isCharging
        self.vendor = vendor
        self.isConnected = isConnected
        self.rssi = rssi
        self.lastSeen = lastSeen
    }
}
