//
//  ProgressRing.swift
//  PulseGuard
//
//  Created by Killian VINCENT on 22/08/2025.
//

import SwiftUI

struct ProgressRing: View {
    let progress: Double  // 0...1
    let tint: Color
    let isPulsing: Bool

    var body: some View {
        ZStack {
            Circle().strokeBorder(.quaternary, lineWidth: 7)

            // Anneau dégradé + léger glow
            Canvas { ctx, size in
                let rect = CGRect(origin: .zero, size: size).insetBy(dx: 3.5, dy: 3.5)
                var path = Path()
                path.addArc(center: CGPoint(x: rect.midX, y: rect.midY),
                            radius: rect.width/2,
                            startAngle: .degrees(-90),
                            endAngle: .degrees(-90 + 360 * progress),
                            clockwise: false)
                let gradient = Gradient(colors: [tint, tint.opacity(0.35)])
                ctx.stroke(path, with: .conicGradient(gradient, center: .init(x: rect.midX, y: rect.midY)), lineWidth: 7)
            }
            .shadow(color: tint.opacity(0.35), radius: 4)

            // Icône centrale
            if #available(macOS 14.0, *) {
                Image(systemName: "waveform.path.ecg")
                    .symbolRenderingMode(.hierarchical)
                    .foregroundStyle(tint)
                    .symbolEffect(.pulse, options: .repeating, value: isPulsing)
            } else {
                Image(systemName: "waveform.path.ecg")
                    .foregroundStyle(tint)
                    .scaleEffect(isPulsing ? 1.06 : 1.0)
                    .animation(.easeInOut(duration: 0.9).repeatForever(autoreverses: true), value: isPulsing)
            }
        }
        .animation(.easeInOut(duration: 0.25), value: progress)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(Text("a11y.battery.level"))
        .accessibilityValue(Text("\(Int(round(progress * 100)))%"))
    }
}
