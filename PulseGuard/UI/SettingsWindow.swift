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

    func show(settings: SettingsStore) {
        if controller == nil {
            let host = NSHostingController(rootView: PreferencesView(settings: settings))
            let win = NSWindow(contentViewController: host)
            win.title = "Réglages"
            win.setContentSize(NSSize(width: 480, height: 420))
            win.styleMask = [.titled, .closable, .miniaturizable]
            win.isReleasedWhenClosed = false
            controller = NSWindowController(window: win)
        } else if let host = controller?.window?.contentViewController as? NSHostingController<PreferencesView> {
            host.rootView = PreferencesView(settings: settings)
        }
        controller?.showWindow(nil)
        NSApp.activate(ignoringOtherApps: true)
    }
}
