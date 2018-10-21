# blastit
OBD2 UART-based display controller done in Verilog and C based on a Cyclone3 core board and custom display.

Basically this addresses issues I had in my last OBD2 gauge panel thing like the display being too bright and reset times being too slow. Image of my final rev C board below as I test the display:

![The thing](/thing.jpg)

There is a UART and power input on the back which goes to a [Freematics OBD2](https://freematics.com/pages/products/freematics-obd-ii-uart-adapter-mk2/) ELM327 interface, and I have brought up the UART and display code already. FPGA is a [Waveshare Core3](https://www.waveshare.com/product/fpga-tools/altera/core/coreep3c16.htm). The code is mine and display is a pretty simple [2-layer PCB](https://github.com/daparker2/blastit/blob/master/doc/RevC.PDF) with a couple LED matrix bars and a central 20 digit readout. Now I am just writing the display task engine and OBD2 state machine and then it will just need a final mechanical enclosure which I am 3D printing; I am not totally happy with the one I have already printed.

Maybe one more update if I ever get it in my car, I have an STL file which I have 3D printed before but I will need to modify the model to make the fitment closer to the PCB and to work with an existing gauge fixture I have, cause removing double sided tape last time I reinstalled a gauge really tore up my dashboard. Haha.

