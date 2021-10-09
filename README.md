# A FPGA on a SBus card...

## Goal

The goal of this repository is to be able to interface a modern (2020 era) [FPGA](https://en.wikipedia.org/wiki/Field-programmable_gate_array) with a [SBus](https://en.wikipedia.org/wiki/SBus) host. SBus was widely used in SPARCstation and compatibles system in the first half of the 90s. It was progressively displaced by PCI from the mid-90s onward, and is thoroughly obsolete.

So unless you're a retrocomputing enthusiast with such a machine, this is useless. To be honest, even if you are such an enthusiast, it's probably not that useful...

I'm a software guy and know next to nothing about hardware design, so this is very much a work-in-progress and is likely full of rookie mistakes.

To save on PCB cost, the board is smaller than a 'true' SBus board; the hardware directory includes an OpenSCAD 3D-printable extension to make the board compliant to the form factor (visible in the pictures in 'Pictures').

## Current status

2021-10-09: The original V1.0 design has been replaced by the newer V1.2 design, which supports fewer leds, more interrupt lines, a proper USB connector, and a Pmod connector. The old VHDL gateware is not supported on the V1.2, only the Migen/Litex one.

## The hardware

Directory 'sbus-to-ztex'

The custom board is a SBus-compliant (I hope...) board, designed to receive a [ZTex USB-FPGA Module 2.13](https://www.ztex.de/usb-fpga-2/usb-fpga-2.13.e.html) as a daughterboard. The ZTex module contains the actual FPGA (Artix-7), some RAM, programming hardware, etc. The SBus board contains level-shifters ICs to interface between the SBus signals and the FPGA, a serial header, a Led, a JTAG header, a micro-sd card slot, a USB micro-B connector, and a (Pmod)[https://digilent.com/shop/boards-and-components/system-board-expansion-modules/pmods/] connector. It supports every SBus feature except the optional parity (i.e. it can do both slave and master modes) and interrupt level 7 - 1 to 6 are connected.

The PCB was designed with Kicad 5.0

## The gateware (Migen)

Directory 'sbus-to-ztex-gateware-migen'

### Intro

The gateware is written in the Migen language, choosen because that's what [Litex](https://github.com/enjoy-digital/litex/) uses.
It implements a simple CPU-less Litex SoC built around a Wishbone bus, with a custom bridge between the SBus and the Wishbone.

A ROM, a SDRAM controller ([litedram](https://github.com/enjoy-digital/litedram) to the on-board DDR3), a TRNG (using the [NeoRV32](https://github.com/stnolting/neorv32) TRNG), an USB OHCI (host controller, using the Litex wrapper around the [SpinalHDL](https://github.com/SpinalHDL/SpinalHDL) implementation) and a Curve25519 Crypto Engine (taken from the [Betrusted.IO](https://betrusted.io/) project) are connected to that bus. As a test feature for the Pmod connector, a cg3-compatible framebuffer can be implemented using a custom RGA222 VGA Pmod.

### Details

Master access to the SBus by the host are routed to the Wishbone to access the various CSRs / control registers of the devices.

The ROM doesn't do much beyond exposing the devices' existence and specifications to the host.

The SDRAM has its own custom DMA controller, using native Litedram DMA to the memory, and some FIFO to/from the SBus. A custom NetBSD driver exposes it as a drive on which you can swap. It's also usable as a 'fast', volatile disk (for e.g. /tmp or similar temporary filesystem). It could use a interrupt line, but it's not yet implemented in software.

The TRNG has a NetBSD driver to add entropy to the entropy pool.

The USB OHCI DMA (USB 1.1) is bridged from the Wishbone to the SBus by having the physical addresses of the Wishbone (that match the virtual addresses from NetBSD DVMA allocations) to the bridge. Reads are buffered by block of 16 bytes; currently writes are unbuffered (and somewhat slow, as they need a full SBus master cycle for every transaction of 32 bits or less). The standard NetBSD OHCI driver is used, with just a small custom SBus-OHCI driver mirroring the PCI-OHCI one. It uses the interrupt level 4 by default. It connects to the micro-B USB connector, an a cable such as [this one](https://www.startech.com/en-us/cables/uusbotgra) allows to expose a conventional USB type A connector for either an external (preferably self-powered) USB Hub or a single low-power device.

The Curve25519 Engine currently exposes an IOCTL to do the computation, which has yet to be integrated usefully in e.g. OpenSSL. It could use a interrupt line, but it's not yet implemented in software.

The cg3 emulation requires the custom Pmod, and colors are vert limited at 2 bits per channel, so it's for testing mostly. It can work as a PROM console, a NetBSD console, and with X11, all as an non-accelerated framebuffer. Resolution can be arbitrary but the current design cannot handle timings requirements for 1920x1080 or higher ; 1280x1024 @ 60 Hz is known to work.

### Special Notes

Currently the design uses a Wishbone Crossbar Interconnect from Litex instead of a Shared Interconnect, as for some reason using a Shared Interconnect causes issues between devices (disabling the USB OHCI seem also to solve the issue, it generates a lot of cycles on the buses). I might be misusing Wishbone. With the Crossbar, all devices are usable simultaneously.

As not everything lives in the same clock domain, the design also use a Wishbone CDC, a wrapper around the one from [Verilog Wishbone Components](https://github.com/alexforencich/verilog-wishbone).

## The software

Directory 'NetBSD'

Some basic drivers for NetBSD 9.0/sparc to enable the devices as described above.

