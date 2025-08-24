//
//  PowerAdapterCardView.swift
//  PulseGuard
//
//  Created by Killian VINCENT on 24/08/2025.
//

//
//  PowerAdapterCardView.swift
//  PulseGuard
//

import SwiftUI

private func watts(_ w: Int?) -> String { w.map { "\($0) W" } ?? "—" }
private func yesNo(_ b: Bool?) -> String { (b ?? false) ? String(localized: "Oui") : String(localized: "Non") }
private func acState(_ b: Bool?) -> String { (b ?? false) ? String(localized: "Branché") : String(localized: "Débranché") }

struct PowerAdapterCardView: View {
    @ObservedObject var vm: PowerAdapterViewModel

    var body: some View {
        SectionCard(
            title: String(localized: "Adaptateur"),
            icon: "bolt.fill",
            trailing: { Text(acState(vm.info.isACPresent)) }
        ) {
            ViewThatFits(in: .horizontal) {
                HStack(spacing: Theme.spacing) { tiles }
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())],
                          spacing: Theme.spacing) { tiles }
            }
        }
    }

    @ViewBuilder private var tiles: some View {
        StatTile(title: String(localized: "Puissance"), value: watts(vm.info.wattage))
        StatTile(title: String(localized: "Charge"),    value: yesNo(vm.info.isCharging))
        StatTile(
            title: String(localized: "Famille"),
            // Pas d’ambiguïté : on passe l’Int? directement, l’overload s’en charge.
            value: PowerAdapterFamilyMapper.label(code: vm.info.familyCode,
                                                  watts: vm.info.wattage,
                                                  id: vm.info.description)
        )
        StatTile(title: String(localized: "S/N"), value: vm.info.serial ?? "—")
    }
}
