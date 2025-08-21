//
//  HistoryPoint.swift
//  PulseGuard
//
//  Created by Killian VINCENT on 22/08/2025.
//

import SwiftUI

struct HistoryPoint: Identifiable { let id = UUID(); let date: Date; let value: Double }

struct HistoryLine: View {
    let points: [HistoryPoint]
    var accent: Color = .accentColor

    var body: some View {
        ZStack {
            // grille
            VStack(spacing: 0) {
                ForEach(0..<4) { _ in
                    Rectangle().fill(Theme.grid).frame(height: 1)
                    Spacer()
                }
                Rectangle().fill(Theme.grid).frame(height: 1)
            }
            .padding(.vertical, 6)

            // aire + ligne
            Canvas { ctx, size in
                guard points.count >= 2 else { return }
                let xs = points.map(\.date.timeIntervalSince1970)
                let ys = points.map(\.value)
                guard let minX = xs.first, let maxX = xs.last else { return }
                let minY = ys.min() ?? 0, maxY = ys.max() ?? 100

                var line = Path()
                var fill = Path()
                for i in points.indices {
                    let x = CGFloat((xs[i] - minX) / max(0.0001, (maxX - minX))) * size.width
                    let y = size.height - CGFloat((ys[i] - minY) / max(1, (maxY - minY))) * size.height
                    if i == 0 {
                        line.move(to: CGPoint(x: x, y: y))
                        fill.move(to: CGPoint(x: x, y: size.height))
                        fill.addLine(to: CGPoint(x: x, y: y))
                    } else {
                        line.addLine(to: CGPoint(x: x, y: y))
                        fill.addLine(to: CGPoint(x: x, y: y))
                    }
                }
                fill.addLine(to: CGPoint(x: size.width, y: size.height))
                fill.closeSubpath()

                ctx.fill(fill, with: .linearGradient(
                    Gradient(colors: [accent.opacity(0.18), .clear]),
                    startPoint: CGPoint(x: 0, y: 0),
                    endPoint: CGPoint(x: 0, y: size.height))
                )
                ctx.stroke(line, with: .color(accent.opacity(0.9)), lineWidth: 1.6)
            }
        }
        .frame(height: 90)
        .background(Color.secondary.opacity(0.04))
        .clipShape(RoundedRectangle(cornerRadius: Theme.radiusSm, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: Theme.radiusSm, style: .continuous)
                .stroke(Theme.stroke, lineWidth: 1)
        )
    }
}
