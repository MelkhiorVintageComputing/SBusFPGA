## Current status

2021-03-21: The adapter board seems to work fine in two different SS20. Currently the embedded PROM code exposes three devices in the FPGA:

* "RDOL,cryptoengine": exposes a (way too large) polynomial multiplier to implement GCM mode and a AES block. Currently used to implement DMA-based acceleration of AES-256-CBC through /dev/crypto. Unfortunately OpenSSL doesn't support AES-256-GCM in the cryptodev engine, and disagree with NetBSD's /dev/crypto on how to implement AES-256-CTR. And the default SSH cannot use cryptodev, it closes all file descriptors after cryptodev has opened /dev/crypto... still WiP.

* "RDOL,trng": exposes a 5 MHz counter (didn't realize the SS20 already had a good counter) and a so-far-not-true TRNG (implemented by a PRNG). The 'true' random generators I've found make Vivado screams very loudly when synthesizing... anyway both works fine in NetBSD 9.0 as a timecounter and an entropy source (which a PRNG really isn't, I know).  still WiP.

* "RDOL,sdcard": trying to expose the micro-sd card slot as a storage device, at first using SPI mode. So far reading seems to work, and NetBSD can see a Sun disklabel on the micro-sd card if it has been partitioned that way. Mounting a FAT filesystem read-only now works (with very little testing as of yet). Writing not working yet. Very much WiP.
