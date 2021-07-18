# A FPGA on a SBus card...

## Goal

The goal of this repository is to be able to interface a modern (2020 era) [FPGA](https://en.wikipedia.org/wiki/Field-programmable_gate_array) with a [SBus](https://en.wikipedia.org/wiki/SBus) host. SBus was widely used in SPARCstation and compatibles system in the first halt of the 90s. It was progressively displaced by PCI from the mid-90s onward, and is thoroughly obsolete.

So unless you're a retrocomputing enthusiast with such a machine, this is useless. To be honest, even if you are such an enthusiast, it's probably not that useful...

I'm a software guy and know next to nothing about hardware design, so this is very much a work-in-progress and is likely full of rookie mistakes.

To save on PCB cost, the board is smaller than a 'true' SBus board; the hardware directory includes an OpenSCAD 3D-printable extension to make the board compliant to the form factor (visible in the pictures in 'Pictures').

## Current status

2021-07-18: The old VHDL gateware has been replaced by a new Migen-based gateware, see below for details.

Short version: the board enables a 256 MiB SDRAM disk (for fast swapping) and a USH OHCI host controller (for USB peripherals).

## The hardware

Directory 'sbus-to-ztex'

The custom board is a SBus-compliant (I hope...) board, designed to receive a [ZTex USB-FPGA Module 2.13](https://www.ztex.de/usb-fpga-2/usb-fpga-2.13.e.html) as a daughterboard. The ZTex module contains the actual FPGA (Artix-7), some RAM, programming hardware, etc. The SBus board contains level-shifters ICs to interface between the SBus signals and the FPGA, a serial header, some Leds, a JTAG header, and a micro-sd card slot.

The PCB was designed with Kicad 5.0

## The gateware (Migen)

The gateware was rewritten from scrach in the Migen language, choosen because that's what [Litex](https://github.com/enjoy-digital/litex/) uses.
It implements a simple CPU-less Litex SoC built around a Wishbone bus, with a bridge between the SBus and the Wishbone.

A ROM, a SDRAM controller (litedram to the on-board DDR3) and an USB OHCI (host controller, using the Litex wrapper around the [SpinalHDL](https://github.com/SpinalHDL/SpinalHDL) implementation) are connected to that bus.
Master access to the SBus by the host are routed to the Wishbone to access the various CSRs / control registers of the devices.

The USB OHCI DMA is bridged from the Wishbone to the SBus by having the physical addresses of the Wishbone (that match the virtual addresses from NetBSD DVMA allocations) to the bridge. Reads are buffered by block of 16 bytes; currently writes are unbuffered (and somwhat slow, as they need a full SBus master cycle for every transaction of 32 bits or less). The standard NetBSD OHCI driver is used, with just a small custom SBus-OHCI driver mirroring the PCI-OHCI one.

The SDRAM has its own custom DMA controller, using native Litedram DMA to the memory, and some FIFO to/from the SBus. A custom NetBSD driver exposes it as a drive on which you can swap. It might also be usable as a 'fast', volatile disk, but I haven't tried that yet.

## The gateware (VHDL, obsolete)

Directory 'sbus-to-ztex-gateware', this is obsolete and replaced by the Migen gateware above.

The function embedded in the FPGA currently includes the PROM, lighting Led to display a 32-bits value, and a GHASH MAC (128 polynomial accumulator, used for the AES-GCM encryption scheme). The device is a fairly basic scale, but should be able to read from the PROM and read/write from the GCM space with any kind of SBus burst (1, 2, 4, 8 or 16 words).

The gateware is currently synthesized with Vivado 2020.1

## The software

Directory 'NetBSD'

Some basic drivers for NetBSD 9.0/sparc to enable the devices as described above.

