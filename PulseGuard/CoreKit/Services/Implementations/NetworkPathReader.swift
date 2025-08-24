//
//  NetworkPathReader.swift
//  PulseGuard
//
//  Created by Killian VINCENT on 24/08/2025.
//

import Foundation
import Network

public final class NetworkPathReader: InternetReading {
    private let monitor = NWPathMonitor()
    private let queue   = DispatchQueue(label: "net.path.reader")

    private var status: NWPath.Status = .requiresConnection
    private var transport: String?
    private var expensive = false
    private var constrained = false

    public init() {
        monitor.pathUpdateHandler = { [weak self] path in
            guard let self else { return }
            self.status = path.status
            self.expensive = path.isExpensive
            if #available(macOS 12, *) { self.constrained = path.isConstrained }

            if path.usesInterfaceType(.wifi)            { self.transport = "Wi-Fi" }
            else if path.usesInterfaceType(.wiredEthernet) { self.transport = "Ethernet" }
            else if path.usesInterfaceType(.cellular)   { self.transport = "Cellular" }
            else if path.usesInterfaceType(.other)      { self.transport = "Other" }
            else                                        { self.transport = nil }
        }
        monitor.start(queue: queue)
    }

    public func current() -> InternetInfo {
        InternetInfo(isOnline: status == .satisfied,
                     transport: transport,
                     isExpensive: expensive,
                     isConstrained: constrained)
    }
}
