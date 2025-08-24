//
//  PulseGuardApp.swift
//  PulseGuard
//
//  Created by Killian VINCENT on 22/08/2025.
//

import SwiftUI

@main
struct PulseGuardApp: App {
    @StateObject private var env = AppEnvironment.makeLive()

    var body: some Scene {
        MenuBarExtra {
            DashboardView(
                batteryVM: env.batteryVM,
                cpuVM: env.cpuVM,
                settings: env.settings,
                memoryVM: env.memoryVM,
                batteryHealthVM: env.batteryHealthVM,
                networkVM: env.networkVM,
                systemVM: env.systemVM,
                storageVM: env.storageVM

            )
            .onAppear {
                env.batteryVM.start(pollInterval: env.settings.pollInterval)
                env.cpuVM.start(pollInterval: 0.1)
                env.memoryVM.start(pollInterval: 0.1)
                env.batteryHealthVM.start(pollInterval: 60)
                env.networkVM.start(pollInterval: 0.1)
                env.systemVM.start()
                env.storageVM.start(pollInterval: 30)
            }
            .onChange(of: env.settings.pollInterval) { _, v in
                env.batteryVM.start(pollInterval: v)
                env.cpuVM.start(pollInterval: v)
                env.memoryVM.start(pollInterval: v)
            }
        } label: {
            MenuBarLabel(batteryVM: env.batteryVM)
        }
        .menuBarExtraStyle(.window)

        Settings { PreferencesView(vm: PreferencesViewModel(store: env.settings)) }
            .commands { AppCommands(vm: env.batteryVM, settings: env.settings) }
    }
}
