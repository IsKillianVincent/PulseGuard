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
    @ObservedObject var graphicsVM: GraphicsViewModel
    @ObservedObject var displaysVM: DisplaysViewModel
    @ObservedObject var accessoriesVM: AccessoriesViewModel
    @ObservedObject var powerVM: PowerAdapterViewModel
    @ObservedObject var connectivityVM: ConnectivityViewModel

    @Environment(\.openSettings) private var openSettings

    var body: some View {
        ScrollView {
            VStack(spacing: Theme.spacing) {
                BatteryCardView(vm: batteryVM, settings: settings)
                BatteryHealthCardView(vm: batteryHealthVM)
                ProcessorCardView(vm: cpuVM)
                MemoryCardView(vm: memoryVM)
                GraphicsCardView(vm: graphicsVM)
                NetworkCardView(vm: networkVM)
                SystemCardView(vm: systemVM)
                StorageCardView(vm: storageVM)
                DisplaysCardView(vm: displaysVM)
                AccessoriesCardView(vm: accessoriesVM)
                ConnectivityCardView(vm: connectivityVM)
                PowerAdapterCardView(vm: powerVM)

                HStack {
                    Button(String(localized: "ui.checkNow")) { batteryVM.forceCheck() }
                    Spacer()
                    Menu {
                        Button(String(localized: "ui.silence.30"), systemImage: "bell.slash") { batteryVM.silence(for: 30*60) }
                        Button(String(localized: "ui.silence.60"), systemImage: "bell.slash") { batteryVM.silence(for: 60*60) }
                        Button(String(localized: "ui.silence.120"), systemImage: "bell.slash") { batteryVM.silence(for: 120*60) }
                        if batteryVM.isSilenced {
                            Divider()
                            Button(String(localized: "ui.unsilence"), systemImage: "bell") { batteryVM.cancelSilence() }
                        }
                    } label: {
                        Label(batteryVM.isSilenced ? (batteryVM.silenceRemainingDescription ?? "Silence")
                                                   : String(localized: "ui.silence"),
                              systemImage: batteryVM.isSilenced ? "bell.slash" : "bell")
                    }
                    Button(String(localized: "ui.preferences")) { openSettings() }
                    Button(String(localized: "ui.quit")) { NSApplication.shared.terminate(nil) }
                }
                .font(.callout)
            }
            .padding(14)
        }
        .frame(width: 400, height: 560)
        .scrollIndicators(.automatic)
    }
}
