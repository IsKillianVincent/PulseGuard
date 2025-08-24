//
//  BluetoothAccessoryReader.swift
//  PulseGuard
//
//  Created by Killian VINCENT on 24/08/2025.
//

import Foundation
import CoreBluetooth

public final class BluetoothAccessoryReader: NSObject, AccessoryReading {
    private let central: CBCentralManager

    private var batteries: [UUID: Int] = [:]
    private var rssiMap:  [UUID: Int] = [:]
    private var names:    [UUID: String] = [:]
    private var vendors:  [UUID: String] = [:]
    private var lastSeen: [UUID: Date] = [:]
    private var isConnectedMap: [UUID: Bool] = [:]
    private var peripherals: [UUID: CBPeripheral] = [:]

    private let batteryService  = CBUUID(string: "180F")
    private let batteryLevelChar = CBUUID(string: "2A19")

    public override init() {
        central = CBCentralManager(
            delegate: nil,
            queue: .main,
            options: [CBCentralManagerOptionShowPowerAlertKey: true]
        )
        super.init()
        central.delegate = self
    }

    public func current() -> [AccessoryInfo] {
        var out: [AccessoryInfo] = []

        for (uuid, name) in names {
            out.append(.init(
                id: uuid.uuidString,
                name: name,
                connection: .bluetooth,
                category: Self.guessCategory(name),
                batteryPercent: batteries[uuid],
                isCharging: nil,
                vendor: vendors[uuid],
                isConnected: isConnectedMap[uuid],
                rssi: rssiMap[uuid],
                lastSeen: lastSeen[uuid]
            ))
        }

        return out.sorted {
            ( ($0.isConnected ?? false) ? 0 : 1, $0.name.lowercased() ) <
            ( ($1.isConnected ?? false) ? 0 : 1, $1.name.lowercased() )
        }
    }

    private static func guessCategory(_ name: String) -> AccessoryInfo.Category {
        let n = name.lowercased()
        if n.contains("keyboard") || n.contains("clavier") { return .keyboard }
        if n.contains("mouse") || n.contains("souris") { return .mouse }
        if n.contains("trackpad") { return .trackpad }
        if n.contains("head") || n.contains("airpods") || n.contains("buds") { return .headphones }
        return .other
    }
}

extension BluetoothAccessoryReader: CBCentralManagerDelegate, CBPeripheralDelegate {

    public func centralManagerDidUpdateState(_ central: CBCentralManager) {
        guard central.state == .poweredOn else { return }

        central.scanForPeripherals(withServices: nil,
                                   options: [CBCentralManagerScanOptionAllowDuplicatesKey: true])

        let connected = central.retrieveConnectedPeripherals(withServices: [batteryService])
        for p in connected {
            names[p.identifier] = p.name ?? "Bluetooth Device"
            isConnectedMap[p.identifier] = true
            peripherals[p.identifier] = p
            lastSeen[p.identifier] = Date()
            p.delegate = self
            p.discoverServices([batteryService])
        }
    }

    public func centralManager(_ central: CBCentralManager,
                               didDiscover peripheral: CBPeripheral,
                               advertisementData: [String: Any],
                               rssi RSSI: NSNumber) {

        let name = (advertisementData[CBAdvertisementDataLocalNameKey] as? String)
            ?? peripheral.name
            ?? "Bluetooth Device"

        names[peripheral.identifier] = name
        rssiMap[peripheral.identifier] = RSSI.intValue
        lastSeen[peripheral.identifier] = Date()
        peripherals[peripheral.identifier] = peripheral

        if let svcs = advertisementData[CBAdvertisementDataServiceUUIDsKey] as? [CBUUID],
           svcs.contains(batteryService) {
            if peripheral.state != .connected {
                peripheral.delegate = self
                central.connect(peripheral, options: nil)
            } else {
                peripheral.discoverServices([batteryService])
            }
        }
    }

    public func centralManager(_ central: CBCentralManager,
                               didConnect peripheral: CBPeripheral) {
        isConnectedMap[peripheral.identifier] = true
        lastSeen[peripheral.identifier] = Date()
        peripheral.delegate = self
        peripheral.discoverServices([batteryService])
    }

    public func centralManager(_ central: CBCentralManager,
                               didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        isConnectedMap[peripheral.identifier] = false
    }

    public func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        guard error == nil else { return }
        peripheral.services?.forEach { service in
            if service.uuid == batteryService {
                peripheral.discoverCharacteristics([batteryLevelChar], for: service)
            }
        }
    }

    public func peripheral(_ peripheral: CBPeripheral,
                           didDiscoverCharacteristicsFor service: CBService,
                           error: Error?) {
        guard error == nil else { return }
        service.characteristics?.forEach { ch in
            if ch.uuid == batteryLevelChar {
                peripheral.readValue(for: ch)
                if ch.properties.contains(.notify) {
                    peripheral.setNotifyValue(true, for: ch)
                }
            }
        }
    }

    public func peripheral(_ peripheral: CBPeripheral,
                           didUpdateValueFor characteristic: CBCharacteristic,
                           error: Error?) {
        guard error == nil,
              characteristic.uuid == batteryLevelChar,
              let data = characteristic.value,
              let level = data.first else { return }

        batteries[peripheral.identifier] = Int(level)
        lastSeen[peripheral.identifier] = Date()
    }
}
