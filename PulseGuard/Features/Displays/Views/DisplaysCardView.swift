//
//  DisplaysCardView.swift
//  PulseGuard
//
//  Created by Killian VINCENT on 24/08/2025.
//

import SwiftUI

private func fmtRes(_ s: CGSize) -> String { "\(Int(s.width)) × \(Int(s.height))" }

private func friendlyColorSpace(_ raw: String?) -> String {
    guard let raw = raw?.lowercased() else { return "—" }
    if raw.contains("p3") { return "P3" }
    if raw.contains("srgb") { return "sRGB" }
    if raw.contains("lcd couleur") || raw.contains("color lcd") { return "sRGB" }
    return raw
        .replacingOccurrences(of: "colorspace", with: "")
        .replacingOccurrences(of: "color space", with: "")
        .trimmingCharacters(in: .whitespacesAndNewlines)
        .capitalized
}

private func refreshText(_ hz: Double?) -> String {
    guard let hz else { return "—" }
    return String(format: "%.0f Hz", hz)
}

private func hidpiText(scale: CGFloat, isHiDPI: Bool) -> String {
    isHiDPI ? "@\(Int(round(scale)))x" : "1x"
}

struct DisplaysCardView: View {
    @ObservedObject var vm: DisplaysViewModel

    private let minItemWidth: CGFloat = 320
    private let s = Theme.spacing

    var body: some View {
        SectionCard(
            title: String(localized: "section.displays"),
            icon: "display.2",
            trailing: { Text("\(vm.displays.count)") }
        ) {
            let maxGridWidth = (minItemWidth * 4) + (s * 3)

            LazyVGrid(
                columns: [GridItem(.adaptive(minimum: minItemWidth), spacing: s)],
                spacing: s
            ) {
                ForEach(vm.displays) { d in
                    DisplayItemView(display: d)
                }
            }
            .frame(maxWidth: maxGridWidth, alignment: .leading)
        }
    }
}

private struct DisplayItemView: View {
    let display: DisplayInfo

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(spacing: 8) {
                Label {
                    Text(display.name)
                        .font(.headline)
                        .lineLimit(1)
                } icon: {
                    Image(systemName: display.isBuiltin ? "laptopcomputer" : "display")
                }

                Spacer(minLength: 8)

                if display.isMain {
                    Text(String(localized: "display.main"))
                        .font(.caption).bold()
                        .padding(.horizontal, 8)
                        .padding(.vertical, 3)
                        .background(Capsule().fill(.secondary.opacity(0.18)))
                }
            }

            Grid(horizontalSpacing: Theme.spacing, verticalSpacing: Theme.spacing) {
                GridRow {
                    StatTile(
                        title: String(localized: "display.resolution"),
                        value: fmtRes(display.resolutionPixels)
                    )
                    StatTile(
                        title: "HiDPI",
                        value: hidpiText(scale: display.scale, isHiDPI: display.isHiDPI)
                    )
                }
                GridRow {
                    StatTile(
                        title: String(localized: "display.refresh"),
                        value: refreshText(display.refreshHz)
                    )
                    StatTile(
                        title: String(localized: "display.colorSpace"),
                        value: friendlyColorSpace(display.colorSpaceName)
                    )
                }
            }
        }
        .padding(10)
        .background(.quaternary.opacity(0.15), in: RoundedRectangle(cornerRadius: 12))
    }
}
