//
//  AppEnvironment.swift
//  PulseGuard
//
//  Created by Killian VINCENT on 22/08/2025.
//

import SwiftUI

@MainActor
final class AppEnvironment: ObservableObject {
    let settings: SettingsStore
    let batteryVM: BatteryViewModel
    let cpuVM: CPUViewModel
    let memoryVM: MemoryViewModel
    let batteryHealthVM: BatteryHealthViewModel
    let networkVM: NetworkViewModel
    let systemVM: SystemViewModel
    let storageVM: StorageViewModel
    let graphicsVM: GraphicsViewModel
    let displaysVM: DisplaysViewModel

    init(settings: SettingsStore,
         batteryReader: BatteryReading,
         notifier: Notifying,
         cpuReader: CPUReading,
         memReader: MemoryReading,
         bhReader: BatteryHealthReading,
         netReader: NetworkReading,
         storageReader: StorageReading,
         systemReader: SystemReading = SystemReader(),
         graphicsReader: GPUReading = MetalGPUReader(),
         displaysReader: DisplayReading = SystemDisplayReader()
    ) {
        self.settings = settings
        self.batteryVM = BatteryViewModel(reader: batteryReader, notifier: notifier, settings: settings)
        self.cpuVM = CPUViewModel(reader: cpuReader)
        self.memoryVM = MemoryViewModel(reader: memReader)
        self.batteryHealthVM = BatteryHealthViewModel(reader: bhReader)
        self.networkVM = NetworkViewModel(reader: netReader)
        self.systemVM = SystemViewModel(reader: systemReader)
        self.storageVM = StorageViewModel(reader: storageReader)
        self.graphicsVM = GraphicsViewModel(reader: graphicsReader)
        self.displaysVM = DisplaysViewModel(reader: displaysReader)
    }

    static func makeLive() -> AppEnvironment {
        AppEnvironment(
            settings: SettingsStore(),
            batteryReader: IOKitBatteryReader(),
            notifier: UserNotifier.shared,
            cpuReader: MachCPUReader(),
            memReader: HostMemoryReader(),
            bhReader: IOKitBatteryHealthReader(),
            netReader: NetworkReader(),
            storageReader: StorageReader(),
            graphicsReader: MetalGPUReader(),
            displaysReader: SystemDisplayReader()
        )
    }
}
