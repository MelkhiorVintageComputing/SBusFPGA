# A FPGA on a SBus card...

## Goal

The goal of this repository is to be able to interface a modern (2020 era) [FPGA](https://en.wikipedia.org/wiki/Field-programmable_gate_array) with a [SBus](https://en.wikipedia.org/wiki/SBus) host. SBus was widely used in SPARCstation and compatibles system in the first halt of the 90s. It was progressively displaced by PCI from the mid-90s onward, and is thoroughly obsolete.

So unless you're a retrocomputing enthusiast with such a machine, this is useless. To be honest, even if you are such an enthusiast, it's probably not that useful...

I'm a software guy and know next to nothing about hardware design, so this is very much a work-in-progress and is likely full of rookie mistakes.

To save on PCB cost, the board is smaller than a 'true' SBus board; the hardware directory includes an OpenSCAD 3D-printable extension to make the board compliant to the form factor (visible in the pictures in 'Pictures').

## Current status

2021-03-21: The adapter board seems to work fine in two different SS20. Currently the embedded PROM code exposes three devices in the FPGA:

* "RDOL,cryptoengine": exposes a (way too large) polynomial multiplier to implement GCM mode and a AES block. Currently used to implement DMA-based acceleration of AES-256-CBC through /dev/crypto. Unfortunately OpenSSL doesn't support AES-256-GCM in the cryptodev engine, and disagree with NetBSD's /dev/crypto on how to implement AES-256-CTR. And the default SSH cannot use cryptodev, it closes all file descriptors after cryptodev has opened /dev/crypto... still WiP.

* "RDOL,trng": exposes a 5 MHz counter (didn't realize the SS20 already had a good counter) and a so-far-not-true TRNG (implemented by a PRNG). The 'true' random generators I've found make Vivado screams very loudly when synthesizing... anyway both works fine in NetBSD 9.0 as a timecounter and an entropy source (which a PRNG really isn't, I know).  still WiP.

* "RDOL,sdcard": trying to expose the micro-sd card slot as a storage device, at first using SPI mode. So far reading seems to work, and NetBSD can see a Sun disklabel on the micro-sd card if it has been partitioned that way. Mounting a FAT filesystem read-only now works (with very little testing as of yet). Writing not working yet. Very much WiP.

## The hardware

Directory 'sbus-to-ztex'

The custom board is a SBus-compliant (I hope...) board, designed to receive a [ZTex USB-FPGA Module 2.13](https://www.ztex.de/usb-fpga-2/usb-fpga-2.13.e.html) as a daughterboard. The ZTex module contains the actual FPGA (Artix-7), some RAM, programming hardware, etc. The SBus board contains level-shifters ICs to interface between the SBus signals and the FPGA, a serial header, some Leds, a JTAG header, and a micro-sd card slot.

The PCB was designed with Kicad 5.0

## The gateware

Directory 'sbus-to-ztex-gateware'

The function embedded in the FPGA currently includes the PROM, lighting Led to display a 32-bits value, and a GHASH MAC (128 polynomial accumulator, used for the AES-GCM encryption scheme). The device is a fairly basic scale, but should be able to read from the PROM and read/write from the GCM space with any kind of SBus burst (1, 2, 4, 8 or 16 words).

The gateware is currently synthesized with Vivado 2020.1

## The software

Directory 'NetBSD'

Some basic drivers for NetBSD 9.0/sparc to enable the deviced as described above.

