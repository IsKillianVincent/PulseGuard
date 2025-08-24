//
//  ThermalSnapshot.swift
//  PulseGuard
//
//  Created by Killian VINCENT on 22/08/2025.
//

import Foundation
import SwiftUI

struct ThermalSnapshot: Equatable {
    let date: Date
    let state: ProcessInfo.ThermalState
    let uptime: TimeInterval

    var stateText: String {
        switch state {
        case .nominal: return "Nominal"
        case .fair:    return "Fair"
        case .serious: return "Serious"
        case .critical:return "Critical"
        @unknown default: return "Unknown"
        }
    }
    var stateColor: Color {
        switch state {
        case .critical: return .red
        case .serious:  return .orange
        case .fair:     return .yellow
        default:        return .green
        }
    }
    var uptimeText: String {
        let s = Int(uptime)
        let d = s / 86400, h = (s % 86400) / 3600, m = (s % 3600) / 60
        if d > 0 { return "\(d)d \(h)h" }
        if h > 0 { return "\(h)h\(String(format: "%02d", m))" }
        return "\(m) min"
    }
}
