# A FPGA on a SBus card...

## Goal

The goal of this repository is to be able to interface a modern (2020 era) [FPGA](https://en.wikipedia.org/wiki/Field-programmable_gate_array) with a [SBus](https://en.wikipedia.org/wiki/SBus) host. SBus was widely used in SPARCstation and compatibles system in the first halt of the 90s. It was progressively displaced by PCI from the mid-90s onward.

So unless you're a retrocomputing enthusiast with such a machine, this is useless. To be honest, even if you are such an enthusiast, it's probably not that useful...

I'm a software guy and know next to nothing about hardware design, so this is very much a work-in-progress and is likely full of rookie mistakes.

## The hardware

Directory 'sbus-to-ztex'

The board is a SBus-compliant (I hope...) board, designed to receive a ZTex USB-FPGA Module 2.13 as a daughterboard. The ZTex module contains the actual FPGA (Artix-7), some RAM, programming hardware, etc. The SBus board contains level-shifters ICs to interface between the SBus signals and the FPGA, some Leds, a JTAG header, and a micro-sd card slot.

## The gateware

Directory 'sbus-to-ztex-gateware'

The function embedded in the FPGA currently includes the PROM, lighting Led to display a 32-bits value, and a GHASH MAC (128 polynomial accumulator, used for the AES-GCM encryption scheme). The device is a fairly basic scale, but should be able to read from the PROM and read/write from the GCM space with any kind of SBus burst (1, 2, 4, 8 or 16 words).

## The software

Directory 'NetBSD'

A basic driver for NetBSD 9.0/sparc, with ioctl to access the LED and GHASH registers, along with a small test code.