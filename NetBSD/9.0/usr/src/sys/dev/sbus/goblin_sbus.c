/*	$NetBSD$ */

/*
 * Copyright (c) 2022 Romain Dolbeau <romain@dolbeau.org>
 * All rights reserved.
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

/*
 * color display (goblin) driver.
 *
 * Does not use VBL interrupts
 */

#include <sys/cdefs.h>
__KERNEL_RCSID(0, "$NetBSD$");

#include <sys/param.h>
#include <sys/systm.h>
#include <sys/buf.h>
#include <sys/device.h>
#include <sys/ioctl.h>
#include <sys/malloc.h>
#include <sys/mman.h>
#include <sys/tty.h>
#include <sys/conf.h>

#include <sys/bus.h>
#include <machine/autoconf.h>

#include <dev/sun/fbio.h>
#include <dev/sun/fbvar.h>

#include <dev/sun/btreg.h>
#include <dev/sun/btvar.h>
#include <dev/sbus/goblinreg.h>
#include <dev/sbus/goblinvar.h>

#include <dev/sbus/sbusvar.h>


/* autoconfiguration driver */
static int	goblinmatch_sbus(device_t, cfdata_t, void *);
static void	goblinattach_sbus(device_t, device_t, void *);

CFATTACH_DECL_NEW(goblin_sbus, sizeof(struct goblin_softc),
    goblinmatch_sbus, goblinattach_sbus, NULL, NULL);

/*
 * Match a goblin.
 */
int
goblinmatch_sbus(device_t parent, cfdata_t cf, void *aux)
{
	struct sbus_attach_args *sa = aux;

	if (strcmp(cf->cf_name, sa->sa_name) == 0)
		return 100;	/* beat genfb(4) */

	return 0;
}

/*
 * Attach a display.  We need to notice if it is the console, too.
 */
void
goblinattach_sbus(device_t parent, device_t self, void *args)
{
	struct goblin_softc *sc = device_private(self);
	struct sbus_attach_args *sa = args;
	struct fbdevice *fb = &sc->sc_fb;
	int node = sa->sa_node;
	int isconsole;
	const char *name;
	bus_space_handle_t bh;

	sc->sc_dev = self;

	aprint_normal("\n");

	if (sa->sa_nreg < 2) {
		aprint_error(": Not enough registers spaces\n");
		return;
	}

	/* Remember cookies for goblin_mmap() */
	sc->sc_bustag = sa->sa_bustag;

	fb->fb_device = self;
	fb->fb_flags = device_cfdata(self)->cf_flags & FB_USERMASK;
	fb->fb_type.fb_type = FBTYPE_GOBLIN;

	fb->fb_type.fb_depth = 8;
	/* setsize picks from properties "height" and "width" */
	fb_setsize_obp(fb, fb->fb_type.fb_depth, 1152, 900, node);

	/* map registers */
	if (sbus_bus_map(sa->sa_bustag,
					 sa->sa_reg[0].oa_space /* sa_slot */,
					 sa->sa_reg[0].oa_base /* sa_offset */,
					 sa->sa_reg[0].oa_size /* sa_size */,
					 BUS_SPACE_MAP_LINEAR,
					 &bh) != 0) {
		aprint_error(": cannot map Goblin registers\n");
		return;
	} else {
		sc->sc_reg_fbc_paddr = sbus_bus_addr(sa->sa_bustag, sa->sa_reg[0].oa_space, sa->sa_reg[0].oa_base);
		aprint_normal_dev(self, "Goblin registers @ %p\n", (void*)bh);
	}
	sc->sc_fbc = (struct goblin_fbcontrol *)bus_space_vaddr(sa->sa_bustag, bh);

	isconsole = fb_is_console(node);
	name = prom_getpropstring(node, "model");
	if (name == NULL)
		name = "goblin";
	
	/* map FB */
	fb->fb_pixels = NULL;
	/* if (sa->sa_npromvaddrs != 0) */
	/* 	fb->fb_pixels = (void *)(u_long)sa->sa_promvaddrs[0]; */
	if (fb->fb_pixels == NULL) {
		if (sbus_bus_map(sa->sa_bustag,
						 sa->sa_reg[1].oa_space /* sa_slot */,
						 sa->sa_reg[1].oa_base /* sa_offset */,
						 sa->sa_reg[1].oa_size /* sa_size */,
						 BUS_SPACE_MAP_LINEAR | BUS_SPACE_MAP_LARGE,
						 &bh) != 0) {
			aprint_error(": cannot map Goblin framebuffer\n");
			return;
		} else {
			sc->sc_fb_paddr = sbus_bus_addr(sa->sa_bustag, sa->sa_reg[1].oa_space, sa->sa_reg[1].oa_base);
			sc->sc_size = sa->sa_reg[1].oa_size;
			aprint_normal_dev(self, "Goblin framebuffer @ %p (%d MiB)\n", (void*)bh, sc->sc_size/1048576);
		}
		fb->fb_pixels = (char *)bus_space_vaddr(sa->sa_bustag, bh);
	}

	sc->sc_has_jareth = prom_getpropint(node, "goblin-has-jareth", 0);
	sc->sc_internal_adr = prom_getpropint(node, "goblin-internal-fb", 0x8f000000);
	aprint_normal_dev(self, "Goblin framebuffer internally @ %p\n", (void*)sc->sc_internal_adr);

	if (sc->sc_has_jareth) {
		if (sa->sa_nreg < 5) {
			aprint_error(": Not enough registers spaces for Jareth\n");
			sc->sc_has_jareth = 0;
		} else {
			/* map registers */
			if (sbus_bus_map(sc->sc_bustag,
							 sa->sa_reg[2].oa_space /* sa_slot */,
							 sa->sa_reg[2].oa_base /* sa_offset */,
							 sa->sa_reg[2].oa_size /* sa_size */,
							 BUS_SPACE_MAP_LINEAR,
							 &sc->sc_bhregs_jareth) != 0) {
				aprint_error(": cannot map Jareth registers\n");
				sc->sc_has_jareth = 0;
			} else {
				sc->sc_jareth_reg_paddr = sbus_bus_addr(sa->sa_bustag, sa->sa_reg[2].oa_space, sa->sa_reg[2].oa_base);
				aprint_normal_dev(self, "Jareth registers @ %p\n", (void*)sc->sc_bhregs_jareth);
				/* map microcode */
				if (sbus_bus_map(sc->sc_bustag,
								 sa->sa_reg[3].oa_space /* sa_slot */,
								 sa->sa_reg[3].oa_base /* sa_offset */,
								 sa->sa_reg[3].oa_size /* sa_size */,
								 BUS_SPACE_MAP_LINEAR,
								 &sc->sc_bhregs_microcode) != 0) {
					aprint_error(": cannot map Jareth microcode\n");
					sc->sc_has_jareth = 0;
				} else {
					sc->sc_jareth_microcode_paddr = sbus_bus_addr(sa->sa_bustag, sa->sa_reg[3].oa_space, sa->sa_reg[3].oa_base);
					aprint_normal_dev(self, "Jareth microcode @ %p\n", (void*)sc->sc_bhregs_microcode);
					/* map register file */
					if (sbus_bus_map(sc->sc_bustag,
									 sa->sa_reg[4].oa_space /* sa_slot */,
									 sa->sa_reg[4].oa_base /* sa_offset */,
									 sa->sa_reg[4].oa_size /* sa_size */,
									 BUS_SPACE_MAP_LINEAR,
									 &sc->sc_bhregs_regfile) != 0) {
						aprint_error(": cannot map Jareth regfile\n");
						sc->sc_has_jareth = 0;
					} else {
						sc->sc_jareth_regfile_paddr = sbus_bus_addr(sa->sa_bustag, sa->sa_reg[4].oa_space, sa->sa_reg[4].oa_base);
						aprint_normal_dev(self, "Jareth regfile @ %p\n", (void*)sc->sc_bhregs_regfile);
					}
				}
			}
		}
	} else {
		aprint_normal_dev(self, "Jareth not available\n");
	}

	goblinattach(sc, name, isconsole);
}
