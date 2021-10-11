# How to use A FPGA on a SBus card...

## What do you need ?

* a SPARCstation or compatible with a free SBus slot, high enough to accomodate the taller-than-the standard board. Only SPARCstation 20s have been tested so far. I'd recommend against a SPARCstation 1-class machine (1, 1+, SLC, ...) as they have many quirks in their early SBus implementation. OpenBoot 2.x or newer is also a requirement (i.e. a recent 2.x or newer PROM).

* [NetBSD](https://www.netbsd.org/) 9.0 running on the SPARCstation, presumably newer version would work as well but have not yet been tested. No other OS (SunOS 4.1, Solaris 2.x, ...) have drivers (it is theoretically possible to write some, but it isn't planned).

* The ability to [rebuild the NetBSD kernel from source](https://www.netbsd.org/docs/guide/en/chap-kernel.html), as extra drivers are needed. It is well documented by the NetBSD team. This can be done in a QEmu virtual machine running NetBSD/sparc as an alternative to doing it on the real hardware.

* An adequate FPGA board, namely a [ZTex USB-to-FPGA 2.13](https://www.ztex.de/usb-fpga-2/usb-fpga-2.13.e.html). It provides the actual FPGA, a Xilinx Artix-7, and 256 MiB of on-board DDR3 SDRAM. Any of the 2.13 should work, but only the 2.13a (smallest and slowest FPGA, cheapest board) has been tested and it enough to fit quite a lot of stuff already. Other non-2.13 boards from ZTex will not work due to pin assignement (e.g. restriction on which pin can take the SBus clock as input), voltage (some boards require strictly more than 5V as input), ...

* An adequate power supply to power the FPGA board out of the SPARCstation so it can be programmed, and either an install of the FOSS  ZTex software to program the board via USB (recommended!) or an adequate JTAG programmer to program the board from Vivado

* The [Xilinx Vivado toolchain](https://www.xilinx.com/support/download/index.html/content/xilinx/en/downloadNav/vivado-design-tools/2020-2.html) to work with the FPGA. I use 2020.1, newer should work as well (and maybe some older). The free (as in no money needed, not as in FOSS)version is enough for the Artix-7 FPGA.

* A SBusFPGA SBus board. There's no supplier for those. Mine were manufactured by SeeedStudio. Other suppliers of PCB and PCB assembly are available - it's just the one I'm used to.

* A working [Litex](https://github.com/enjoy-digital/litex/) installation. It supplies the basis and many functionalities of the gateware in the FPGA.

* The ability to 3D-print the extension (and associated backplate), so that the board can be installed cleanly in a SBus system

* ???

## How to rebuild

* TBD

## Known limitations

* Currently, the board delays its powering-up by 20s after a cold start. That means that the host SPARCstation will POST without the board and not see it. The machine must be reset at the prompt, or the slot must be explictely probed, for the board to become visible. This is because so far, having the board start-up right away will prevent the SPARCstation from POSTing for unknown reasons.

* The combined height of the SBusFPGA and the FPGA daughterboard exceed the SBus limitation, and so may not fit in some systems.

* ???

TBD


