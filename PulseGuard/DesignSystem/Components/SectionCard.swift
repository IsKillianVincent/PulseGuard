//
//  SectionCard.swift
//  PulseGuard
//
//  Created by Killian VINCENT on 22/08/2025.
//

import SwiftUI

struct SectionCard<Content: View, Trailing: View>: View {
    let title: String
    let icon: String
    var accent: Color = .pgBlue
    @ViewBuilder var trailing: () -> Trailing
    @ViewBuilder var content: () -> Content

    var body: some View {
        VStack(spacing: Theme.spacing) {
            HStack {
                Label(title, systemImage: icon)
                    .font(.headline)
                    .symbolVariant(.fill)
                Spacer()
                trailing()
            }
            content()
        }
        .padding(14)
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: Theme.radius, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: Theme.radius, style: .continuous)
                .stroke(Theme.stroke, lineWidth: 1)
        )
        .overlay(
            RoundedRectangle(cornerRadius: Theme.radius, style: .continuous)
                .stroke(LinearGradient(colors: [accent.opacity(0.45), .clear],
                                       startPoint: .topLeading, endPoint: .bottomTrailing),
                        lineWidth: 1.5)
                .blendMode(.overlay)
        )
        .shadow(color: Theme.shadow, radius: 12, y: 4)
    }
}
