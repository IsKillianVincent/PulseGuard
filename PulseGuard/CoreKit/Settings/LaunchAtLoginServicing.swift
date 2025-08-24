//
//  LaunchAtLoginServicing.swift
//  PulseGuard
//
//  Created by Killian VINCENT on 23/08/2025.
//

import Foundation
import ServiceManagement

protocol LaunchAtLoginServicing {
    var isEnabled: Bool { get }
    func setEnabled(_ enabled: Bool) throws
}

final class LaunchAtLoginService: LaunchAtLoginServicing {
    var isEnabled: Bool { SMAppService.mainApp.status == .enabled }

    func setEnabled(_ enabled: Bool) throws {
        if enabled {
            try SMAppService.mainApp.register()
        } else {
            try SMAppService.mainApp.unregister()
        }
    }
}
