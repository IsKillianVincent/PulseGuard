//
//  InternetInfo.swift
//  PulseGuard
//
//  Created by Killian VINCENT on 24/08/2025.
//

import Foundation

public struct InternetInfo: Equatable, Sendable {
    public var isOnline: Bool = false
    public var transport: String?
    public var isExpensive: Bool?
    public var isConstrained: Bool?

    public init() {}

    public init(
        isOnline: Bool = false,
        transport: String? = nil,
        isExpensive: Bool? = nil,
        isConstrained: Bool? = nil
    ) {
        self.isOnline = isOnline
        self.transport = transport
        self.isExpensive = isExpensive
        self.isConstrained = isConstrained
    }
}
