# A FPGA on a SBus card...

## Goal

The goal of this repository is to be able to interface a modern (2020 era) [FPGA](https://en.wikipedia.org/wiki/Field-programmable_gate_array) with a [SBus](https://en.wikipedia.org/wiki/SBus) host. SBus was widely used in SPARCstation and compatibles system in the first half of the 90s. It was progressively displaced by PCI from the mid-90s onward, and is thoroughly obsolete.

So unless you're a retrocomputing enthusiast with such a machine, this is useless. To be honest, even if you are such an enthusiast, it's probably not that useful...

I'm a software guy and know next to nothing about hardware design, so this is very much a work-in-progress and is likely full of rookie mistakes.

To save on PCB cost, the board is smaller than a 'true' SBus board; the hardware directory includes an OpenSCAD 3D-printable extension to make the board compliant to the form factor (visible in the pictures in 'Pictures').

## Current status

2021-07-18: The old VHDL gateware has been replaced by a new Migen-based gateware, see below for details.

2021-08-22: Short version: the board enables a 256 MiB SDRAM disk (for fast swapping), a TRNG, a USB OHCI host controller (for USB peripherals) and a Curve25519 accelerator.

## The hardware

Directory 'sbus-to-ztex'

The custom board is a SBus-compliant (I hope...) board, designed to receive a [ZTex USB-FPGA Module 2.13](https://www.ztex.de/usb-fpga-2/usb-fpga-2.13.e.html) as a daughterboard. The ZTex module contains the actual FPGA (Artix-7), some RAM, programming hardware, etc. The SBus board contains level-shifters ICs to interface between the SBus signals and the FPGA, a serial header, some Leds, a JTAG header, and a micro-sd card slot. It only connects interrupt line 7 (highest priority) and 1 (lowest priority), which was a mistake (more interrupts are needed and 7 is too high-priority to use at this stage, so just the level 1 is usable), but otherwise supports every SBus feature except the optional parity (i.e. it can do both slave and master modes).

The PCB was designed with Kicad 5.0

## The gateware (Migen)

### Intro

The gateware was rewritten from scratch in the Migen language, choosen because that's what [Litex](https://github.com/enjoy-digital/litex/) uses.
It implements a simple CPU-less Litex SoC built around a Wishbone bus, with a bridge between the SBus and the Wishbone.

A ROM, a SDRAM controller ([litedram](https://github.com/enjoy-digital/litedram) to the on-board DDR3), a TRNG (using the [NeoRV32](https://github.com/stnolting/neorv32) TRNG), an USB OHCI (host controller, using the Litex wrapper around the [SpinalHDL](https://github.com/SpinalHDL/SpinalHDL) implementation) and a Curve25519 Crypto Engine (taken from the [Betrusted.IO](https://betrusted.io/) project) are connected to that bus.

### Details

Master access to the SBus by the host are routed to the Wishbone to access the various CSRs / control registers of the devices.

The ROM doesn't do much beyond exposing the devices' existence and specifications to the host.

The SDRAM has its own custom DMA controller, using native Litedram DMA to the memory, and some FIFO to/from the SBus. A custom NetBSD driver exposes it as a drive on which you can swap. It's also usable as a 'fast', volatile disk (for e.g. /tmp or similar temporary filesystem). It could use a interrupt line, but the only usable one in the current HW design is in use by the USB.

The TRNG has a NetBSD driver to add entropy to the entropy pool.

The USB OHCI DMA is bridged from the Wishbone to the SBus by having the physical addresses of the Wishbone (that match the virtual addresses from NetBSD DVMA allocations) to the bridge. Reads are buffered by block of 16 bytes; currently writes are unbuffered (and somewhat slow, as they need a full SBus master cycle for every transaction of 32 bits or less). The standard NetBSD OHCI driver is used, with just a small custom SBus-OHCI driver mirroring the PCI-OHCI one. It uses the interrupt level 1 available on the board. As the board has no USB connectors, the D+ and D- lines are routed to the Serial header pins, those (and GND) are connected to a pair of pins of [Dolu1990's USB PMod](https://github.com/Dolu1990/pmod_usb_host_x4), and the associated USB port is connected to an external self-powered USB hub (which is the one supplying the VBus). It's quite ugly but it works (of course I should redesign the PCB with a proper USB connector and a VBus).

The Curve25519 Engine currently exposes an IOCTL to do the computation, which has yet to be integrated usefully in e.g. OpenSSL. It could use a interrupt line, but the only usable one in the current HW design is in use by the USB.

### Special Notes

Currently the design uses a Wishbone Crossbar Interconnect from Litex instead of a Shared Interconnect, as for some reason using a Shared Interconnect causes issues between devices (disabling the USB OHCI seem also to solve the issue, it generates a lot of cycles on the buses). I might be misusing Wishbone. With the Crossbar, all devices are usable simultaneously.

As not everything lives in the same clock domain, the design also use a Wishbone CDC, a wrapper around the one from [Verilog Wishbone Components](https://github.com/alexforencich/verilog-wishbone).

## The gateware (VHDL, obsolete)

Directory 'sbus-to-ztex-gateware', this is obsolete and replaced by the Migen gateware above.

The function embedded in the FPGA currently includes the PROM, lighting Led to display a 32-bits value, and a GHASH MAC (128 polynomial accumulator, used for the AES-GCM encryption scheme). The device is a fairly basic scale, but should be able to read from the PROM and read/write from the GCM space with any kind of SBus burst (1, 2, 4, 8 or 16 words).

The gateware is currently synthesized with Vivado 2020.1

## The software

Directory 'NetBSD'

Some basic drivers for NetBSD 9.0/sparc to enable the devices as described above.

