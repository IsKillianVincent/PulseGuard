//
//  AccessoriesCardView.swift
//  PulseGuard
//
//  Created by Killian VINCENT on 24/08/2025.
//

import SwiftUI

private func pct(_ v: Int?) -> String { v.map { "\($0)%" } ?? "—" }
private func conn(_ c: AccessoryInfo.Connection) -> String { c == .bluetooth ? "Bluetooth" : (c == .usb ? "USB" : "—") }
private func rssiText(_ r: Int?) -> String { r.map { "\($0) dBm" } ?? "—" }
private func yesNo(_ b: Bool?) -> String { (b ?? false) ? String(localized: "Oui") : String(localized: "Non") }

private func iconName(for a: AccessoryInfo) -> String {
    switch a.category {
    case .keyboard: return "keyboard"
    case .mouse: return "mouse"
    case .trackpad: return "trackpad.2"
    case .headphones: return "headphones"
    case .other: return "puzzlepiece.extension"
    }
}

private func lastSeenText(_ d: Date?) -> String {
    guard let d else { return "—" }
    let minutes = max(0, Int(Date().timeIntervalSince(d) / 60))
    return minutes == 0 ? String(localized: "à l’instant") : String(localized: "\(minutes) min")
}

struct AccessoriesCardView: View {
    @ObservedObject var vm: AccessoriesViewModel

    var body: some View {
        SectionCard(
            title: String(localized: "section.accessories"),
            icon: "puzzlepiece.extension",
            trailing: { Text("\(vm.accessories.count)") }
        ) {
            if vm.accessories.isEmpty {
                Text(String(localized: "accessories.none"))
                    .font(.callout).foregroundStyle(.secondary)
                    .frame(maxWidth: .infinity, alignment: .leading)
            } else {
                VStack(spacing: Theme.spacing) {
                    ForEach(vm.accessories) { a in
                        VStack(alignment: .leading, spacing: 10) {
                            Label {
                                VStack(alignment: .leading, spacing: 2) {
                                    Text(a.name).font(.headline).lineLimit(1)
                                    Text(a.vendor ?? a.category.rawValue.capitalized)
                                        .font(.caption).foregroundStyle(.secondary)
                                }
                            } icon: {
                                Image(systemName: iconName(for: a)).font(.title3)
                            }

                            ViewThatFits(in: .horizontal) {
                                HStack(spacing: Theme.spacing) { tiles(a) }
                                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())],
                                          spacing: Theme.spacing) {
                                    tiles(a)
                                }
                            }
                        }
                        .padding(10)
                        .background(.quaternary.opacity(0.15), in: RoundedRectangle(cornerRadius: 12))
                    }
                }
            }
        }
    }

    @ViewBuilder private func tiles(_ a: AccessoryInfo) -> some View {
        StatTile(title: String(localized: "Batterie"),  value: pct(a.batteryPercent))
        StatTile(title: String(localized: "Liaison"),   value: conn(a.connection))
        StatTile(title: String(localized: "Signal"),    value: rssiText(a.rssi))
        StatTile(title: String(localized: "Connecté"),  value: yesNo(a.isConnected))
        StatTile(title: String(localized: "Vu"),        value: lastSeenText(a.lastSeen))
    }
}
