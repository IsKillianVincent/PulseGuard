//
//  CoreWLANWifiReader.swift
//  PulseGuard
//
//  Created by Killian VINCENT on 24/08/2025.
//

import Foundation
import CoreWLAN
import os.log

public final class CoreWLANWifiReader: WifiReading {
    private let ifaceName: String?
    private let log = Logger(subsystem: "PulseGuard", category: "WiFi")

    public init(interfaceName: String? = nil) {
        self.ifaceName = interfaceName
    }
    
    public func current() -> WifiInfo {
        let client = CWWiFiClient.shared()

        guard let i = pickInterface(client) else {
            log.debug("No CWInterface available")
            return WifiInfo()
        }

        guard i.powerOn() else {
            log.debug("Wi-Fi power is OFF")
            return WifiInfo()
        }

        let ch = i.wlanChannel()
        let bandGHz: Double? = {
            switch ch?.channelBand {
            case .band2GHz: return 2.4
            case .band5GHz: return 5.0
            case .band6GHz: return 6.0
            default:        return nil
            }
        }()

        return WifiInfo(
            ssid:       i.ssid(),
            bssid:      i.bssid(),
            rssi:       i.rssiValue(),
            noise:      i.noiseMeasurement(),
            txRateMbps: i.transmitRate(),
            channel:    ch?.channelNumber,
            bandGHz:    bandGHz,
            security:   mapSecurity(i.security())
        )
    }

    private func mapSecurity(_ s: CWSecurity) -> String? {
        switch s {
        case .none:                           return "Open"
        case .dynamicWEP:                     return "WEP"
        case .wpaPersonal, .wpaPersonalMixed: return "WPA"
        case .wpa2Personal:                   return "WPA2"
        case .wpa3Personal:                   return "WPA3"
        case .wpaEnterprise:                  return "WPA-Ent"
        case .wpa2Enterprise:                 return "WPA2-Ent"
        case .wpa3Enterprise:                 return "WPA3-Ent"

        default:
            let raw = String(describing: s).lowercased()
            if raw.contains("owe") { return "OWE" }
            if raw.contains("wep") { return "WEP" }
            if raw.contains("enterprise") {
                if raw.contains("wpa3") { return "WPA3-Ent" }
                if raw.contains("wpa2") { return "WPA2-Ent" }
                if raw.contains("wpa")  { return "WPA-Ent"  }
            } else {
                if raw.contains("wpa3") { return "WPA3" }
                if raw.contains("wpa2") { return "WPA2" }
                if raw.contains("wpa")  { return "WPA"  }
            }
            return nil
        }
    }


    private func allInterfaces(_ client: CWWiFiClient) -> [CWInterface] {
        let rawAny: Any? = client.interfaces()
        guard let raw = rawAny else { return [] }

        if let arr = raw as? [CWInterface]    { return arr }
        if let set = raw as? Set<CWInterface> { return Array(set) }
        if let ns  = raw as? NSSet            { return ns.compactMap { $0 as? CWInterface } }
        if let na  = raw as? NSArray          { return na.compactMap { $0 as? CWInterface } }

        if let single = client.interface() { return [single] }
        return []
    }


    private func pickInterface(_ client: CWWiFiClient) -> CWInterface? {
        if let name = ifaceName, let byName = client.interface(withName: name) {
            return byName
        }

        let list = allInterfaces(client)
        if let best = list.first(where: { $0.powerOn() && $0.ssid() != nil }) { return best }
        if let on   = list.first(where: { $0.powerOn() })                     { return on }
        return list.first ?? client.interface()
    }
}
