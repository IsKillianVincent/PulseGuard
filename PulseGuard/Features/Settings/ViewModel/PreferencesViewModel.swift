//
//  PreferencesViewModel.swift
//  PulseGuard
//
//  Created by Killian VINCENT on 23/08/2025.
//

import SwiftUI
import Combine

@MainActor
final class PreferencesViewModel: ObservableObject {
    @Published var lowerIdeal: Int = 30
    @Published var upperIdeal: Int = 70
    @Published var plugThreshold: Int = 30
    @Published var unplugThreshold: Int = 70
    @Published var pollInterval: Int = 60
    @Published var launchAtLogin: Bool = false
    

    private let store: SettingsStore
    private var bag = Set<AnyCancellable>()
    private var isNormalizing = false

    init(store: SettingsStore) {
        self.store = store

        store.$lowerIdeal.removeDuplicates().assign(to: &$lowerIdeal)
        store.$upperIdeal.removeDuplicates().assign(to: &$upperIdeal)
        store.$plugThreshold.removeDuplicates().assign(to: &$plugThreshold)
        store.$unplugThreshold.removeDuplicates().assign(to: &$unplugThreshold)
        store.$pollInterval.map { Int($0) }.removeDuplicates().assign(to: &$pollInterval)
        store.$launchAtLogin.removeDuplicates().assign(to: &$launchAtLogin)

        $lowerIdeal.removeDuplicates().sink { [weak store] v in
            DispatchQueue.main.async { store?.lowerIdeal = v }
        }.store(in: &bag)

        $upperIdeal.removeDuplicates().sink { [weak store] v in
            DispatchQueue.main.async { store?.upperIdeal = v }
        }.store(in: &bag)

        $plugThreshold.removeDuplicates().sink { [weak store] v in
            DispatchQueue.main.async { store?.plugThreshold = v }
        }.store(in: &bag)

        $unplugThreshold.removeDuplicates().sink { [weak store] v in
            DispatchQueue.main.async { store?.unplugThreshold = v }
        }.store(in: &bag)

        $pollInterval.removeDuplicates().sink { [weak store] v in
            DispatchQueue.main.async { store?.pollInterval = TimeInterval(v) }
        }.store(in: &bag)

        $launchAtLogin.removeDuplicates().sink { [weak store] v in
            DispatchQueue.main.async { store?.launchAtLogin = v }
        }.store(in: &bag)
    }

    func refreshLoginState() {
        store.refreshLaunchAtLoginFromSystem()
    }
    
    func normalizeBatteryTargets(gap: Int = 5) {
        guard !isNormalizing else { return }
        isNormalizing = true
    
        lowerIdeal = min(max(lowerIdeal, 0), 95)
        upperIdeal = min(max(upperIdeal, 5), 100)
    
        if lowerIdeal > upperIdeal - gap { lowerIdeal = max(0, upperIdeal - gap) }
        if upperIdeal < lowerIdeal + gap { upperIdeal = min(100, lowerIdeal + gap) }
        isNormalizing = false
    }

    func normalizeHysteresis() {
        guard !isNormalizing else { return }
        isNormalizing = true
        plugThreshold = min(max(plugThreshold, 0), 99)
        unplugThreshold = min(max(unplugThreshold, 1), 100)
        if plugThreshold >= unplugThreshold {
            unplugThreshold = min(100, plugThreshold + 1)
        }
        isNormalizing = false
    }
}
