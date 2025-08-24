//
//  UserDefaultsSettingsRepository.swift
//  PulseGuard
//
//  Created by Killian VINCENT on 23/08/2025.
//


import Foundation

final class UserDefaultsSettingsRepository: SettingsPersisting {
    private let ud: UserDefaults
    init(_ ud: UserDefaults = .standard) { self.ud = ud }

    func int(forKey key: String, default def: Int) -> Int { (ud.object(forKey: key) as? Int) ?? def }
    func set(_ value: Int, forKey key: String) { ud.set(value, forKey: key) }

    func double(forKey key: String, default def: Double) -> Double { (ud.object(forKey: key) as? Double) ?? def }
    func set(_ value: Double, forKey key: String) { ud.set(value, forKey: key) }

    func bool(forKey key: String, default def: Bool) -> Bool { (ud.object(forKey: key) as? Bool) ?? def }
    func set(_ value: Bool, forKey key: String) { ud.set(value, forKey: key) }

    func stringArray(forKey key: String, default def: [String]) -> [String] { ud.stringArray(forKey: key) ?? def }
    func set(_ value: [String], forKey key: String) { ud.set(value, forKey: key) }
}
