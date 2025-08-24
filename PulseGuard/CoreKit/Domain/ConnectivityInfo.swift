//
//  ConnectivityInfo.swift
//  PulseGuard
//
//  Created by Killian VINCENT on 24/08/2025.
//
//

import Foundation

public struct ConnectivityInfo: Equatable, Sendable {
    public init() {}
    public var isOnline: Bool = false
    public var transport: String?
    public var isExpensive: Bool?
    public var isConstrained: Bool?

    public var ssid: String?
    public var bssid: String?
    public var rssi: Int?
    public var txRateMbps: Double?
    public var channel: Int?
    public var bandGHz: Double?
    public var security: String?
}
