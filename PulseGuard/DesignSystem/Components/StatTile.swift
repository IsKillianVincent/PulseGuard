//
//  StatTile.swift
//  PulseGuard
//
//  Created by Killian VINCENT on 22/08/2025.
//

import SwiftUI

struct StatTile: View {
    let title: String
    let value: String
    var systemName: String? = nil

    var body: some View {
        VStack(spacing: 6) {
            if let s = systemName {
                Image(systemName: s).font(.caption).foregroundStyle(.secondary)
            }
            Text(value)
                .font(.title3).fontWeight(.semibold).monospacedDigit()
            Text(title)
                .font(.caption).foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 10)
        .background(.thickMaterial)
        .clipShape(RoundedRectangle(cornerRadius: Theme.radiusSm, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: Theme.radiusSm, style: .continuous)
                .stroke(Theme.stroke, lineWidth: 1)
        )
    }
}
