//
//  AppCommands.swift
//  PulseGuard
//
//  Created by Killian VINCENT on 22/08/2025.
//


import SwiftUI

struct AppCommands: Commands {
    @ObservedObject var vm: BatteryViewModel
    @ObservedObject var settings: SettingsStore

    var body: some Commands {
        CommandMenu("PulseGuard") {
            Button("Préférences…") { SettingsWindow.shared.show(settings: settings) }
                .keyboardShortcut(",", modifiers: .command)

            Button("Vérifier maintenant") { vm.forceCheck() }
                .keyboardShortcut("r", modifiers: [.command, .shift])

            if vm.isSilenced {
                Button("Réactiver les notifications") { vm.cancelSilence() }
                    .keyboardShortcut("s", modifiers: [.command, .option, .shift])
            } else {
                Button("Silencer 1 h") { vm.silence(for: 60 * 60) }
                    .keyboardShortcut("s", modifiers: [.command, .option, .shift])
            }
        }
    }
}
