//
//  LocationAuthorizer.swift
//  PulseGuard
//
//  Created by Killian VINCENT on 24/08/2025.
//

import Foundation
import CoreLocation

final class LocationAuthorizer: NSObject, CLLocationManagerDelegate {
    static let shared = LocationAuthorizer()

    private let manager = CLLocationManager()

    private override init() {
        super.init()
        manager.delegate = self
    }

    func ensureAuthorized() {
        if #available(macOS 11.0, *) {
            switch manager.authorizationStatus {
            case .notDetermined:
                manager.requestWhenInUseAuthorization()
            case .authorized, .authorizedWhenInUse, .authorizedAlways:
                kickLocationOnce()
            default:
                break
            }
        } else {
            let status = type(of: manager).authorizationStatus()
            if status == .notDetermined { manager.requestWhenInUseAuthorization() }
            else if status == .authorized { kickLocationOnce() }
        }
    }

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        if #available(macOS 11.0, *) {
            switch manager.authorizationStatus {
            case .authorized, .authorizedWhenInUse, .authorizedAlways:
                kickLocationOnce()
            default: break
            }
        }
    }

    private func kickLocationOnce() {
        // Démarre 1 seconde pour “réveiller” locationd et lever les restrictions SSID
        manager.startUpdatingLocation()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.manager.stopUpdatingLocation()
        }
    }
}
