//
//  BTDiscovery.swift
//  autopilot
//
//  Created by Lars Jessen on 24/07/15. Based on Owen L Brown's example https://www.raywenderlich.com/85900/arduino-tutorial-integrating-bluetooth-le-ios-swift
//  Copyright (c) 2015 Lars Jessen. All rights reserved.
//

import Foundation
import CoreBluetooth

let btDiscoverySharedInstance = BTDiscovery();

class BTDiscovery: NSObject, CBCentralManagerDelegate {
  
  private var centralManager: CBCentralManager?
  private var peripheralBLE: CBPeripheral?
  
  override init() {
	super.init()
	
	let centralQueue = dispatch_queue_create("com.larsjessen", DISPATCH_QUEUE_SERIAL)
	centralManager = CBCentralManager(delegate: self, queue: centralQueue)
    print("BT Discovery started")
  }
  
  func startScanning() {
    print("Start scanning")
    if let central = centralManager {
      print("Scanning...")
      //central.scanForPeripheralsWithServices([BLEServiceUUID], options: nil)
      var peripherals: [CBPeripheral] = central.retrievePeripheralsWithIdentifiers([BlueduinoUUID!])
      print(peripherals.count)
        if(peripherals.count > 0){
            print(peripherals[0].name)
            self.peripheralBLE = peripherals[0]
            self.bleService = nil
            central.connectPeripheral(peripherals[0], options: nil)
        }
    }
  }
  
  var bleService: BTService? {
    didSet {
      if let service = self.bleService {
        service.startDiscoveringServices()
      }
    }
  }
  
  // MARK: - CBCentralManagerDelegate
  
  func centralManager(central: CBCentralManager, didDiscoverPeripheral peripheral: CBPeripheral, advertisementData: [String : AnyObject], RSSI: NSNumber) {
    
    print("centralManager start")
    
    // Be sure to retain the peripheral or it will fail during connection.
    
    // Validate peripheral information
    if ((peripheral.name == nil) || (peripheral.name == "")) {
      return
    }
    
    // If not already connected to a peripheral, then connect to this one
    if ((self.peripheralBLE == nil) || (self.peripheralBLE?.state == CBPeripheralState.Disconnected)) {
      // Retain the peripheral before trying to connect
      self.peripheralBLE = peripheral
      
      // Reset service
      self.bleService = nil
      
      // Connect to peripheral
      central.connectPeripheral(peripheral, options: nil)
    }
  }
  
  func centralManager(central: CBCentralManager, didConnectPeripheral peripheral: CBPeripheral) {
    
    print("centralManager start 2")
    // Create new service class
    if (peripheral == self.peripheralBLE) {
      self.bleService = BTService(initWithPeripheral: peripheral)
    }
    
    // Stop scanning for new devices
    central.stopScan()
  }
  
  func centralManager(central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: NSError?) {
    
    print("centralManager start 3")
    // See if it was our peripheral that disconnected
    if (peripheral == self.peripheralBLE) {
      self.bleService = nil;
      self.peripheralBLE = nil;
    }
    
    // Start scanning for new devices
    self.startScanning()
  }
  
  // MARK: - Private
  
  func clearDevices() {
    self.bleService = nil
    self.peripheralBLE = nil
  }
  
  func centralManagerDidUpdateState(central: CBCentralManager) {
    print("centralManager did update state")
    switch (central.state) {
    case CBCentralManagerState.PoweredOff:
      self.clearDevices()
      
    case CBCentralManagerState.Unauthorized:
      // Indicate to user that the iOS device does not support BLE.
      break
      
    case CBCentralManagerState.Unknown:
      // Wait for another event
      break
      
    case CBCentralManagerState.PoweredOn:
      print("powering on")
      self.startScanning()
      
    case CBCentralManagerState.Resetting:
      self.clearDevices()
      
    case CBCentralManagerState.Unsupported:
      break
    }
  }

}
