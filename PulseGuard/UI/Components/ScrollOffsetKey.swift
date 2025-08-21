//
//  ScrollOffsetKey.swift
//  PulseGuard
//
//  Created by Killian VINCENT on 22/08/2025.
//


import SwiftUI
import AppKit

// ---- Suivi d’offset via PreferenceKey
struct ScrollOffsetKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) { value = nextValue() }
}

// Marqueur pour scroller en haut
private struct ScrollTopAnchor: View { var body: some View { Color.clear.frame(height: 0).id("__TOP__") } }

// ---- Active l’élasticité (rubber-banding) sur le NSScrollView parent
struct EnableElasticScroll: NSViewRepresentable {
    func makeNSView(context: Context) -> NSView {
        let v = NSView()
        DispatchQueue.main.async {
            if let scroll = v.enclosingScrollView {
                scroll.verticalScrollElasticity = .allowed
                scroll.horizontalScrollElasticity = .automatic
            }
        }
        return v
    }
    func updateNSView(_ view: NSView, context: Context) { }
}

struct ScrollToTopButton: View {
    let action: () -> Void
    var body: some View {
        Button {
            action()
        } label: {
            Label("ui.scroll.toTop", systemImage: "arrow.up.to.line")
                .labelStyle(.titleAndIcon)
                .padding(.horizontal, 12).padding(.vertical, 8)
                .background(.ultraThinMaterial)
                .clipShape(Capsule())
                .shadow(radius: 8, y: 3)
        }
        .buttonStyle(.plain)
        .accessibilityLabel(Text("ui.scroll.toTop"))
        .accessibilityAddTraits(.isButton)
    }
}
