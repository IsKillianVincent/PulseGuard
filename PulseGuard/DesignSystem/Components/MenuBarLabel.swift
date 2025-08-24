//
//  MenuBarLabel.swift
//  PulseGuard
//
//  Created by Killian VINCENT on 22/08/2025.
//

import SwiftUI

struct MenuBarLabel: View {
    @ObservedObject var batteryVM: BatteryViewModel
    var body: some View {
        HStack(spacing: 4) {
            if #available(macOS 14.0, *) {
                Image(systemName: "waveform.path.ecg")
                    .symbolRenderingMode(.hierarchical)
                    .foregroundStyle(batteryVM.menuTint)
                    .symbolEffect(.pulse, options: .repeating, value: batteryVM.shouldPulse)
                    .symbolEffect(.bounce, value: batteryVM.flashKey)
            } else {
                Image(systemName: "waveform.path.ecg")
                    .foregroundStyle(batteryVM.menuTint)
                    .scaleEffect(batteryVM.shouldPulse ? 1.08 : 1.0)
                    .animation(.easeInOut(duration: 0.9).repeatForever(autoreverses: true),
                               value: batteryVM.shouldPulse)
            }
        }
    }
}
