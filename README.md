# iOS remote for Autohelm 800

Electronics and code for creating an iOS autopilot app to remote control Autohelm 800.

## Electronics

My initial idea was to use the remote control port that is located underneath the Autohelm 800, but I had no luck decoding the protocol used. I tried both listening for Serial and I2C, but I suspect that it is some proprietary communication protocol by Raymarine, and of course there is no documentation on this.

So instead I went for the other obvious (and less elegant) solution - simulating button presses with relays.

Below is a picture of the final board. Luckily there is quite a lot of space beside the main pcb in the Autohelm, and it even has an unused screw hole for mounting.
![Alt text](media/final_pcb.png?raw=true "Title")

### Bill of materials
- 1 x [Blueduino Rev2](https://www.tindie.com/products/AprilBrother/blueduino-rev2-arduino-compatible-plus-ble/)
- 5 x Reed Relay W117DIP-89

### Diagrams

Coming soon

## Blueduino

The blueduino combines Arduino with a CC2540 BLE module.

Note that you have to choose "LilyPad USB" to download the sketch to the board.

More documentation can be found here
* https://www.tindie.com/products/AprilBrother/blueduino-rev2-arduino-compatible-plus-ble/
* http://wiki.aprbrother.com/wiki/BlueDuino_rev2

I used the Arduino IDE 1.6.5 for the project (not that it should matter which version you use).

## iOS app

I wanted to learn a bit of Swift so the example code for the Blueduino was not very helpful to me.

Instead I based the code on [this example](https://www.raywenderlich.com/85900/arduino-tutorial-integrating-bluetooth-le-ios-swift) from Ray Wenderlich.
