//
//  MemoryReading.swift
//  PulseGuard
//
//  Created by Killian VINCENT on 22/08/2025.
//


import Foundation

protocol MemoryReading {
    func sample() -> MemorySnapshot?
}
