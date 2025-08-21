//
//  SystemCardView.swift
//  PulseGuard
//
//  Created by Killian VINCENT on 22/08/2025.
//


import SwiftUI

struct SystemCardView: View {
    @ObservedObject var vm: SystemViewModel

    var body: some View {
        SectionCard(title: "System", icon: "thermometer.medium", accent: vm.snapshot.stateColor) {
            Text(vm.snapshot.stateText)
                .font(.headline)
                .foregroundStyle(vm.snapshot.stateColor)
        } content: {
            HStack(spacing: Theme.spacing) {
                StatTile(title: "Thermal", value: vm.snapshot.stateText, systemName: "flame")
                    .foregroundStyle(vm.snapshot.stateColor)
                StatTile(title: "Uptime", value: vm.snapshot.uptimeText, systemName: "clock")
                Spacer()
            }
        }
    }
}
