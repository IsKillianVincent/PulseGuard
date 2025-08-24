//
//  ConnectivityCardView.swift
//  PulseGuard
//
//  Created by Killian VINCENT on 24/08/2025.
//

import SwiftUI

private func dBm(_ v: Int?) -> String { v.map { "\($0) dBm" } ?? "—" }
private func rate(_ v: Double?) -> String { v.map { String(format: "%.0f Mb/s", $0) } ?? "—" }
private func band(_ g: Double?) -> String { g.map { String(format: "%.1f GHz", $0) } ?? "—" }

struct ConnectivityCardView: View {
    @ObservedObject var vm: ConnectivityViewModel

    var body: some View {
        SectionCard(
            title: String(localized: "Internet"),
            icon: "network",
            trailing: { Text(vm.info.isOnline ? (vm.info.transport ?? "—") : String(localized: "Hors ligne")) }
        ) {
            ViewThatFits(in: .horizontal) {
                HStack(spacing: Theme.spacing) { tiles }
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())],
                          spacing: Theme.spacing) { tiles }
            }
        }
    }

    @ViewBuilder private var tiles: some View {
        StatTile(title: String(localized: "Transport"), value: vm.info.transport ?? "—")
        StatTile(title: String(localized: "Réseau"),    value: vm.info.ssid ?? "—")
        StatTile(title: String(localized: "Signal"),    value: dBm(vm.info.rssi))
        StatTile(title: String(localized: "Débit"),     value: rate(vm.info.txRateMbps))
        StatTile(title: String(localized: "Canal"),     value: {
            if let c = vm.info.channel, let g = vm.info.bandGHz { return "\(c) (\(band(g)))" }
            if let c = vm.info.channel { return "\(c)" }
            return "—"
        }())
        StatTile(title: String(localized: "Sécurité"),  value: vm.info.security ?? "—")
    }
}
