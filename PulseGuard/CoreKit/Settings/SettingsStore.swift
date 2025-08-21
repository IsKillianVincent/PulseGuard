//
//  SettingsStore.swift
//  PulseGuard
//
//  Created by Killian VINCENT on 22/08/2025.
//

import Foundation
import Combine

@MainActor
final class SettingsStore: ObservableObject {
    @Published var lowerIdeal: Int
    @Published var upperIdeal: Int
    @Published var plugThreshold: Int
    @Published var unplugThreshold: Int
    @Published var pollInterval: TimeInterval  // s

    private let defaults = UserDefaults.standard
    private var bag = Set<AnyCancellable>()

    init() {
        lowerIdeal = defaults.object(forKey: "lowerIdeal") as? Int ?? 30
        upperIdeal = defaults.object(forKey: "upperIdeal") as? Int ?? 70
        plugThreshold = defaults.object(forKey: "plugThreshold") as? Int ?? 30
        unplugThreshold = defaults.object(forKey: "unplugThreshold") as? Int ?? 70
        pollInterval = defaults.object(forKey: "pollInterval") as? Double ?? 60

        $lowerIdeal.map { min(max($0, 0), 100) }.sink { [weak self] v in self?.defaults.set(v, forKey: "lowerIdeal") }.store(in: &bag)
        $upperIdeal.map { min(max($0, 0), 100) }.sink { [weak self] v in self?.defaults.set(v, forKey: "upperIdeal") }.store(in: &bag)
        $plugThreshold.map { min(max($0, 0), 100) }.sink { [weak self] v in self?.defaults.set(v, forKey: "plugThreshold") }.store(in: &bag)
        $unplugThreshold.map { min(max($0, 0), 100) }.sink { [weak self] v in self?.defaults.set(v, forKey: "unplugThreshold") }.store(in: &bag)
        $pollInterval.map { max($0, 10) }.sink { [weak self] v in self?.defaults.set(v, forKey: "pollInterval") }.store(in: &bag)
    }

    var effectivePolicy: ChargePolicy {
        let p = min(plugThreshold, unplugThreshold - 1)
        let u = max(unplugThreshold, p + 1)
        let low = min(lowerIdeal, u - 10)
        let high = max(upperIdeal, low + 10)
        return ChargePolicy(lowerIdeal: low, upperIdeal: high, plugThreshold: p, unplugThreshold: u)
    }
}
