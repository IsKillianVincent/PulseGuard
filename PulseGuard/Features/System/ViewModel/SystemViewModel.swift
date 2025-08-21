//
//  SystemViewModel.swift
//  PulseGuard
//
//  Created by Killian VINCENT on 22/08/2025.
//

import Foundation
import SwiftUI

@MainActor
final class SystemViewModel: ObservableObject {
    @Published private(set) var snapshot: ThermalSnapshot

    private let reader: SystemReading
    private var timer: Timer?

    init(reader: SystemReading = SystemReader()) {
        self.reader = reader
        self.snapshot = reader.sample()
    }

    func start() {
        stopMain()
        tick()

        let t = Timer.scheduledTimer(timeInterval: 1.0,
                                     target: self,
                                     selector: #selector(handleTimer),
                                     userInfo: nil,
                                     repeats: true)
        RunLoop.main.add(t, forMode: .common)
        self.timer = t

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(thermalChanged(_:)),
                                               name: ProcessInfo.thermalStateDidChangeNotification,
                                               object: nil)
    }

    nonisolated func stop() {
        Task { @MainActor in
            self.stopMain()
        }
    }

    deinit {
        stop()
    }


    @objc private func handleTimer() { tick() }

    @objc private func thermalChanged(_ note: Notification) { tick() }

    private func tick() {
        snapshot = reader.sample()
    }
    
    private func stopMain() {
        timer?.invalidate()
        timer = nil
        NotificationCenter.default.removeObserver(self,
                                                  name: ProcessInfo.thermalStateDidChangeNotification,
                                                  object: nil)
    }
}
