//
//  BarGauge.swift
//  PulseGuard
//
//  Created by Killian VINCENT on 22/08/2025.
//

import SwiftUI

struct BarGauge: View {
    let progress: Double
    var leftLabel: String = ""
    var rightLabel: String = ""
    var accent: Color = .accentColor

    var a11yLabel: String? = nil
    var a11yValueText: String? = nil

    var body: some View {
        VStack(spacing: 6) {
            ZStack(alignment: .leading) {
                Capsule().fill(.quaternary).frame(height: 10)
                GeometryReader { geo in
                    let w = geo.size.width * max(0, min(progress, 1))
                    RoundedRectangle(cornerRadius: 5, style: .continuous)
                        .fill(
                            LinearGradient(colors: [accent.opacity(0.9), accent.opacity(0.4)],
                                           startPoint: .leading, endPoint: .trailing)
                        )
                        .frame(width: w, height: 10)
                        .overlay(alignment: .top) {
                            Rectangle().fill(.white.opacity(0.25)).frame(width: w, height: 1)
                                .blur(radius: 0.3)
                        }
                }
            }
            .frame(height: 10)

            HStack {
                Text(leftLabel).font(.caption).foregroundStyle(.secondary)
                Spacer()
                Text(rightLabel).font(.caption).foregroundStyle(.secondary)
            }
        }
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(Text(a11yLabel ?? leftLabel))
        .accessibilityValue(Text(a11yValueText ?? "\(Int(progress * 100))%"))
    }
}
