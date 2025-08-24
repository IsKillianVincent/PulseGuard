//
//  Theme.swift
//  PulseGuard
//
//  Created by Killian VINCENT on 22/08/2025.
//

import SwiftUI

enum Theme {
    static let radius: CGFloat = 16
    static let radiusSm: CGFloat = 12
    static let spacing: CGFloat = 12

    static let stroke = Color.white.opacity(0.08)
    static let shadow = Color.black.opacity(0.18)
    static let shadowStrong = Color.black.opacity(0.28)
    static let grid = Color.primary.opacity(0.08)
}

extension Color {
    static let pgGreen  = Color.green
    static let pgOrange = Color.orange
    static let pgYellow = Color.yellow
    static let pgBlue   = Color.accentColor
}
