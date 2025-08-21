//
//  BatteryCardView.swift
//  PulseGuard
//
//  Created by Killian VINCENT on 22/08/2025.
//

import SwiftUI

struct BatteryCardView: View {
    @ObservedObject var vm: BatteryViewModel
    @ObservedObject var settings: SettingsStore

    var accent: Color { vm.menuTint }

    var body: some View {
        SectionCard(title: "Battery", icon: "battery.100", accent: accent) {
            HStack(spacing: 6) {
                Image(systemName: vm.menuIcon).foregroundStyle(accent)
                Text(vm.menuTitleShort).font(.title3).monospacedDigit().foregroundStyle(accent)
            }
        } content: {
            VStack(spacing: Theme.spacing) {
                HStack(spacing: 12) {
                    ProgressRing(progress: Double(vm.status?.levelPercent ?? 0) / 100.0,
                                 tint: accent, isPulsing: vm.shouldPulse)
                        .frame(width: 64, height: 64)

                    VStack(spacing: 10) {
                        BarGauge(progress: Double(vm.status?.levelPercent ?? 0) / 100.0,
                                 leftLabel: vm.status?.onACPower == true ? "AC Power" : "Battery",
                                 rightLabel: vm.detailLineShort,
                                 accent: accent)
                        TargetBandView(current: vm.status?.levelPercent ?? 0,
                                       lower: settings.effectivePolicy.lowerIdeal,
                                       upper: settings.effectivePolicy.upperIdeal)
                    }
                }

                HStack(spacing: 10) {
                    StatTile(title: "Conseil",
                             value: shortAdvice(vm.currentAdvice),
                             systemName: iconForAdvice(vm.currentAdvice))
                    StatTile(title: "Alimentation",
                             value: vm.status?.onACPower == true ? "Secteur" : "Batterie",
                             systemName: vm.status?.onACPower == true ? "powerplug" : "bolt.slash")
                    StatTile(title: "Charge",
                             value: vm.status?.isCharging == true ? "En cours" : "Aucune",
                             systemName: vm.status?.isCharging == true ? "bolt.fill" : "bolt.slash")
                }

                if let eta = vm.etaDescription {
                    Label(eta, systemImage: "clock")
                        .font(.caption).foregroundStyle(.secondary)
                }

                HistoryLine(points: vm.history, accent: accent)
            }
        }
    }

    private func shortAdvice(_ a: ChargeAdvice) -> String {
        switch a { case .plugIn: return "Brancher"; case .unplug: return "Débrancher"; case .keepAsIs: return "OK" }
    }
    private func iconForAdvice(_ a: ChargeAdvice) -> String {
        switch a { case .plugIn: return "powerplug"; case .unplug: return "bolt.slash"; case .keepAsIs: return "checkmark.circle" }
    }
}
