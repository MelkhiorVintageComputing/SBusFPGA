/*	$NetBSD$ */

/*-
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

#include <sys/cdefs.h>
__KERNEL_RCSID(0, "$NetBSD$");

#include <sys/param.h>
#include <sys/systm.h>
#include <sys/kernel.h>
#include <sys/errno.h>
#include <sys/device.h>
#include <sys/malloc.h>

#include <sys/bus.h>
#include <machine/autoconf.h>
#include <sys/cpu.h>
#include <sys/conf.h>
#include <sys/ioccom.h>

#include <sys/mman.h>
#include <sys/param.h>
#include <uvm/uvm_extern.h>
#include <sys/kmem.h>

#include <dev/sbus/sbusvar.h>

#include <dev/sbus/jareth.h>

#include <machine/param.h>

int	jareth_print(void *, const char *);
int	jareth_match(device_t, cfdata_t, void *);
void	jareth_attach(device_t, device_t, void *);

CFATTACH_DECL_NEW(jareth, sizeof(struct jareth_softc),
    jareth_match, jareth_attach, NULL, NULL);

dev_type_open(jareth_open);
dev_type_close(jareth_close);
dev_type_ioctl(jareth_ioctl);
dev_type_mmap(jareth_mmap);



const struct cdevsw jareth_cdevsw = {
	.d_open = jareth_open,
	.d_close = jareth_close,
	.d_read = noread,
	.d_write = nowrite,
	.d_ioctl = jareth_ioctl,
	.d_stop = nostop,
	.d_tty = notty,
	.d_poll = nopoll,
	.d_mmap = jareth_mmap,
	.d_kqfilter = nokqfilter,
	.d_discard = nodiscard,
	.d_flag = 0
};

extern struct cfdriver jareth_cd;

struct jareth_testjob {
	uint32_t data[32][8];
};

static int init_programs(struct jareth_softc *sc);
static int write_inputs(struct jareth_softc *sc, struct jareth_testjob *job, const int window);
static int start_job(struct jareth_softc *sc);
static int wait_job(struct jareth_softc *sc, uint32_t param);
static int read_outputs(struct jareth_softc *sc, struct jareth_testjob *job, const int window);
static int dma_init(struct jareth_softc *sc);

static int power_on(struct jareth_softc *sc);
static int power_off(struct jareth_softc *sc);

int
jareth_open(dev_t dev, int flags, int mode, struct lwp *l)
{
	int unit = minor(dev) & (MAX_SESSION - 1);
	int driver = unit & ~(MAX_SESSION - 1);
	struct jareth_softc *sc = device_lookup_private(&jareth_cd, driver);

	if (sc == NULL)
		return ENODEV;

	if ((unit != 0) && ((sc->active_sessions & (1 << unit)) == 0)) {
		return ENODEV;
	}
	
	/* first we need to turn the engine power on ... */
	power_on(sc);
	
	return (0);
}

int
jareth_close(dev_t dev, int flags, int mode, struct lwp *l)
{
	int unit = minor(dev) & (MAX_SESSION - 1);
	int driver = unit & ~(MAX_SESSION - 1);
	struct jareth_softc *sc = device_lookup_private(&jareth_cd, driver);

	if (sc == NULL)
		return ENODEV;

	if ((unit != 0) && (sc->active_sessions & (1 << unit))) {
		device_printf(sc->sc_dev, "warning: close() on active session\n");
		sc->active_sessions &= ~(1 << unit);
		sc->mapped_sessions &= ~(1 << unit);
	}

	if (sc->active_sessions == 0)
		power_off(sc);
	
	return (0);
}

int
jareth_print(void *aux, const char *busname)
{

	sbus_print(aux, busname);
	return (UNCONF);
}

int
jareth_match(device_t parent, cfdata_t cf, void *aux)
{
	struct sbus_attach_args *sa = (struct sbus_attach_args *)aux;

	return (strcmp("jareth", sa->sa_name) == 0);
}

static const uint32_t program_test0[25] = { 0x01fc0014,0x407c0012,0xa0400013,0xa0c40013,0x007f0014,0x017f0054,0x0016f087,0x00185086,0x06000189,0x00480400,0x004c0440,0x00440420,0x00500440,0x617d1013,0x001b0186,0x01800189,0x20410015,0x20c51015,0xfb000809,0x20c51015,0x617d1013,0x000c0012,0x00080011,0x0000000a,0x0000000a };

static const uint32_t* programs[2] = { program_test0, NULL };
static const uint32_t program_len[2] = { 25, 0 };
static       uint32_t program_offset[2];

static int do_test(struct jareth_softc *sc, uint32_t pidx);

/*
 * Attach all the sub-devices we can find
 */
void
jareth_attach(device_t parent, device_t self, void *aux)
{
	struct sbus_attach_args *sa = aux;
	struct jareth_softc *sc = device_private(self);
	struct sbus_softc *sbsc = device_private(parent);
	int node;
	int sbusburst;
		
	sc->sc_bustag = sa->sa_bustag;
	sc->sc_dmatag = sa->sa_dmatag;
	sc->sc_dev = self;

	aprint_normal("\n");

	if (sa->sa_nreg < 3) {
		aprint_error(": Not enough registers spaces\n");
		return;
	}

	/* map registers */
	if (sbus_bus_map(sc->sc_bustag,
					 sa->sa_reg[0].oa_space /* sa_slot */,
					 sa->sa_reg[0].oa_base /* sa_offset */,
					 sa->sa_reg[0].oa_size /* sa_size */,
					 BUS_SPACE_MAP_LINEAR,
					 &sc->sc_bhregs_jareth) != 0) {
		aprint_error(": cannot map Jareth registers\n");
		return;
	} else {
		aprint_normal_dev(self, "Jareth registers @ %p\n", (void*)sc->sc_bhregs_jareth);
	}
	/* map microcode */
	if (sbus_bus_map(sc->sc_bustag,
					 sa->sa_reg[1].oa_space /* sa_slot */,
					 sa->sa_reg[1].oa_base /* sa_offset */,
					 sa->sa_reg[1].oa_size /* sa_size */,
					 BUS_SPACE_MAP_LINEAR,
					 &sc->sc_bhregs_microcode) != 0) {
		aprint_error(": cannot map Jareth microcode\n");
		return;
	} else {
		aprint_normal_dev(self, "Jareth microcode @ %p\n", (void*)sc->sc_bhregs_microcode);
	}
	/* map register file */
	if (sbus_bus_map(sc->sc_bustag,
					 sa->sa_reg[2].oa_space /* sa_slot */,
					 sa->sa_reg[2].oa_base /* sa_offset */,
					 sa->sa_reg[2].oa_size /* sa_size */,
					 BUS_SPACE_MAP_LINEAR,
					 &sc->sc_bhregs_regfile) != 0) {
		aprint_error(": cannot map Jareth regfile\n");
		return;
	} else {
		aprint_normal_dev(self, "Jareth regfile @ %p\n", (void*)sc->sc_bhregs_regfile);
	}
	sc->sc_bufsiz_jareth = sa->sa_reg[0].oa_size;
	sc->sc_bufsiz_microcode = sa->sa_reg[1].oa_size;
	sc->sc_bufsiz_regfile = sa->sa_reg[2].oa_size;

	node = sc->sc_node = sa->sa_node;

	/*
	 * Get transfer burst size from PROM
	 */
	sbusburst = sbsc->sc_burst;
	if (sbusburst == 0)
		sbusburst = SBUS_BURST_32 - 1; /* 1->16 */

	sc->sc_burst = prom_getpropint(node, "burst-sizes", -1);
	if (sc->sc_burst == -1)
		/* take SBus burst sizes */
		sc->sc_burst = sbusburst;

	/* Clamp at parent's burst sizes */
	sc->sc_burst &= sbusburst;

	aprint_normal("\n");
	aprint_normal_dev(self, "nid 0x%x, bustag %p, burst 0x%x (parent 0x%0x)\n",
			  sc->sc_node,
			  sc->sc_bustag,
			  sc->sc_burst,
			  sbsc->sc_burst);

	/* first we need to turn the engine power on ... */
	power_on(sc);

	if (init_programs(sc)) {
		if (init_programs(sc)) {
			aprint_normal_dev(sc->sc_dev, "INIT - FAILED\n");
			sc->initialized = 0;
		} else {
			sc->initialized = 1;
		}	
	} else {
		sc->initialized = 1;
	}

	power_off(sc);

	sc->active_sessions = 0;
	sc->mapped_sessions = 0;

	if (!dma_init(sc)) {
		// ouch
		sc->active_sessions = 0xFFFFFFFF;
		sc->mapped_sessions = 0xFFFFFFFF;
	} else {
		do_test(sc, 0);
	}
}

#define CONFIG_CSR_DATA_WIDTH 32
#define sbusfpga_jareth_softc jareth_softc
#include "dev/sbus/sbusfpga_csr_jareth.h"
#undef sbusfpga_jareth_softc

#define REG_BASE(reg) (base + (reg * 32))
#define SUBREG_ADDR(reg, off) (REG_BASE(reg) + (off)*4)

#define SBUSFPGA_DO_TESTJOB   _IOWR(0, 0, struct jareth_testjob)

int
jareth_ioctl (dev_t dev, u_long cmd, void *data, int flag, struct lwp *l)
{
	int unit = minor(dev) & (MAX_SESSION - 1);
	int driver = unit & ~(MAX_SESSION - 1);
	struct jareth_softc *sc = device_lookup_private(&jareth_cd, driver);
	int err = 0;

	if (sc == NULL) {
		return ENODEV;
	}

	if (!sc->initialized) {
		if (init_programs(sc)) {
			return ENXIO;
		} else {
			sc->initialized = 1;
		}
	}
	switch (cmd) {
	case SBUSFPGA_DO_TESTJOB: {
		if (unit != 0)
			return ENOTTY;
		
		struct jareth_testjob* job = (struct jareth_testjob*)data;
		jareth_mpstart_write(sc, program_offset[0]);
		jareth_mplen_write(sc, program_len[0]);
	
		err = write_inputs(sc, job, 0);
		if (err)
			return err;
		err = start_job(sc);
		if (err)
			return err;
		delay(1);
		err = wait_job(sc, 1);
		if (err)
			return err;
		err = read_outputs(sc, job, 0);
		if (err)
			return err;
	}
		break;
		
	default:
		err = EINVAL;
		break;
	}

	return(err);
}


static int power_on(struct jareth_softc *sc) {
	int err = 0;
	if ((jareth_power_read(sc) & 1) == 0) {
		jareth_power_write(sc, 1);
		delay(1);
	}
	return err;
}
static int power_off(struct jareth_softc *sc) {
	int err = 0;
	jareth_power_write(sc, 0);
	return err;
}

static int init_programs(struct jareth_softc *sc) {
	/* the microcode is a the beginning */
	int err = 0;
	uint32_t i, j;
	uint32_t offset = 0;

	for (j = 0 ; programs[j] != NULL; j ++) {
		program_offset[j] = offset;
		for (i = 0 ; i < program_len[j] ; i++) {
			bus_space_write_4(sc->sc_bustag, sc->sc_bhregs_microcode, ((offset+i)*4), programs[j][i]);
			if ((i%16)==15)
				delay(1);
		}
		offset += program_len[j];
	}

	jareth_window_write(sc, 0); /* could use window_window to access fields, but it creates a RMW cycle for nothing */
	jareth_mpstart_write(sc, 0); /* EC25519 */
	jareth_mplen_write(sc, program_len[0]); /* EC25519 */

	aprint_normal_dev(sc->sc_dev, "INIT - Jareth status: 0x%08x\n", jareth_status_read(sc));

#if 1
	/* double check */
	u_int32_t x;
	int count = 0;
	for (i = 0 ; i < program_len[0] && count < 10; i++) {
		x = bus_space_read_4(sc->sc_bustag, sc->sc_bhregs_microcode, (i*4));
		if (x != programs[0][i]) {
			aprint_error_dev(sc->sc_dev, "INIT - Jareth program failure: [%d] 0x%08x <> 0x%08x\n", i, x, programs[0][i]);
			err = 1;
			count ++;
		}
		if ((i%8)==7)
			delay(1);
	}
	if ((x = jareth_window_read(sc)) != 0) {
			aprint_error_dev(sc->sc_dev, "INIT - Jareth register failure: window = 0x%08x\n", x);
			err = 1;
	}
	if ((x = jareth_mpstart_read(sc)) != 0) {
			aprint_error_dev(sc->sc_dev, "INIT - Jareth register failure: mpstart = 0x%08x\n", x);
			err = 1;
	}
	if ((x = jareth_mplen_read(sc)) != program_len[0]) {
			aprint_error_dev(sc->sc_dev, "INIT - Jareth register failure: mplen = 0x%08x\n", x);
			err = 1;
	}
	const int test_reg_num = 73;
	const uint32_t test_reg_value = 0x0C0FFEE0;
	bus_space_write_4(sc->sc_bustag, sc->sc_bhregs_regfile, 4*test_reg_num, test_reg_value);
	delay(1);
	if ((x = bus_space_read_4(sc->sc_bustag, sc->sc_bhregs_regfile, 4*test_reg_num)) != test_reg_value) {
		aprint_error_dev(sc->sc_dev, "INIT - Jareth register file failure: 0x%08x != 0x%08x\n", x, test_reg_value);
		err = 1;
	}
#endif
	
	return err;
}

static int write_inputs(struct jareth_softc *sc, struct jareth_testjob *job, const int window) {
	const uint32_t base = window * 0x400;
	int i, j;
	uint32_t status = jareth_status_read(sc);
	int err = 0;
	if (status & (1<<CSR_JARETH_STATUS_RUNNING_OFFSET)) {
		aprint_error_dev(sc->sc_dev, "WRITE - Jareth status: 0x%08x, still running?\n", status);
		return ENXIO;
	}
	for (j = 0 ; j < 4 ; j++) {
		for (i = 0 ; i < 8 ; i++) {
			bus_space_write_4(sc->sc_bustag, sc->sc_bhregs_regfile,SUBREG_ADDR(j,i), job->data[j][i]);
		}
	}

#if 1
	for (j = 0 ; j < 4 ; j++) {
		for (i = 0 ; i < 8 && !err; i ++) {
			if (job->data[j][i] != bus_space_read_4(sc->sc_bustag, sc->sc_bhregs_regfile,SUBREG_ADDR(j,i))) err = EIO;
			/* delay(1); */
		}
	}
	if (err) aprint_error_dev(sc->sc_dev, "WRITE - data did not read-write properly\n");
#endif

	return err;
}

static int start_job(struct jareth_softc *sc) {
	uint32_t status = jareth_status_read(sc);
	if (status & (1<<CSR_JARETH_STATUS_RUNNING_OFFSET)) {
		aprint_error_dev(sc->sc_dev, "START - Jareth status: 0x%08x, still running?\n", status);
		return ENXIO;
	}
	jareth_control_write(sc, 1);
	//aprint_normal_dev(sc->sc_dev, "START - Jareth status: 0x%08x\n", jareth_status_read(sc));
	
	return 0;
}

static int wait_job(struct jareth_softc *sc, uint32_t param) {
	uint32_t status = jareth_status_read(sc);
	int count = 0;
	int max_count = 250;
	int del = 1;
	const int max_del = 32;
	static int max_del_seen = 1;
	static int max_cnt_seen = 0;
	
	while ((status & (1<<CSR_JARETH_STATUS_RUNNING_OFFSET)) && (count < max_count)) {
		//uint32_t ls_status = jareth_ls_status_read(sc);
		//aprint_normal_dev(sc->sc_dev, "WAIT - ongoing, Jareth status: 0x%08x [%d] ls_status: 0x%08x\n", status, count, ls_status);
		count ++;
		delay(del);
		del = del < max_del ? 2*del : del;
		status = jareth_status_read(sc);
	}
	if (del > max_del_seen) {
		max_del_seen = del;
		aprint_normal_dev(sc->sc_dev, "WAIT - new max delay %d after %d count (param was %u)\n", max_del_seen, count, param);
	}
	if (count > max_cnt_seen) {
		max_cnt_seen = count;
		aprint_normal_dev(sc->sc_dev, "WAIT - new max count %d with %d delay (param was %u)\n", max_cnt_seen, del, param);
		
	}
	
	//jareth_control_write(sc, 0);
	if (status & (1<<CSR_JARETH_STATUS_RUNNING_OFFSET)) {
		aprint_error_dev(sc->sc_dev, "WAIT - Jareth status: 0x%08x (pc 0x%08x), did not finish in time? [inst: 0x%08x ls_status: 0x%08x]\n", status, (status>>1)&0x03ff, jareth_instruction_read(sc),  jareth_ls_status_read(sc));
		return ENXIO;
	} else if (status & (1<<CSR_JARETH_STATUS_SIGILL_OFFSET)) {
		aprint_error_dev(sc->sc_dev, "WAIT - Jareth status: 0x%08x, sigill [inst: 0x%08x ls_status: 0x%08x]\n", status, jareth_instruction_read(sc),  jareth_ls_status_read(sc));
		return ENXIO;
	} else if (status & (1<<CSR_JARETH_STATUS_ABORT_OFFSET)) {
		aprint_error_dev(sc->sc_dev, "WAIT - Jareth status: 0x%08x, aborted [inst: 0x%08x ls_status: 0x%08x]\n", status, jareth_instruction_read(sc),  jareth_ls_status_read(sc));
		return ENXIO;
	} else {
		//aprint_normal_dev(sc->sc_dev, "WAIT - Jareth status: 0x%08x [%d] ls_status: 0x%08x\n", status, count, jareth_ls_status_read(sc));
	}

	return 0;
}

static int read_outputs(struct jareth_softc *sc, struct jareth_testjob *job, const int window) {
	const uint32_t base = window * 0x400;
	int i, j;
	uint32_t status = jareth_status_read(sc);
	if (status & (1<<CSR_JARETH_STATUS_RUNNING_OFFSET)) {
		aprint_error_dev(sc->sc_dev, "READ - Jareth status: 0x%08x, still running?\n", status);
		return ENXIO;
	}

	for (j = 0 ; j < 32 ; j++) {
		for (i = 0 ; i < 8 ; i++) {
			job->data[j][i]   = bus_space_read_4(sc->sc_bustag, sc->sc_bhregs_regfile,SUBREG_ADDR(j,i));
		}
		delay(1);
	}

	return 0;
}


static int
dma_init(struct jareth_softc *sc) {
	
	/* Allocate a dmamap */
	if (bus_dmamap_create(sc->sc_dmatag, JARETH_VAL_DMA_MAX_SZ, 1, JARETH_VAL_DMA_MAX_SZ, 0, BUS_DMA_NOWAIT | BUS_DMA_ALLOCNOW, &sc->sc_dmamap) != 0) {
		aprint_error_dev(sc->sc_dev, "DMA map create failed\n");
		return 0;
	} else {
		aprint_normal_dev(sc->sc_dev, "dmamap: %lu %lu %d (%p)\n", sc->sc_dmamap->dm_maxsegsz, sc->sc_dmamap->dm_mapsize, sc->sc_dmamap->dm_nsegs, sc->sc_dmatag->_dmamap_load);
	}

	if (bus_dmamem_alloc(sc->sc_dmatag, JARETH_VAL_DMA_MAX_SZ, 64, 64, &sc->sc_segs, 1, &sc->sc_rsegs, BUS_DMA_NOWAIT | BUS_DMA_STREAMING)) {
		aprint_error_dev(sc->sc_dev, "cannot allocate DVMA memory");
		bus_dmamap_destroy(sc->sc_dmatag, sc->sc_dmamap);
		return 0;
	}
  
	if (bus_dmamem_map(sc->sc_dmatag, &sc->sc_segs, 1, JARETH_VAL_DMA_MAX_SZ, &sc->sc_dma_kva, BUS_DMA_NOWAIT)) {
		aprint_error_dev(sc->sc_dev, "cannot allocate DVMA address");
		bus_dmamem_free(sc->sc_dmatag, &sc->sc_segs, 1);
		bus_dmamap_destroy(sc->sc_dmatag, sc->sc_dmamap);
		return 0;
	}
  
	if (bus_dmamap_load(sc->sc_dmatag, sc->sc_dmamap, sc->sc_dma_kva, JARETH_VAL_DMA_MAX_SZ, /* kernel space */ NULL,
						BUS_DMA_NOWAIT | BUS_DMA_STREAMING | BUS_DMA_WRITE)) {
		aprint_error_dev(sc->sc_dev, "cannot load dma map");
		bus_dmamem_unmap(sc->sc_dmatag, &sc->sc_dma_kva, JARETH_VAL_DMA_MAX_SZ);
		bus_dmamem_free(sc->sc_dmatag, &sc->sc_segs, 1);
		bus_dmamap_destroy(sc->sc_dmatag, sc->sc_dmamap);
		return 0;
	}
	
	aprint_normal_dev(sc->sc_dev, "DMA: SW -> kernel address is %p, dvma address is 0x%08llx, seg %llx / %ld\n", sc->sc_dma_kva, sc->sc_dmamap->dm_segs[0].ds_addr, sc->sc_segs.ds_addr, sc->sc_segs.ds_len);
	
	return 1;
}

paddr_t jareth_mmap(dev_t dev, off_t offset, int prot) {
	int unit = minor(dev) & (MAX_SESSION - 1);
	int driver = unit & ~(MAX_SESSION - 1);
	struct jareth_softc *sc = device_lookup_private(&jareth_cd, driver);
	paddr_t addr = -1;

	device_printf(sc->sc_dev, "%s:%d: %lld %d for %d / %d\n", __PRETTY_FUNCTION__, __LINE__, offset, prot, driver, unit);
	
	if (offset != 0)
		return -1;
	if (prot & PROT_EXEC)
		return -1;
	/* if (sc->mapped_sessions & (1 << unit)) */
	/* 	return -1; */
	if ((sc->active_sessions & (1 << unit)) == 0)
		return -1;
	if (unit >= MAX_ACTIVE_SESSION)
		return -1;
	if (unit <= 0)
		return -1;
	
	//	addr = bus_dmamem_mmap(sc->sc_dmatag, sc->sc_dmamap->dm_segs, 1, (off_t)(4096*unit), prot, BUS_DMA_NOWAIT);
	if (pmap_extract(pmap_kernel(), ((vaddr_t)sc->sc_dma_kva) + (unit * 4096), &addr)) {
	
		device_printf(sc->sc_dev, "mapped page %d to 0x%08lx [0x%08lx], kernel is %p\n", unit, addr, atop(addr), (void*)(((vaddr_t)sc->sc_dma_kva) + (unit * 4096)));

		((uint32_t*)(((vaddr_t)sc->sc_dma_kva) + (unit * 4096)))[0] = 0xDEADBEEF;
		sc->mapped_sessions |= (1 << unit);
		
		return addr;
	}

	return -1;
}

static int do_test(struct jareth_softc *sc, uint32_t pidx) {
	struct jareth_testjob job;
	int err = 0, i, j, window = 0;

	power_on(sc);

	for (i = 0 ; i < 8 ; i++) {
		job.data[0][i] = 0;
		job.data[1][i] = 0;
		job.data[2][i] = 0;
		job.data[3][i] = 0x04030201 + 0x04040404 * i;
	}
	job.data[0][0] = (uint32_t)((vaddr_t)sc->sc_dmamap->dm_segs[0].ds_addr) + 3;
	job.data[0][1] = (uint32_t)((vaddr_t)sc->sc_dmamap->dm_segs[0].ds_addr) + 5 + 2048;
	job.data[0][2] = (uint32_t)((vaddr_t)sc->sc_dmamap->dm_segs[0].ds_addr) + 5 + 2048;
	job.data[1][0] = (uint32_t)((vaddr_t)sc->sc_dmamap->dm_segs[0].ds_addr) + 5 + 2048;
	job.data[1][1] = (uint32_t)((vaddr_t)sc->sc_dmamap->dm_segs[0].ds_addr) + 3;
	job.data[1][2] = (uint32_t)((vaddr_t)sc->sc_dmamap->dm_segs[0].ds_addr) + 5 + 2048;
	job.data[2][0] = 16;

	for (i = 0 ; i < 16 ; i++) {
		((uint32_t*)sc->sc_dma_kva)[i] = 0xDEADBEEF;
		((uint32_t*)sc->sc_dma_kva)[i+512] = 0x11111111;
	}
	
	jareth_mpstart_write(sc, program_offset[pidx]);
	jareth_mplen_write(sc, program_len[pidx]);
	
	err = write_inputs(sc, &job, window);
	if (!err)		err = start_job(sc);
	delay(1);
	if (!err)
		err = wait_job(sc, 1);
	if (!err)
		err = read_outputs(sc, &job, window);

	char buf[512];
	for (j = 0 ; j < 32; j++) {
		snprintf(buf, 512, "0x%08x 0x%08x 0x%08x 0x%08x 0x%08x 0x%08x 0x%08x 0x%08x", job.data[j][7-0], job.data[j][7-1], job.data[j][7-2], job.data[j][7-3], job.data[j][7-4], job.data[j][7-5], job.data[j][7-6], job.data[j][7-7]);
		aprint_normal("reg%d : %s\n", j, buf);
	}
	snprintf(buf, 512, "0x%08x 0x%08x 0x%08x 0x%08x 0x%08x 0x%08x 0x%08x 0x%08x",
			 ((uint32_t*)sc->sc_dma_kva)[0+512], ((uint32_t*)sc->sc_dma_kva)[1+512],
			 ((uint32_t*)sc->sc_dma_kva)[2+512], ((uint32_t*)sc->sc_dma_kva)[3+512],
			 ((uint32_t*)sc->sc_dma_kva)[4+512], ((uint32_t*)sc->sc_dma_kva)[5+512],
			 ((uint32_t*)sc->sc_dma_kva)[6+512], ((uint32_t*)sc->sc_dma_kva)[7+512]);
	aprint_normal("mem0_7 : %s\n", buf);
	snprintf(buf, 512, "0x%08x 0x%08x 0x%08x 0x%08x 0x%08x 0x%08x 0x%08x 0x%08x",
			 ((uint32_t*)sc->sc_dma_kva)[8+512], ((uint32_t*)sc->sc_dma_kva)[9+512],
			 ((uint32_t*)sc->sc_dma_kva)[10+512], ((uint32_t*)sc->sc_dma_kva)[11+512],
			 ((uint32_t*)sc->sc_dma_kva)[12+512], ((uint32_t*)sc->sc_dma_kva)[13+512],
			 ((uint32_t*)sc->sc_dma_kva)[14+512], ((uint32_t*)sc->sc_dma_kva)[15+512]);
	aprint_normal("mem8_15 : %s\n", buf);

	power_off(sc);

	return err;
}
