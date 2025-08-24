//
//  TargetBandView.swift
//  PulseGuard
//
//  Created by Killian VINCENT on 22/08/2025.
//

import SwiftUI

struct TargetBandView: View {
    let current: Int
    let lower: Int
    let upper: Int
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("Zone cible \(lower)–\(upper)%").font(.caption).foregroundStyle(.secondary)
            ZStack(alignment: .leading) {
                Capsule().frame(height: 6).foregroundStyle(.quaternary)
                GeometryReader { geo in
                    let w = geo.size.width
                    Capsule()
                        .frame(width: w * CGFloat(upper - lower) / 100.0, height: 6)
                        .offset(x: w * CGFloat(lower) / 100.0)
                        .foregroundStyle(.green.opacity(0.35))
                    Rectangle()
                        .frame(width: 2, height: 10)
                        .offset(x: w * CGFloat(min(max(current, 0), 100)) / 100.0 - 1, y: -2)
                        .foregroundStyle(.primary)
                }
            }
            .frame(height: 10)
        }
    }
}
