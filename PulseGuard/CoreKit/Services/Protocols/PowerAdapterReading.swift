//
//  PowerAdapterReading.swift
//  PulseGuard
//
//  Created by Killian VINCENT on 24/08/2025.
//


import Foundation

public protocol PowerAdapterReading {
    func current() -> PowerAdapterInfo
}
