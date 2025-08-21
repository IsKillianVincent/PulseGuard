//
//  PreferencesView.swift
//  PulseGuard
//
//  Created by Killian VINCENT on 23/08/2025.
//

import SwiftUI

struct PreferencesView: View {
    @ObservedObject var vm: PreferencesViewModel
    var body: some View {
        Form {
            Section { GeneralSection(vm: vm) } header: { SectionHeader("prefs.general",systemImage: "gearshape") }
            Section { BatteryTargetSection(vm: vm) } header: { SectionHeader("prefs.battery.title", systemImage: "battery.100") }
            Section { HysteresisSection(vm: vm) } header: { SectionHeader("prefs.hysteresis.title", systemImage: "arrow.triangle.2.circlepath") }
            Section { PollingSection(vm: vm) } header: { SectionHeader("prefs.poll.title", systemImage: "clock.arrow.circlepath") }
        }
        .formStyle(.grouped)
        .navigationTitle("common.preferences")
        .frame(width: 560)
        .padding(.vertical, 8)
        .onAppear { vm.refreshLoginState() }
    }
}
