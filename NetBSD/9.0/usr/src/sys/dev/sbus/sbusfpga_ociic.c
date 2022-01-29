/*	$NetBSD$	*/
/*
 * Original driver from OpenBSD:
 * Copyright (c) 2021 Mark Kettenis <kettenis@openbsd.org>
 *
 * NetBSD support for the SBusFPGA variant (based on the betrustedio wrapper):
 * Copyright (c) 2022 Romain Dolbeau <romain@dolbeau.org>
 *
 * Permission to use, copy, modify, and distribute this software for any
 * purpose with or without fee is hereby granted, provided that the above
 * copyright notice and this permission notice appear in all copies.
 *
 * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
 * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
 * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
 * ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
 * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
 * ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
 * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
 */

#include <sys/param.h>
#include <sys/systm.h>
#include <sys/device.h>

#include <sys/bus.h>
#include <machine/autoconf.h>
#include <sys/cpu.h>
#include <sys/conf.h>

#define _I2C_PRIVATE
#include <dev/i2c/i2cvar.h>

#include <machine/param.h>

//#define CONFIG_CSR_DATA_WIDTH 32
//#include "dev/sbus/sbusfpga_csr_i2c.h"

/* Registers */
/* with the betrustedio wrapper to the OC I2C core,
   prescale register is 16-bits,
   TXR/RXR are split, CR/SR are split,
   RESET, EV_* are new */
/* #define I2C_PRER_LO	0x0000 */
/* #define I2C_PRER_HI	0x0004 */
#define I2C_PRER	0x0000
#define I2C_CTR		0x0004
#define  I2C_CTR_EN	(1 << 7)
#define  I2C_CTR_IEN	(1 << 6)
#define I2C_TXR		0x0008
#define I2C_RXR		0x000C
#define I2C_CR		0x0010
#define  I2C_CR_STA	(1 << 7)
#define  I2C_CR_STO	(1 << 6)
#define  I2C_CR_RD	(1 << 5)
#define  I2C_CR_WR	(1 << 4)
#define  I2C_CR_NACK	(1 << 3)
#define  I2C_CR_IACK	(1 << 0)
#define I2C_SR		0x0014
#define  I2C_SR_RXNACK	(1 << 7)
#define  I2C_SR_BUSY	(1 << 6)
#define  I2C_SR_AL	(1 << 5)
#define  I2C_SR_TIP	(1 << 1)
#define  I2C_SR_IF	(1 << 0)
#define I2C_RESET	0x0018
#define I2C_EV_SR	0x001C
#define I2C_EV_PEND	0x0020
#define I2C_EV_ENAB	0x0024

struct ociic_softc {
	device_t                sc_dev;
	bus_space_tag_t	        sc_bustag;	/* bus tag */
	bus_space_handle_t      sc_bhregs_i2c;	/* bus handle */

	int			            sc_node;
	int                     sc_burst;		
	struct i2c_controller	sc_ic;
};

static inline uint8_t
ociic_read(struct ociic_softc *sc, bus_size_t reg)
{
	return bus_space_read_1(sc->sc_bustag, sc->sc_bhregs_i2c, reg);
}

static inline void
ociic_write(struct ociic_softc *sc, bus_size_t reg, const uint8_t value)
{
	bus_space_write_1(sc->sc_bustag, sc->sc_bhregs_i2c, reg, value);
}

static inline void
ociic_set(struct ociic_softc *sc, bus_size_t reg, const uint8_t bits)
{
	ociic_write(sc, reg, ociic_read(sc, reg) | bits);
}

static inline void
ociic_clr(struct ociic_softc *sc, bus_size_t reg, const uint8_t bits)
{
	ociic_write(sc, reg, ociic_read(sc, reg) & ~bits);
}

int	ociic_match(device_t, cfdata_t, void *);
void ociic_attach(device_t, device_t, void *);

CFATTACH_DECL_NEW(sbusfpga_ociic, sizeof(struct ociic_softc),
				  ociic_match, ociic_attach, NULL, NULL);

int	ociic_acquire_bus(void *, int);
void	ociic_release_bus(void *, int);
int	ociic_exec(void *, i2c_op_t, i2c_addr_t, const void *, size_t,
	    void *, size_t, int);

static prop_array_t create_dict(device_t parent);
static void add_prop(prop_array_t c, const char *name, const char *compat, u_int addr, int node);

void	ociic_bus_scan(struct device *, struct i2cbus_attach_args *, void *);

int
ociic_match(device_t parent, cfdata_t cf, void *aux)
{
	struct sbus_attach_args *sa = (struct sbus_attach_args *)aux;

	return (strcmp("oc,i2c", sa->sa_name) == 0);
}

void
ociic_attach(device_t parent, device_t self, void *aux)
{
	struct sbus_attach_args *sa = aux;
	struct ociic_softc *sc = device_private(self);
	struct sbus_softc *sbsc = device_private(parent);
	int sbusburst;
	struct i2cbus_attach_args iba;
	uint32_t clock_speed, bus_speed;
	uint32_t div;
		
	sc->sc_bustag = sa->sa_bustag;
	// sc->sc_dmatag = sa->sa_dmatag;
	sc->sc_dev = self;

	aprint_normal("\n");

	if (sa->sa_nreg < 1) {
		aprint_error(": Not enough registers spaces\n");
		return;
	}

	/* sc->sc_bustag = faa->fa_iot; */
	/* sc->sc_node = faa->fa_node; */
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

	aprint_normal_dev(self, "nid 0x%x, bustag %p, burst 0x%x (parent 0x%0x)\n",
			  sc->sc_node,
			  sc->sc_bustag,
			  sc->sc_burst,
			  sbsc->sc_burst);
	
	/* map registers */
	if (sbus_bus_map(sc->sc_bustag,
					 sa->sa_reg[0].oa_space /* sa_slot */,
					 sa->sa_reg[0].oa_base /* sa_offset */,
					 sa->sa_reg[0].oa_size /* sa_size */,
					 BUS_SPACE_MAP_LINEAR,
					 &sc->sc_bhregs_i2c) != 0) {
		aprint_error(": cannot map I2C registers\n");
		return;
	}

	/* pinctrl_byname(sc->sc_node, "default"); */
	/* clock_enable_all(sc->sc_node); */

	ociic_clr(sc, I2C_CTR, I2C_CTR_EN);

	clock_speed = prom_getpropint(sc->sc_node, "clock-speed", -1);
	bus_speed = prom_getpropint(sc->sc_node, "bus-speed", -1);

	aprint_normal_dev(self, "clock-speed = %d, bus-speed = %d\n", clock_speed, bus_speed);

	if ((clock_speed > 0) && (bus_speed > 0)) {
		div = (clock_speed / (5 * bus_speed));
		if (div > 0)
			div -= 1;
		if (div > 0xffff)
			div = 0xffff;

		/* ociic_write(sc, I2C_PRER_LO, div & 0xff); */
		/* ociic_write(sc, I2C_PRER_HI, div >> 8); */
		bus_space_write_2(sc->sc_bustag, sc->sc_bhregs_i2c, I2C_PRER, div);
		aprint_normal_dev(self, "div = %d\n", div);
	} else {
		aprint_error(": invalid clock/bus speed\n");
		return;
	}

	memset(&sc->sc_ic, 0, sizeof(sc->sc_ic));
	sc->sc_ic.ic_cookie = sc;
	sc->sc_ic.ic_acquire_bus = ociic_acquire_bus;
	sc->sc_ic.ic_release_bus = ociic_release_bus;
	sc->sc_ic.ic_exec = ociic_exec;

	/* Configure its children */
	memset(&iba, 0, sizeof(iba));
	iba.iba_tag = &sc->sc_ic;
	iba.iba_child_devices = create_dict(self);

	{
		char *name;
		char *compat;
		uint32_t addr;
		int node;
		for (node = prom_firstchild(sc->sc_node); node; node = prom_nextsibling(node)) {
			if ((name = prom_getpropstring(node, "name")) == NULL)
				continue;
			if (name[0] == '\0')
				continue;
			if ((compat = prom_getpropstring(node, "compatible")) == NULL)
				continue;
			if (compat[0] == '\0')
				continue;
			if ((addr = prom_getpropint(node, "addr", -1)) == -1)
				continue;
			
			add_prop(iba.iba_child_devices, name, compat, addr, sc->sc_node);
		}
	}

	config_found_ia(self, "i2cbus", &iba, iicbus_print);
}

int
ociic_acquire_bus(void *cookie, int flags)
{
	struct ociic_softc *sc = cookie;

	ociic_set(sc, I2C_CTR, I2C_CTR_EN);
	return 0;
}

void
ociic_release_bus(void *cookie, int flags)
{
	struct ociic_softc *sc = cookie;

	ociic_clr(sc, I2C_CTR, I2C_CTR_EN);
}

int
ociic_unbusy(struct ociic_softc *sc);
int
ociic_unbusy(struct ociic_softc *sc)
{
	uint8_t stat;
	int timo;

	for (timo = 50000; timo > 0; timo--) {
		stat = ociic_read(sc, I2C_SR);
		if ((stat & I2C_SR_BUSY) == 0)
			break;
		delay(10);
	}
	if (timo == 0) {
		ociic_write(sc, I2C_CR, I2C_CR_STO);
		return ETIMEDOUT;
	}

	return 0;
}

int
ociic_wait(struct ociic_softc *sc, int ack);
int
ociic_wait(struct ociic_softc *sc, int ack)
{
	uint8_t stat;
	int timo;

	for (timo = 50000; timo > 0; timo--) {
		stat = ociic_read(sc, I2C_SR);
		if ((stat & I2C_SR_TIP) == 0)
			break;
		if ((stat & I2C_SR_AL))
			break;
		delay(10);
	}
	if (timo == 0) {
		ociic_write(sc, I2C_CR, I2C_CR_STO);
		return ETIMEDOUT;
	}

	if (stat & I2C_SR_AL) {
		ociic_write(sc, I2C_CR, I2C_CR_STO);
		return EIO;
	}
	if (ack && (stat & I2C_SR_RXNACK)) {
		ociic_write(sc, I2C_CR, I2C_CR_STO);
		return EIO;
	}

	return 0;
}

int
ociic_exec(void *cookie, i2c_op_t op, i2c_addr_t addr, const void *cmd,
    size_t cmdlen, void *buf, size_t buflen, int flags)
{
	struct ociic_softc *sc = cookie;
	int error, i;
 
	error = ociic_unbusy(sc);
	if (error)
		return error;

	if (cmdlen > 0) {
		ociic_write(sc, I2C_TXR, addr << 1);
		ociic_write(sc, I2C_CR, I2C_CR_STA | I2C_CR_WR);
		error = ociic_wait(sc, 1);
		if (error)
			return error;

		for (i = 0; i < cmdlen; i++) {
			ociic_write(sc, I2C_TXR, ((const uint8_t *)cmd)[i]);
			ociic_write(sc, I2C_CR, I2C_CR_WR);
			error = ociic_wait(sc, 1);
			if (error)
				return error;
		}
	}

	if (I2C_OP_READ_P(op)) {
		ociic_write(sc, I2C_TXR, addr << 1 | 1);
		ociic_write(sc, I2C_CR, I2C_CR_STA | I2C_CR_WR);
		error = ociic_wait(sc, 1);
		if (error)
			return error;

		for (i = 0; i < buflen; i++) {
			ociic_write(sc, I2C_CR, I2C_CR_RD |
			    (i == (buflen - 1) ? I2C_CR_NACK : 0));
			error = ociic_wait(sc, 0);
			if (error)
				return error;
			((uint8_t *)buf)[i] = ociic_read(sc, I2C_RXR);
		}
	} else {
		if (cmdlen == 0) {
			ociic_write(sc, I2C_TXR, addr << 1);
			ociic_write(sc, I2C_CR, I2C_CR_STA | I2C_CR_WR);
		}

		for (i = 0; i < buflen; i++) {
			ociic_write(sc, I2C_TXR, ((const uint8_t *)buf)[i]);
			ociic_write(sc, I2C_CR, I2C_CR_WR);
			error = ociic_wait(sc, 1);
			if (error)
				return error;
		}
	}

	if (I2C_OP_STOP_P(op))
		ociic_write(sc, I2C_CR, I2C_CR_STO);

	return 0;
}

void
ociic_bus_scan(struct device *self, struct i2cbus_attach_args *iba, void *arg)
{
	int iba_node = *(int *)arg;
	struct i2c_attach_args ia;
	/* char name[32], status[32]; */
	/* uint32_t reg[1]; */
	char *name;
	uint32_t addr;
	int node;

	/* for (node = OF_child(iba_node); node; node = OF_peer(node)) { */
	/* 	memset(name, 0, sizeof(name)); */
	/* 	memset(status, 0, sizeof(status)); */
	/* 	memset(reg, 0, sizeof(reg)); */

	/* 	if (OF_getprop(node, "compatible", name, sizeof(name)) == -1) */
	/* 		continue; */
	/* 	if (name[0] == '\0') */
	/* 		continue; */

	/* 	if (OF_getprop(node, "status", status, sizeof(status)) > 0 && */
	/* 	    strcmp(status, "disabled") == 0) */
	/* 		continue; */

	/* 	if (OF_getprop(node, "reg", &reg, sizeof(reg)) != sizeof(reg)) */
	/* 		continue; */

	/* 	memset(&ia, 0, sizeof(ia)); */
	/* 	ia.ia_tag = iba->iba_tag; */
	/* 	ia.ia_addr = bemtoh32(&reg[0]); */
	/* 	ia.ia_name = name; */
	/* 	ia.ia_cookie = &node; */
	/* 	config_found(self, &ia, iicbus_print); */
	/* } */

	for (node = prom_firstchild(iba_node); node; node = prom_nextsibling(node)) {
		if ((name = prom_getpropstring(node, "name")) == NULL)
			continue;
		if (name[0] == '\0')
			continue;
		if ((addr = prom_getpropint(node, "addr", -1)) == -1)
			continue;
		
		memset(&ia, 0, sizeof(ia));
		ia.ia_tag = iba->iba_tag;
		ia.ia_addr = addr;
		ia.ia_name = name;
		ia.ia_cookie = (uintptr_t)&node;
		config_found(self, &ia, iicbus_print);
	}
}

/* stolen from arch/sparc64/dev/pcfiic_ebus.c */
static prop_array_t
create_dict(device_t parent)
{
	prop_dictionary_t props = device_properties(parent);
	prop_array_t cfg = prop_dictionary_get(props, "i2c-child-devices");
	if (cfg) return cfg;
	cfg = prop_array_create();
	prop_dictionary_set(props, "i2c-child-devices", cfg);
	prop_object_release(cfg);
	return cfg;
}

static void
add_prop(prop_array_t c, const char *name, const char *compat, u_int addr, int node)
{
	prop_dictionary_t dev;
	prop_data_t data;

	dev = prop_dictionary_create();
	prop_dictionary_set_cstring(dev, "name", name);
	data = prop_data_create_data(compat, strlen(compat)+1);
	prop_dictionary_set(dev, "compatible", data);
	prop_object_release(data);
	prop_dictionary_set_uint32(dev, "addr", addr);
	prop_dictionary_set_uint64(dev, "cookie", node);
	prop_array_add(c, dev);
	prop_object_release(dev);
}
