//
//  StorageCardView.swift
//  PulseGuard
//
//  Created by Killian VINCENT on 22/08/2025.
//

import SwiftUI

struct StorageCardView: View {
    @ObservedObject var vm: StorageViewModel

    var body: some View {
        SectionCard(title: "Storage", icon: "externaldrive", accent: .pgBlue) {
            Text("\(vm.vols.count) volume\(vm.vols.count > 1 ? "s" : "")")
                .foregroundStyle(.secondary)
        } content: {
            VStack(spacing: Theme.spacing) {
                ForEach(vm.vols) { v in
                    VStack(alignment: .leading, spacing: 6) {
                        HStack {
                            Text(v.name).fontWeight(.semibold)
                            Spacer()
                            Text("\(v.usedText) / \(v.totalText)")
                                .font(.caption).foregroundStyle(.secondary)
                        }
                        BarGauge(progress: v.usedRatio,
                                 leftLabel: "Used",
                                 rightLabel: v.freeText + " free",
                                 accent: .pgBlue)
                    }
                }
            }
        }
    }
}
