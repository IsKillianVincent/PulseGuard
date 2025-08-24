//
//  NetworkCardView.swift
//  PulseGuard
//
//  Created by Killian VINCENT on 22/08/2025.
//

import SwiftUI

struct NetworkCardView: View {
    @ObservedObject var vm: NetworkViewModel

    var body: some View {
        SectionCard(title: "Network", icon: "antenna.radiowaves.left.and.right", accent: .pgBlue) {
            Text(vm.ifaceText)
                .font(.callout)
                .foregroundStyle(.secondary)
                .lineLimit(1)
                .truncationMode(.middle)
        } content: {
            VStack(spacing: Theme.spacing) {
                HStack(spacing: 10) {
                    StatTile(title: "Up",   value: vm.upText,   systemName: "arrow.up.circle")
                    StatTile(title: "Down", value: vm.downText, systemName: "arrow.down.circle")
                }
                HistoryLine(points: vm.history, accent: .pgBlue)
            }
        }
    }
}
