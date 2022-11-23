//
//  ViewModel.swift
//  esp32BLE
//
//  Created by Oleksii Mykhalchuk on 11/23/22.
//

import Foundation
import CoreBluetooth

class ViewModel: NSObject, ObservableObject  {

    @Published var temperature: UInt8 = 0
    @Published var connected: Bool = false
    @Published var output = "Connect"

    private let serviceUUID = CBUUID(string: "da30e919-38b1-469e-9081-da9f59c04c34")
    private let inputCharUUID = CBUUID(string: "f8abccc0-488f-4747-8dd2-808a4c70bfc3")
    private let outputCharUUID = CBUUID(string: "ad0d60a7-6770-4383-a879-5cd77d75ec26")

    private var inputChar: CBCharacteristic?
    private var outputCHar: CBCharacteristic?

    private var centralManager: CBCentralManager?
    private var connectedPeripheral: CBPeripheral?

    func connect() {
        let queue = DispatchQueue(label: "test")
        centralManager = CBCentralManager(delegate: self, queue: queue)
    }
    func disconnect() {
        guard let manager = centralManager,
              let peripheral = connectedPeripheral else { return }
        manager.cancelPeripheralConnection(peripheral)
    }
}
extension ViewModel: CBCentralManagerDelegate {
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        if central.state == .poweredOn {
            central.scanForPeripherals(withServices: [serviceUUID])
        }
    }
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        central.stopScan()
        connectedPeripheral = peripheral
        central.connect(peripheral)
    }
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        peripheral.delegate = self
        peripheral.discoverServices(nil)
    }
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        centralManager = nil
        DispatchQueue.main.async {
            self.connected = false
            self.output = "Connect"
        }
    }
}
extension ViewModel: CBPeripheralDelegate {
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        guard let services = peripheral.services else { return }

        for service in services {
            peripheral.discoverCharacteristics(nil, for: service)
        }
    }
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        guard let characteristics = service.characteristics else { return }

        for characteristic in characteristics {
            switch characteristic.uuid {
            case inputCharUUID:
                self.inputChar = characteristic
            case outputCharUUID:
                self.outputCHar = characteristic
                peripheral.setNotifyValue(true, for: characteristic)
            default:
                break
            }
        }

        DispatchQueue.main.async {
            self.connected = true
            self.output = "Disconnect"
        }
    }
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        if characteristic.uuid == outputCharUUID, let data = characteristic.value {
            let bytes: [UInt8] = data.map { $0 }
            if let answer = bytes.first {
                DispatchQueue.main.async {
                    self.temperature = answer
                }
            }
        }
    }
}
