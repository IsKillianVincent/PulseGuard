//
//  WifiInfo.swift
//  PulseGuard
//
//  Created by Killian VINCENT on 24/08/2025.
//

import Foundation

public struct WifiInfo: Equatable, Sendable {
    public var ssid: String?
    public var bssid: String?
    public var rssi: Int?
    public var noise: Int?
    public var txRateMbps: Double?
    public var channel: Int?
    public var bandGHz: Double?
    public var security: String?

    public init() {}

    public init(
        ssid: String? = nil,
        bssid: String? = nil,
        rssi: Int? = nil,
        noise: Int? = nil,
        txRateMbps: Double? = nil,
        channel: Int? = nil,
        bandGHz: Double? = nil,
        security: String? = nil
    ) {
        self.ssid = ssid
        self.bssid = bssid
        self.rssi = rssi
        self.noise = noise
        self.txRateMbps = txRateMbps
        self.channel = channel
        self.bandGHz = bandGHz
        self.security = security
    }
}
