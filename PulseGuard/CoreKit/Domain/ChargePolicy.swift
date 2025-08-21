//
//  ChargePolicy.swift
//  PulseGuard
//
//  Created by Killian VINCENT on 22/08/2025.
//

import Foundation
import SwiftUICore

struct ChargePolicy: Equatable {
    let lowerIdeal: Int
    let upperIdeal: Int
    let plugThreshold: Int
    let unplugThreshold: Int

    func advice(for s: BatteryStatus) -> ChargeAdvice {
        if s.levelPercent <= plugThreshold && !s.onACPower { return .plugIn }
        if s.levelPercent >= unplugThreshold && s.onACPower { return .unplug }
        return .keepAsIs
    }
}

enum ChargeAdvice: Equatable {
    case plugIn, unplug, keepAsIs

    var localized: LocalizedStringKey {
        switch self {
        case .plugIn:   return "advice.plugIn"
        case .unplug:   return "advice.unplug"
        case .keepAsIs: return "advice.keep"
        }
    }
}
