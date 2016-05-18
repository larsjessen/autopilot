//
//  BTService.swift
//  autopilot
//
//  Created by Lars Jessen on 24/07/15. Based on Owen L Brown's example https://www.raywenderlich.com/85900/arduino-tutorial-integrating-bluetooth-le-ios-swift
//  Copyright (c) 2015 Lars Jessen. All rights reserved.
//

import Foundation
import CoreBluetooth

/* Services & Characteristics UUIDs */
let BlueduinoUUID = NSUUID(UUIDString: "7AF496E9-0415-E383-4EDB-9E948F2C8966")
let BLEServiceUUID = CBUUID(string: "FFF0") // "7AF496E9-0415-E383-4EDB-9E948F2C8966"
let TxCharUUID = CBUUID(string: "FFF2")
let BLEServiceChangedStatusNotification = "kBLEServiceChangedStatusNotification"

class BTService: NSObject, CBPeripheralDelegate {
  var peripheral: CBPeripheral?
  var positionCharacteristic: CBCharacteristic?
  
  init(initWithPeripheral peripheral: CBPeripheral) {
    super.init()
    
    self.peripheral = peripheral
    self.peripheral?.delegate = self
  }
  
  deinit {
    self.reset()
  }
  
  func startDiscoveringServices() {
    print("starts discovering services")
    self.peripheral?.discoverServices([BLEServiceUUID])
  }
  
  func reset() {
    if peripheral != nil {
      peripheral = nil
    }
    
    // Deallocating therefore send notification
    self.sendBTServiceNotificationWithIsBluetoothConnected(false)
  }
  
  // Mark: - CBPeripheralDelegate
  
  func peripheral(peripheral: CBPeripheral, didDiscoverServices error: NSError?) {
    print("peripheral services")
    let uuidsForBTService: [CBUUID] = [TxCharUUID]
    
    if (peripheral != self.peripheral) {
      // Wrong Peripheral
      print("wrong peripheral")
      return
    }
    
    if (error != nil) {
      print(error)
      return
    }
    
    if ((peripheral.services == nil) || (peripheral.services!.count == 0)) {
      print("no services")
      // No Services
      return
    }
    
    for service in peripheral.services! {
      if service.UUID == BLEServiceUUID {
        print("starts characteristics discovery...")
        peripheral.discoverCharacteristics(uuidsForBTService, forService: service)
      }
    }
  }
  
  func peripheral(peripheral: CBPeripheral, didDiscoverCharacteristicsForService service: CBService, error: NSError?) {
    if (peripheral != self.peripheral) {
      // Wrong Peripheral
      return
    }
    
    if (error != nil) {
      return
    }
    
    if let characteristics = service.characteristics {
      for characteristic in characteristics {
        if characteristic.UUID == TxCharUUID {
          self.positionCharacteristic = (characteristic)
          peripheral.setNotifyValue(true, forCharacteristic: characteristic)
          
          // Send notification that Bluetooth is connected and all required characteristics are discovered
          self.sendBTServiceNotificationWithIsBluetoothConnected(true)
        }
      }
    }
  }
  
  // Mark: - Private
  
  func sendMessage(message: String) {
    // See if characteristic has been discovered before writing to it
    if let positionCharacteristic = self.positionCharacteristic {
      // Need a mutable var to pass to writeValue function
      let data = message.dataUsingEncoding(NSUTF8StringEncoding)
      self.peripheral?.writeValue(data!, forCharacteristic: positionCharacteristic, type: CBCharacteristicWriteType.WithResponse)
      
    }
  }
  
  func sendBTServiceNotificationWithIsBluetoothConnected(isBluetoothConnected: Bool) {
    let connectionDetails = ["isConnected": isBluetoothConnected]
    NSNotificationCenter.defaultCenter().postNotificationName(BLEServiceChangedStatusNotification, object: self, userInfo: connectionDetails)
  }
  
}