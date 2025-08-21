
//
//  GeneralSection.swift
//  PulseGuard
//
//  Created by Killian VINCENT on 23/08/2025.
//

import SwiftUI

struct GeneralSection: View {
    @ObservedObject var vm: PreferencesViewModel
    var body: some View {
        Toggle("prefs.launchAtLogin", isOn: $vm.launchAtLogin)
            .accessibilityIdentifier("toggle-launch-at-login")
            .help(Text("prefs.launchAtLogin.help"))
    }
}

struct BatteryTargetSection: View {
    @ObservedObject var vm: PreferencesViewModel
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            LabeledStepperRow(titleKey: "prefs.battery.lower",
                              value: $vm.lowerIdeal,
                              range: 0...95,
                              unitSuffix: "%")
            Divider()
            LabeledStepperRow(titleKey: "prefs.battery.upper",
                              value: $vm.upperIdeal,
                              range: 5...100,
                              unitSuffix: "%")
            Divider()
            SectionNote(text: "prefs.battery.note")
                .padding(.top, 2)
        }
    }
}

struct HysteresisSection: View {
    @ObservedObject var vm: PreferencesViewModel
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            LabeledStepperRow(titleKey: "prefs.hysteresis.plug",
                              value: $vm.plugThreshold,
                              range: 0...99,
                              unitSuffix: "%")
            Divider()
            LabeledStepperRow(titleKey: "prefs.hysteresis.unplug",
                              value: $vm.unplugThreshold,
                              range: 1...100,
                              unitSuffix: "%")
            Divider()
            SectionNote(text: "prefs.hysteresis.note")
                .padding(.top, 2)
        }
    }
}

struct PollingSection: View {
    @ObservedObject var vm: PreferencesViewModel
    var body: some View {
        LabeledStepperRow(titleKey: "prefs.poll.interval",
                          value: $vm.pollInterval,
                          range: 10...600,
                          step: 5,
                          unitSuffix: "s")
    }
}

struct SectionNote: View {
    let text: LocalizedStringKey
    var body: some View {
        Text(text)
            .font(.caption)
            .foregroundStyle(.secondary)
            .fixedSize(horizontal: false, vertical: true)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
}
