//
//  SectionHeader.swift
//  PulseGuard
//
//  Created by Killian VINCENT on 23/08/2025.
//


import SwiftUI

public struct SectionHeader: View {
    let title: LocalizedStringKey
    let systemImage: String

    public init(_ title: LocalizedStringKey, systemImage: String) {
        self.title = title
        self.systemImage = systemImage
    }

    public var body: some View {
        HStack(spacing: 8) {
            Image(systemName: systemImage)
                .font(.headline)
            Text(title)
                .font(.headline)
        }
        .textCase(nil)
        .padding(.bottom, 2)
        .accessibilityElement(children: .combine)
    }
}
