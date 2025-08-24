//
//  MemoryCardView.swift
//  PulseGuard
//
//  Created by Killian VINCENT on 22/08/2025.
//

import SwiftUI

struct MemoryCardView: View {
    @ObservedObject var vm: MemoryViewModel

    var body: some View {
        SectionCard(title: "Memory", icon: "memorychip", accent: .pgBlue) {
            Text(vm.snapshot?.usedPercentText ?? "— %")
                .font(.title3).monospacedDigit()
        } content: {
            VStack(spacing: Theme.spacing) {
                BarGauge(progress: vm.snapshot?.usedRatio ?? 0,
                         leftLabel: vm.snapshot?.usedText ?? "",
                         rightLabel: vm.snapshot?.totalText ?? "",
                         accent: .pgBlue)

                HStack(spacing: 10) {
                    StatTile(title: "Free", value: vm.snapshot?.freeText ?? "—", systemName: "checkmark.circle")
                    StatTile(title: "Wired", value: ByteCountFormatter.string(fromByteCount: Int64(vm.snapshot?.wiredBytes ?? 0), countStyle: .binary), systemName: "bolt.fill")
                    StatTile(title: "Compressed", value: ByteCountFormatter.string(fromByteCount: Int64(vm.snapshot?.compressedBytes ?? 0), countStyle: .binary), systemName: "arrow.down.circle")
                }

                HStack {
                    Label("Pressure: \(vm.snapshot?.pressure.rawValue ?? "—")", systemImage: "gauge")
                        .foregroundStyle(vm.pressureColor)
                    Spacer()
                }
                HistoryLine(points: vm.history, accent: .pgBlue)
            }
        }
    }
}
