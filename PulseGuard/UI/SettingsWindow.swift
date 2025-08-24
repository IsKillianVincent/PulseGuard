//
//  SettingsWindow.swift
//  PulseGuard
//
//  Created by Killian VINCENT on 22/08/2025.
//

import SwiftUI
import AppKit

final class SettingsWindow {
    static let shared = SettingsWindow()
    private var controller: NSWindowController?

    @MainActor func show(settings: SettingsStore) {
        let vm = PreferencesViewModel(store: settings)
        if controller == nil {
            let host = NSHostingController(rootView: PreferencesView(vm: vm))
            let win = NSWindow(contentViewController: host)
            win.title = String(localized: "common.preferences")
            win.setContentSize(NSSize(width: 560, height: 420))
            win.styleMask = [.titled, .closable, .miniaturizable]
            win.isMovableByWindowBackground = true
            win.isReleasedWhenClosed = false
            controller = NSWindowController(window: win)
        } else if let host = controller?.window?.contentViewController as? NSHostingController<PreferencesView> {
            host.rootView = PreferencesView(vm: vm)
        }
        controller?.showWindow(nil)
        NSApp.activate(ignoringOtherApps: true)
    }
}
