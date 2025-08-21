//
//  NetworkReader.swift
//  PulseGuard
//
//  Created by Killian VINCENT on 22/08/2025.
//


import Foundation

final class NetworkReader: NetworkReading {
    private struct Totals { let date: Date; let rx: UInt64; let tx: UInt64; let ifname: String; let ip: String? }
    private var last: Totals?

    func sample() -> NetworkSnapshot? {
        var ifaddrPtr: UnsafeMutablePointer<ifaddrs>?
        guard getifaddrs(&ifaddrPtr) == 0, let first = ifaddrPtr else { return nil }
        defer { freeifaddrs(ifaddrPtr) }

        var rx: UInt64 = 0, tx: UInt64 = 0
        var primaryName: String = "—"
        var primaryIP: String? = nil

        for ptr in sequence(first: first, next: { $0.pointee.ifa_next }) {
            let ifa = ptr.pointee
            let flags = Int32(ifa.ifa_flags)
            let running = (flags & (IFF_UP|IFF_RUNNING)) == (IFF_UP|IFF_RUNNING)
            let isLoop  = (flags & IFF_LOOPBACK) == IFF_LOOPBACK
            guard running && !isLoop else { continue }

            let name = String(cString: ifa.ifa_name)
            if let data = ifa.ifa_data?.assumingMemoryBound(to: if_data.self).pointee {
                rx &+= UInt64(data.ifi_ibytes)
                tx &+= UInt64(data.ifi_obytes)
            }

            // first IPv4 seen becomes "primary"
            if primaryIP == nil, ifa.ifa_addr.pointee.sa_family == UInt8(AF_INET) {
                var addr = [CChar](repeating: 0, count: Int(NI_MAXHOST))
                getnameinfo(ifa.ifa_addr, socklen_t(ifa.ifa_addr.pointee.sa_len),
                            &addr, socklen_t(addr.count), nil, 0, NI_NUMERICHOST)
                primaryIP = String(cString: addr)
                primaryName = name
            }
        }

        let now = Date()
        defer { last = Totals(date: now, rx: rx, tx: tx, ifname: primaryName, ip: primaryIP) }

        guard let l = last else {
            return NetworkSnapshot(date: now, interface: primaryName, address: primaryIP, upBps: 0, downBps: 0)
        }
        let dt = now.timeIntervalSince(l.date)
        guard dt > 0 else { return nil }
        let up   = Double(tx &- l.tx) / dt
        let down = Double(rx &- l.rx) / dt

        return NetworkSnapshot(date: now, interface: primaryName, address: primaryIP, upBps: max(0, up), downBps: max(0, down))
    }
}
