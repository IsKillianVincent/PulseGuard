//
//  DashboardView.swift
//  PulseGuard
//
//  Created by Killian VINCENT on 22/08/2025.
//

import SwiftUI
import AppKit

struct DashboardView: View {
    @ObservedObject var batteryVM: BatteryViewModel
    @ObservedObject var cpuVM: CPUViewModel
    @ObservedObject var settings: SettingsStore
    @ObservedObject var memoryVM: MemoryViewModel
    @ObservedObject var batteryHealthVM: BatteryHealthViewModel
    @ObservedObject var networkVM: NetworkViewModel
    @ObservedObject var systemVM: SystemViewModel
    @ObservedObject var storageVM: StorageViewModel

    var body: some View {
        ScrollView {
            VStack(spacing: Theme.spacing) {
                BatteryCardView(vm: batteryVM, settings: settings)
                BatteryHealthCardView(vm: batteryHealthVM)
                ProcessorCardView(vm: cpuVM)
                MemoryCardView(vm: memoryVM)
                NetworkCardView(vm: networkVM)
                SystemCardView(vm: systemVM)
                StorageCardView(vm: storageVM)

                HStack {
                    Button("Vérifier maintenant") { batteryVM.forceCheck() }
                    Spacer()
                    Menu {
                        Button("Silencer 30 min", systemImage: "bell.slash") { batteryVM.silence(for: 30 * 60) }
                        Button("Silencer 1 h",   systemImage: "bell.slash") { batteryVM.silence(for: 60 * 60) }
                        Button("Silencer 2 h",   systemImage: "bell.slash") { batteryVM.silence(for: 120 * 60) }
                        if batteryVM.isSilenced {
                            Divider()
                            Button("Réactiver", systemImage: "bell") { batteryVM.cancelSilence() }
                        }
                    } label: {
                        Label(batteryVM.isSilenced ? (batteryVM.silenceRemainingDescription ?? "Silence") : "Silencer",
                              systemImage: batteryVM.isSilenced ? "bell.slash" : "bell")
                    }
                    Button("Préférences…") { SettingsWindow.shared.show(settings: settings) }
                    Button("Quitter") { NSApplication.shared.terminate(nil) }
                }
                .font(.callout)
            }
            .padding(14)
        }
        .frame(width: 400, height: 560)
        .scrollIndicators(.automatic)
    }
}
