//
//  NetworkSnapshot.swift
//  PulseGuard
//
//  Created by Killian VINCENT on 22/08/2025.
//

import Foundation

struct NetworkSnapshot: Equatable {
    let date: Date
    let interface: String
    let address: String?
    let upBps: Double
    let downBps: Double
}
