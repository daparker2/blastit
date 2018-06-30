# blastit
OBD2 UART-based display controller done in Verilog for an FPGA driven display circuit. 

RevA is [here](/doc/RevA.PDF). Addresses problems I had in the first proof of concept project [here](https://github.com/daparker2/Tinast_Public):

1. Windows IoT core is very slow to come out of reset and hard to service since it requires an internet connection to use the console.
2. The Bluetooth based OBD2 scantool requires a lot of setup.
3. The display is dim is daylight conditions and this is difficult to address with off the shelf HDMI displays.

Replaces the IoT based proof of concept with a controller state machine implemented in Verilog using roughly this as the idea architectural stack:

![block diagram](/doc/stack.png)

The new device should be lighter and roughly the same dimensions, while solving the problems above.
