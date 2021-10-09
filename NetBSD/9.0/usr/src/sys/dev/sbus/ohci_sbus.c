/*	$NetBSD$	*/

/*
 * Copyright (c) 1998, 2021 The NetBSD Foundation, Inc.
 * All rights reserved.
 *
 * This code is derived from software contributed to The NetBSD Foundation
 * by Lennart Augustsson (lennart@augustsson.net) at
 * Carlstedt Research & Technology.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions
 * are met:
 * 1. Redistributions of source code must retain the above copyright
 *    notice, this list of conditions and the following disclaimer.
 * 2. Redistributions in binary form must reproduce the above copyright
 *    notice, this list of conditions and the following disclaimer in the
 *    documentation and/or other materials provided with the distribution.
 *
 * THIS SOFTWARE IS PROVIDED BY THE NETBSD FOUNDATION, INC. AND CONTRIBUTORS
 * ``AS IS'' AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED
 * TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
 * PURPOSE ARE DISCLAIMED.  IN NO EVENT SHALL THE FOUNDATION OR CONTRIBUTORS
 * BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
 * CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
 * SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
 * INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
 * CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
 * ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
 * POSSIBILITY OF SUCH DAMAGE.
 */

#include <sys/cdefs.h>
__KERNEL_RCSID(0, "$NetBSD$");

#include <sys/param.h>
#include <sys/systm.h>
#include <sys/kernel.h>
#include <sys/device.h>
#include <sys/proc.h>
#include <sys/queue.h>

#include <sys/bus.h>

#include <dev/sbus/sbusvar.h>
#include <machine/autoconf.h>

#include <dev/usb/usb.h>
#include <dev/usb/usbdi.h>
#include <dev/usb/usbdivar.h>
#include <dev/usb/usb_mem.h>

#include <dev/usb/ohcireg.h>
#include <dev/usb/ohcivar.h>

struct ohci_sbus_softc {
	ohci_softc_t sc;
	void         *sc_ih;
	int          sc_node;
	int          sc_burst;
};

static int
ohci_sbus_match(device_t parent, cfdata_t match, void *aux)
{
	struct sbus_attach_args *sa = (struct sbus_attach_args *)aux;
	/* generic-ohci is the default name, from device-tree */
	if (strcmp("generic-ohci", sa->sa_name) == 0)
		return 1;
	/* usb is the OFW name, qualified by device-type */
	const char* type = prom_getpropstring(sa->sa_node, "device-type");
	if (type != NULL && (strcmp("ohci", type) == 0))
		return 1;
	return 0;
}

static void
ohci_sbus_attach(device_t parent, device_t self, void *aux)
{
	struct ohci_sbus_softc *sc = device_private(self);
	struct sbus_attach_args *sa = (struct sbus_attach_args *)aux;
	struct sbus_softc *sbsc = device_private(parent);
	int sbusburst;

	sc->sc.sc_dev = self;
	sc->sc.sc_bus.ub_hcpriv = sc;
	sc->sc.iot = sa->sa_bustag;
	sc->sc.sc_size = sa->sa_size;

	/* **** SBus specific */
	sc->sc_node = sa->sa_node;
	/*
	 * Get transfer burst size from PROM
	 */
	sbusburst = sbsc->sc_burst;
	if (sbusburst == 0)
		sbusburst = SBUS_BURST_32 - 1; /* 1->16 */
	sc->sc_burst = prom_getpropint(sc->sc_node, "burst-sizes", -1);
	if (sc->sc_burst == -1)
		/* take SBus burst sizes */
		sc->sc_burst = sbusburst;
	/* Clamp at parent's burst sizes */
	sc->sc_burst &= sbusburst;

	if (0) { /* in PCI there's a test for some specific controller */
		sc->sc.sc_flags = OHCIF_SUPERIO;
	}

	/* check if memory space access is enabled */
	/* CHECKME: not needed ? */

	/* Map I/O registers */
	if (sbus_bus_map(sc->sc.iot, sa->sa_slot, sa->sa_offset, sc->sc.sc_size,
			 BUS_SPACE_MAP_LINEAR, &sc->sc.ioh) != 0) {
		aprint_error_dev(self, ": cannot map registers\n");
		return;
	}

	aprint_normal_dev(self, "nid 0x%x, bustag %p (0x%zx @ 0x%08lx), burst 0x%x (parent 0x%0x)\n",
			  sc->sc_node,
			  sc->sc.iot,
			  (size_t)sc->sc.sc_size,
			  sc->sc.ioh,
			  sc->sc_burst,
			  sbsc->sc_burst);

	/* we're SPECIAL!!! */
	/* sc->sc.sc_endian = OHCI_BIG_ENDIAN; */

	/* Disable interrupts, so we don't get any spurious ones. */
	bus_space_write_4(sc->sc.iot, sc->sc.ioh, OHCI_INTERRUPT_DISABLE,
			  OHCI_ALL_INTRS);

	sc->sc.sc_bus.ub_dmatag = sa->sa_dmatag;
	/* sc->sc.sc_bus.ub_dmatag = (void*)((char*)sc->sc.ioh + 0x10000); */

	/* Enable the device. */
	/* CHECKME: not needed ? */

	/* Map and establish the interrupt. */
	if (sa->sa_nintr != 0) {
		sc->sc_ih = bus_intr_establish(sc->sc.iot, sa->sa_pri,
					       IPL_NET, ohci_intr, sc); // checkme: interrupt priority
		if (sc->sc_ih == NULL) {
			aprint_error_dev(self, "couldn't establish interrupt (%d)\n", sa->sa_nintr);
		} else 
			aprint_normal_dev(self, "interrupting at %d / %d / %d\n", sa->sa_nintr, sa->sa_pri, IPL_NET);
	} else {
		aprint_error_dev(self, "no interrupt defined in PROM\n");
		goto fail;
	}

	int err = ohci_init(&sc->sc);
	if (err) {
		aprint_error_dev(self, "init failed, error=%d\n", err);
		goto fail;
	}

	if (!pmf_device_register1(self, ohci_suspend, ohci_resume,
	                          ohci_shutdown))
		aprint_error_dev(self, "couldn't establish power handler\n");

	/* Attach usb device. */
	sc->sc.sc_child = config_found(self, &sc->sc.sc_bus, usbctlprint);
	return;

fail:
	/* should we unmap ? */
	return;
}

static int
ohci_sbus_detach(device_t self, int flags)
{
	struct ohci_sbus_softc *sc = device_private(self);
	int rv;

	rv = ohci_detach(&sc->sc, flags);
	if (rv)
		return rv;

	pmf_device_deregister(self);

	ohci_shutdown(self, flags);

	/* Disable interrupts, so we don't get any spurious ones. */
	bus_space_write_4(sc->sc.iot, sc->sc.ioh,
			  OHCI_INTERRUPT_DISABLE, OHCI_ALL_INTRS);
	
	/* can we disestablish the interrupt ? */
	/* can we unmap the registers ? */
	return 0;
}

CFATTACH_DECL3_NEW(ohci_sbus, sizeof(struct ohci_sbus_softc),
    ohci_sbus_match, ohci_sbus_attach, ohci_sbus_detach, ohci_activate, NULL,
    ohci_childdet, DVF_DETACH_SHUTDOWN);
