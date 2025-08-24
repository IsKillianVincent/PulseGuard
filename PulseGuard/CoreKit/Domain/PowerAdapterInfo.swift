//
//  PowerAdapterInfo.swift
//  PulseGuard
//
//  Created by Killian VINCENT on 24/08/2025.
//


import Foundation

public struct PowerAdapterInfo: Equatable, Sendable {
    public var wattage: Int?
    public var isCharging: Bool?
    public var isACPresent: Bool?
    public var familyCode: UInt32?
    public var serial: String?
    public var description: String?

    public init(wattage: Int? = nil,
                isCharging: Bool? = nil,
                isACPresent: Bool? = nil,
                familyCode: UInt32? = nil,
                serial: String? = nil,
                description: String? = nil) {
        self.wattage = wattage
        self.isCharging = isCharging
        self.isACPresent = isACPresent
        self.familyCode = familyCode
        self.serial = serial
        self.description = description
    }
}
