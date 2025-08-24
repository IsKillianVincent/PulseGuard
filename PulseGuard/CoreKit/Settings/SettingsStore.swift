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
    @Published var pollInterval: TimeInterval
    @Published var launchAtLogin: Bool

    private let repo: SettingsPersisting
    private let login: LaunchAtLoginServicing
    private var bag = Set<AnyCancellable>()

    init(
        repo: SettingsPersisting = UserDefaultsSettingsRepository(),
        login: LaunchAtLoginServicing = LaunchAtLoginService()
    ) {
        self.repo = repo
        self.login = login

        lowerIdeal     = repo.int(forKey: SettingsKeys.lowerIdeal,       default: 30)
        upperIdeal     = repo.int(forKey: SettingsKeys.upperIdeal,       default: 70)
        plugThreshold  = repo.int(forKey: SettingsKeys.plugThreshold,    default: 30)
        unplugThreshold = repo.int(forKey: SettingsKeys.unplugThreshold, default: 70)
        pollInterval   = repo.double(forKey: SettingsKeys.pollInterval,  default: 60)
        launchAtLogin  = repo.bool(forKey: SettingsKeys.launchAtLogin,   default: login.isEnabled)

        $lowerIdeal
            .map { min(max($0, 0), 100) }
            .sink { [weak self] in self?.repo.set($0, forKey: SettingsKeys.lowerIdeal) }
            .store(in: &bag)

        $upperIdeal
            .map { min(max($0, 0), 100) }
            .sink { [weak self] in self?.repo.set($0, forKey: SettingsKeys.upperIdeal) }
            .store(in: &bag)

        $plugThreshold
            .map { min(max($0, 0), 100) }
            .sink { [weak self] in self?.repo.set($0, forKey: SettingsKeys.plugThreshold) }
            .store(in: &bag)

        $unplugThreshold
            .map { min(max($0, 0), 100) }
            .sink { [weak self] in self?.repo.set($0, forKey: SettingsKeys.unplugThreshold) }
            .store(in: &bag)

        $pollInterval
            .map { max($0, 10) }
            .sink { [weak self] in self?.repo.set($0, forKey: SettingsKeys.pollInterval) }
            .store(in: &bag)

        $launchAtLogin
            .removeDuplicates()
            .sink { [weak self] enabled in
                guard let self else { return }
                do {
                    try self.login.setEnabled(enabled)
                    self.repo.set(enabled, forKey: SettingsKeys.launchAtLogin)
                } catch {
                    let sys = self.login.isEnabled
                    self.launchAtLogin = sys
                    self.repo.set(sys, forKey: SettingsKeys.launchAtLogin)
                    NSLog("LoginItem error: \(error.localizedDescription)")
                }
            }
            .store(in: &bag)
    }

    var effectivePolicy: ChargePolicy {
        let p = min(plugThreshold, unplugThreshold - 1)
        let u = max(unplugThreshold, p + 1)
        let low = min(lowerIdeal, u - 10)
        let high = max(upperIdeal, low + 10)
        return ChargePolicy(lowerIdeal: low, upperIdeal: high, plugThreshold: p, unplugThreshold: u)
    }

    func refreshLaunchAtLoginFromSystem() {
        launchAtLogin = login.isEnabled
    }
}
