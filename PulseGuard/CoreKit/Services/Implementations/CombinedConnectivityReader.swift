//
//  CombinedConnectivityReader.swift
//  PulseGuard
//
//  Created by Killian VINCENT on 24/08/2025.
//

import Foundation

public final class CombinedConnectivityReader: ConnectivityReading {
    private let wifi: WifiReading
    private let internet: InternetReading

    public init(wifi: WifiReading, internet: InternetReading) {
        self.wifi = wifi
        self.internet = internet
    }

    public func current() -> ConnectivityInfo {
        var out = ConnectivityInfo()

        let net = internet.current()
        out.isOnline      = net.isOnline
        out.transport     = net.transport
        out.isExpensive   = net.isExpensive
        out.isConstrained = net.isConstrained

        let w = wifi.current()
        if let ssid = w.ssid {
            out.transport  = "Wi-Fi"
            out.ssid       = ssid
            out.bssid      = w.bssid
            out.rssi       = w.rssi
            out.txRateMbps = w.txRateMbps
            out.channel    = w.channel
            out.bandGHz    = w.bandGHz
            out.security   = w.security
        }
        return out
    }
}
