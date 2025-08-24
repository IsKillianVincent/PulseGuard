//
//  BatteryHealthCardView.swift
//  PulseGuard
//
//  Created by Killian VINCENT on 22/08/2025.
//

import SwiftUI

struct BatteryHealthCardView: View {
    @ObservedObject var vm: BatteryHealthViewModel

    var body: some View {
        SectionCard(title: "Battery Health", icon: "heart.circle", accent: vm.accent) {
            Text(vm.health?.healthPercentText ?? "—")
                .font(.title3).monospacedDigit()
        } content: {
            VStack(spacing: Theme.spacing) {
                BarGauge(
                    progress: vm.health?.healthRatio ?? 0,
                    leftLabel: vm.health?.maxText ?? "—",
                    rightLabel: vm.health?.designText ?? "—",
                    accent: vm.accent
                )

                HStack(spacing: 10) {
                    StatTile(title: "Cycles",
                             value: vm.health.map { "\($0.cycleCount)" } ?? "—",
                             systemName: "arrow.triangle.2.circlepath")
                    StatTile(title: "Alimentation",
                             value: vm.health?.onACPower == true ? "Secteur" : "Batterie",
                             systemName: vm.health?.onACPower == true ? "powerplug" : "bolt.slash")
                    StatTile(title: "Charge",
                             value: vm.health?.isCharging == true ? "En cours" : "Aucune",
                             systemName: vm.health?.isCharging == true ? "bolt.fill" : "bolt.slash")
                }

                if let t = vm.tempText {
                    Label("Température \(t)", systemImage: "thermometer.medium")
                        .font(.caption).foregroundStyle(.secondary)
                }
            }
        }
    }
}
