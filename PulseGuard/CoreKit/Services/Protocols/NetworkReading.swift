//
//  NetworkReading.swift
//  PulseGuard
//
//  Created by Killian VINCENT on 22/08/2025.
//

import Foundation

protocol NetworkReading {
    func sample() -> NetworkSnapshot?
}
