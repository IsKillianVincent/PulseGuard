//
//  WifiReading.swift
//  PulseGuard
//
//  Created by Killian VINCENT on 24/08/2025.
//

import Foundation

public protocol WifiReading {
    func current() -> WifiInfo
}
