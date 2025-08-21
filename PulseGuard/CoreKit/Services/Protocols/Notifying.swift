//
//  Notifying.swift
//  PulseGuard
//
//  Created by Killian VINCENT on 22/08/2025.
//


import Foundation

protocol Notifying {
    func requestAuth(_ completion: ((Bool) -> Void)?)
    func notify(_ title: String, body: String)
}
