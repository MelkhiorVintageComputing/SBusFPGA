# A FPGA on a SBus card...

## Goal

The goal of this repository is to be able to interface a modern (2020 era) [FPGA](https://en.wikipedia.org/wiki/Field-programmable_gate_array) with a [SBus](https://en.wikipedia.org/wiki/SBus) host. SBus was widely used in SPARCstation and compatibles system in the first half of the 90s. It was progressively displaced by PCI from the mid-90s onward, and is thoroughly obsolete.

So unless you're a retrocomputing enthusiast with such a machine, this is useless. To be honest, even if you are such an enthusiast, it's probably not that useful...

I'm a software guy and know next to nothing about hardware design, so this is very much a work-in-progress and is likely full of rookie mistakes.

To save on PCB cost, the board is smaller than a 'true' SBus board; the hardware directory includes an OpenSCAD 3D-printable extension to make the board compliant to the form factor (visible in the pictures in 'Pictures') (need to be updated for V1.3).

## Current status

2023-10-07: V1.3 in testing.

2022-11-18: V1.2 seems stable, with various subsets of the peripherals described below. It only lacks a proper video output, such as the one available in the [NuBusFPGA](https://github.com/rdolbeau/NuBusFPGA). Unfortunately the FPGA board used in V1.0/V1.2 (ZTex 2.13) doesn't have enough available I/O to add it in addition to the already existing I/Os.

## The hardware

Directory 'sbus-to-ztex'

The V1.2 custom board is a SBus-compliant (I hope...) board, designed to receive a [ZTex USB-FPGA Module 2.13](https://www.ztex.de/usb-fpga-2/usb-fpga-2.13.e.html) as a daughterboard. The ZTex module contains the actual FPGA (Artix-7), some RAM, programming hardware, etc. The SBus board contains level-shifters ICs to interface between the SBus signals and the FPGA, a serial header, a Led, a JTAG header, a micro-sd card slot, a USB micro-B connector, and a (Pmod)[https://digilent.com/shop/boards-and-components/system-board-expansion-modules/pmods/] connector. It supports every SBus feature except the optional parity (i.e. it can do both slave and master modes) and interrupt level 1 to 6 are connected.

The V1.3 custom board is similar to V1.2 but reorganized & redesigned to have all components on the top side and cleaner routing. It also loose the led, setial header & micro-sd to gain a HDMI connector. The USB micro-B is still present, and the PMod was rewired to carry 8 length-matched differential pairs.

The PCB was designed with Kicad 5.0 for V1.2, 5.1 for V1.3.

## The gateware (Migen)

Directory 'sbus-to-ztex-gateware-migen'

### Intro

The gateware is written in the Migen language, choosen because that's what [Litex](https://github.com/enjoy-digital/litex/) uses.
It implements a simple CPU-less Litex SoC built around a Wishbone bus, with a custom bridge between the SBus and the Wishbone.

A ROM, a SDRAM controller ([litedram](https://github.com/enjoy-digital/litedram) to the on-board DDR3), a TRNG (using the [NeoRV32](https://github.com/stnolting/neorv32) TRNG), an USB OHCI (host controller, using the Litex wrapper around the [SpinalHDL](https://github.com/SpinalHDL/SpinalHDL) implementation), a Curve25519 Crypto Engine (taken from the [Betrusted.IO](https://betrusted.io/) project and expanded to add AES and GCM support) and a Litex micro-sd controller can be connected to that bus. As a test feature for the Pmod connector, a bw2/cg3/cg6-compatible framebuffer can be implemented using a custom RGA222 VGA Pmod (with serious color quality restrictions). The 'Goblin' framebuffer (a multi-depth gramebuffer) can also be used with the VGA Pmod, using 8-bits depth in the console or accelerated 24-bits in X11. Alternatively on the Pmod en I2C bus (the Betrusted.IO wrapper around an OpenCore controller) can be implemented for e.g. temperature control.

### Details

Master access to the SBus by the host are routed to the Wishbone to access the various CSRs / control registers of the devices.

The ROM exposes the devices' existence and specifications to the host, initializes the embedded SDRAM controller (but assuming known values, the NetBSD driver can also optionally initialize the SDRAM via proper calibration), enables FB support on the bw2/cg3/cg6 (last one with accelerated scrolling), and has support for RO access to the sdcard such enabling booting.

The USB OHCI DMA (USB 1.1) is bridged from the Wishbone to the SBus by having the physical addresses of the Wishbone (that match the virtual addresses from NetBSD DVMA allocations) to the bridge (see also 'Sun4m vs. Sun4c' below). Reads are buffered by block of 16 bytes; currently writes are unbuffered (and somewhat slow, as they need a full SBus master cycle for every transaction of 32 bits or less). The standard NetBSD OHCI driver is used, with just a small custom SBus-OHCI driver mirroring the PCI-OHCI one. It uses the interrupt level 4 by default. It connects to the micro-B USB connector, an a cable such as [this one](https://www.startech.com/en-us/cables/uusbotgra) allows to expose a conventional USB type A connector for either an external (preferably self-powered) USB Hub or a single low-power device.

The SDRAM has its own custom DMA controller, using native Litedram interface to the memory, and some FIFO to/from the SBus. A custom NetBSD driver exposes it as a drive on which you can swap. It's also usable as a 'fast', volatile disk (for e.g. /tmp or similar temporary filesystem). It can use a interrupt line, but software support isn't there yet (only synchronous polling).

The micro-sd card controller is using a similar driver to the SDRAM, so is also currently limited to sychronous polling and lack of support for interrupts (or removability). It also has some level of support in the PROM, enabling it as a boot device (of course using a NetBSD kernel with appropriate support). For its DMA engine, the micro-sd controller uses the same Wishbone/SBus bridge as designed for the USB OHCI.

The TRNG has a NetBSD driver to add entropy to the entropy pool.

The Curve25519 Engine currently exposes an IOCTL to do the computation, which has yet to be integrated usefully in e.g. OpenSSL. It could use a interrupt line, but it's not yet implemented in software. The load/store unit used the same Wishbone/SBus bridge as designed for the USB OHCI.

The I2C bus currently uses a custom Pmod to plug an AT30TS74 temperature sensor (LM75-compatible, usable with 'envstat' in NetBSD), but should support most/all I2C devices supported by NetBSD.

The bw2/cg3/cg6 emulation requires the custom Pmod on V1.2, and colors are vert limited at 2 bits per channel, so it's for testing mostly. V1.3 has a HDMI connector using DVI signaling and so support the full color range. bw2/cg3 can work as a PROM console, a NetBSD console, and with X11, all as an non-accelerated framebuffer. Resolution can be arbitrary but is fixed in the bitstream at synthesis time, the current design can go up to 1920x1080@60Hz. cg6 emulation is similar but uses a micro-coded VexRiscv core to emulate some of the cg6 hardware acceleration, enough to accelerate the PROM console, the NetBSD console and X11 EXA acceleration in NetBSD 9.0. The cg3/cg6 emulation was also tested with the original PROM code for cg3 (501-1415) and TGX+ (501-2253), but this requires hardware-based initialization (instead of PROM-based) and prevent exposing other devices in the PROM code.

The 'Goblin' framebuffer works similarly to the cg6 emulation (from which it has grown for the NuBusFPGA), but is using 24-bits in X11 (switching in a way similar to the cg14) and has some Xrender acceleration. Using the same 2-bits-per-channel VGA Pmod, it also suffers from color limitations ob V1.2. It also uses tje HDMI connector on V1.3.

### Special Notes

Currently the design uses a Wishbone Crossbar Interconnect from Litex instead of a Shared Interconnect, as for some reason using a Shared Interconnect causes issues between devices (disabling the USB OHCI seem also to solve the issue, it generates a lot of cycles on the buses). I might be misusing Wishbone. With the Crossbar, all devices are usable simultaneously if they fit in the FPGA.

As not everything lives in the same clock domain, the design also use a Wishbone CDC, a wrapper around the one from [Verilog Wishbone Components](https://github.com/alexforencich/verilog-wishbone).

## The software

Directory 'NetBSD'

Some basic drivers for NetBSD 9.0/sparc to enable the devices as described above. bw2/cg3/cg6 uses unmodifed NetBSD drivers. USB OHCI needs only a SBus-OHCI layer, the NetBSD OHCI driver and USB stack are used unmodified.

## Sun4m vs. Sun4c

The current DMA scheme for Wishbone devices (USB OHCI, micro-sd, ...) works fine on sun4m machine with an IOMMU (SPARCstation 4, 5, 10, 20 ...). NetBSD will always allocate the DVMA buffers in the range from IOMMU_DVMA_BASE to the end of the memory space (IOMMU_DVMA_BASE is 0xFC000000 by default, and that must include 0xFF000000 to the end which are the only virtual addresses accessible by some legacy devices used in some SPARCstation). However, sun4c machine (SPARCstation 1, 2, IPC, IPX, ...) do not have an IOMMU, and have no virtual address restriction for non-legacy device. And the NetBSD kernel takes advantage of this, I have observed DVMA buffers mapped to prefix 0xF4 and 0xF3. Extending the mapping for the DVMA bridge in Wishbone to the full 0xF prefix enable booting from sd-card on an IPX, but I'm not sure this is reliable.
