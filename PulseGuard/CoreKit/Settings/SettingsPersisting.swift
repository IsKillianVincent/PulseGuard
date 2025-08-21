//
//  SettingsPersisting.swift
//  PulseGuard
//
//  Created by Killian VINCENT on 23/08/2025.
//

import Foundation

protocol SettingsPersisting {
    func int(forKey key: String, default def: Int) -> Int
    func set(_ value: Int, forKey key: String)

    func double(forKey key: String, default def: Double) -> Double
    func set(_ value: Double, forKey key: String)

    func bool(forKey key: String, default def: Bool) -> Bool
    func set(_ value: Bool, forKey key: String)

    func stringArray(forKey key: String, default def: [String]) -> [String]
    func set(_ value: [String], forKey key: String)
}
