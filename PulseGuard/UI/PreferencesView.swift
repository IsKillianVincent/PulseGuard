//
//  PreferencesView.swift
//  PulseGuard
//
//  Created by Killian VINCENT on 22/08/2025.
//


import SwiftUI

struct PreferencesView: View {
    @ObservedObject var settings: SettingsStore

    var body: some View {
        Form {
            Section("Objectif batterie") {
                Stepper("Plancher idéal", value: $settings.lowerIdeal, in: 0...95)
                Stepper("Plafond idéal", value: $settings.upperIdeal, in: 5...100)
                Text("Conseil visuel pour préserver la batterie.").font(.caption).foregroundStyle(.secondary)
            }
            Section("Déclenchement (hystérésis)") {
                Stepper("Seuil BRANCHER (≤)", value: $settings.plugThreshold, in: 0...99)
                Stepper("Seuil DÉBRANCHER (≥)", value: $settings.unplugThreshold, in: 1...100)
                Text("Ex. 30/70 évite les notifications ping-pong.").font(.caption).foregroundStyle(.secondary)
            }
            Section("Fréquence de vérification") {
                Stepper("Intervalle (s)", value: Binding(
                    get: { Int(settings.pollInterval) },
                    set: { settings.pollInterval = TimeInterval($0) }
                ), in: 10...600, step: 5)
            }
        }
        .formStyle(.grouped)
        .navigationTitle("Préférences")
        .frame(width: 420)
        .padding()
    }
}
