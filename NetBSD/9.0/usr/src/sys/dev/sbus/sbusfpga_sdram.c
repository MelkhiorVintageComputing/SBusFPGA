/*	$NetBSD$ */

/*-
 * Copyright (c) 2021 Romain Dolbeau <romain@dolbeau.org>
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

#include <dev/sbus/sbusvar.h>

#include <dev/sbus/sbusfpga_sdram.h>

#include <machine/param.h>

int	sbusfpga_sdram_match(device_t, cfdata_t, void *);
void	sbusfpga_sdram_attach(device_t, device_t, void *);

CFATTACH_DECL_NEW(sbusfpga_sdram, sizeof(struct sbusfpga_sdram_softc),
    sbusfpga_sdram_match, sbusfpga_sdram_attach, NULL, NULL);

dev_type_open(sbusfpga_sdram_open);
dev_type_close(sbusfpga_sdram_close);
dev_type_ioctl(sbusfpga_sdram_ioctl);

const struct cdevsw sbusfpga_sdram_cdevsw = {
	.d_open = sbusfpga_sdram_open,
	.d_close = sbusfpga_sdram_close,
	.d_read = noread,
	.d_write = nowrite,
	.d_ioctl = sbusfpga_sdram_ioctl,
	.d_stop = nostop,
	.d_tty = notty,
	.d_poll = nopoll,
	.d_mmap = nommap,
	.d_kqfilter = nokqfilter,
	.d_discard = nodiscard,
	.d_flag = 0
};

extern struct cfdriver sbusfpga_sdram_cd;
int
sbusfpga_sdram_ioctl (dev_t dev, u_long cmd, void *data, int flag, struct lwp *l)
{
	//struct sbusfpga_sdram_softc *sc = device_lookup_private(&sbusfpga_sdram_cd, minor(dev));
	int err = 0;
	
	switch (cmd) {
	default:
		err = EINVAL;
		break;
	}
	return(err);
}

int
sbusfpga_sdram_open(dev_t dev, int flags, int mode, struct lwp *l)
{
	return (0);
}

int
sbusfpga_sdram_close(dev_t dev, int flags, int mode, struct lwp *l)
{
	return (0);
}

int
sbusfpga_sdram_match(device_t parent, cfdata_t cf, void *aux)
{
	struct sbus_attach_args *sa = (struct sbus_attach_args *)aux;

	return (strcmp("RDOL,sdram", sa->sa_name) == 0);
}

int
sdram_init(struct sbusfpga_sdram_softc *sc);

/*
 * Attach all the sub-devices we can find
 */
void
sbusfpga_sdram_attach(device_t parent, device_t self, void *aux)
{
	struct sbus_attach_args *sa = aux;
	struct sbusfpga_sdram_softc *sc = device_private(self);
	struct sbus_softc *sbsc = device_private(parent);
	int node;
	int sbusburst;
		
	sc->sc_bustag = sa->sa_bustag;
	sc->sc_dev = self;

	aprint_normal("\n");

	if (sa->sa_nreg < 2) {
		aprint_error(": Not enough registers spaces\n");
		return;
	}

	/* map DDR PHY */
	if (sbus_bus_map(sc->sc_bustag,
					 sa->sa_reg[0].oa_space /* sa_slot */,
					 sa->sa_reg[0].oa_base /* sa_offset */,
					 sa->sa_reg[0].oa_size /* sa_size */,
					 BUS_SPACE_MAP_LINEAR,
					 &sc->sc_bhregs_ddrphy) != 0) {
		aprint_error(": cannot map DDR PHY registers\n");
		return;
	} else {
		aprint_normal_dev(self, ": DDR PHY registers @ %p\n", (void*)sc->sc_bhregs_ddrphy);
	}
	/* map SDRAM DFII */
	if (sbus_bus_map(sc->sc_bustag,
					 sa->sa_reg[1].oa_space /* sa_slot */,
					 sa->sa_reg[1].oa_base /* sa_offset */,
					 sa->sa_reg[1].oa_size /* sa_size */,
					 BUS_SPACE_MAP_LINEAR,
					 &sc->sc_bhregs_sdram) != 0) {
		aprint_error(": cannot map SDRAM DFII registers\n");
		return;
	} else {
		aprint_normal_dev(self, ": SDRAM DFII registers @ %p\n", (void*)sc->sc_bhregs_sdram);
	}

	sc->sc_bufsiz_ddrphy = sa->sa_reg[0].oa_size;
	sc->sc_bufsiz_sdram = sa->sa_reg[1].oa_size;

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

	aprint_normal_dev(self, "nid 0x%x, bustag %p, burst 0x%x (parent 0x%0x)\n",
			  sc->sc_node,
			  sc->sc_bustag,
			  sc->sc_burst,
			  sbsc->sc_burst);

	sdram_init(sc);
}

#define CONFIG_CSR_DATA_WIDTH 32
// define CSR_LEDS_BASE to avoid defining the CSRs
#define CSR_LEDS_BASE
#include "dev/sbus/litex_csr.h"
#undef CSR_LEDS_BASE

/* auto-generated sdram_phy.h + sc */
#define DFII_CONTROL_SEL        0x01
#define DFII_CONTROL_CKE        0x02
#define DFII_CONTROL_ODT        0x04
#define DFII_CONTROL_RESET_N    0x08

#define DFII_COMMAND_CS         0x01
#define DFII_COMMAND_WE         0x02
#define DFII_COMMAND_CAS        0x04
#define DFII_COMMAND_RAS        0x08
#define DFII_COMMAND_WRDATA     0x10
#define DFII_COMMAND_RDDATA     0x20

#define SDRAM_PHY_A7DDRPHY
#define SDRAM_PHY_XDR 2
#define SDRAM_PHY_DATABITS 16
#define SDRAM_PHY_PHASES 4
#define SDRAM_PHY_CL 6
#define SDRAM_PHY_CWL 5
#define SDRAM_PHY_CMD_LATENCY 0
#define SDRAM_PHY_RDPHASE 2
#define SDRAM_PHY_WRPHASE 3
#define SDRAM_PHY_WRITE_LATENCY_CALIBRATION_CAPABLE
#define SDRAM_PHY_READ_LEVELING_CAPABLE
#define SDRAM_PHY_MODULES SDRAM_PHY_DATABITS/8
#define SDRAM_PHY_DELAYS 32
#define SDRAM_PHY_BITSLIPS 8

void cdelay(int i);

__attribute__((unused)) static inline void command_p0(struct sbusfpga_sdram_softc *sc, int cmd)
{
    sdram_dfii_pi0_command_write(sc, cmd);
    sdram_dfii_pi0_command_issue_write(sc, 1);
}
__attribute__((unused)) static inline void command_p1(struct sbusfpga_sdram_softc *sc, int cmd)
{
    sdram_dfii_pi1_command_write(sc, cmd);
    sdram_dfii_pi1_command_issue_write(sc, 1);
}
__attribute__((unused)) static inline void command_p2(struct sbusfpga_sdram_softc *sc, int cmd)
{
    sdram_dfii_pi2_command_write(sc, cmd);
    sdram_dfii_pi2_command_issue_write(sc, 1);
}
__attribute__((unused)) static inline void command_p3(struct sbusfpga_sdram_softc *sc, int cmd)
{
    sdram_dfii_pi3_command_write(sc, cmd);
    sdram_dfii_pi3_command_issue_write(sc, 1);
}

#define DFII_PIX_DATA_SIZE CSR_SDRAM_DFII_PI0_WRDATA_SIZE

static inline unsigned long sdram_dfii_pix_wrdata_addr(int phase){
    switch (phase) {
        case 0: return CSR_SDRAM_DFII_PI0_WRDATA_ADDR;
		case 1: return CSR_SDRAM_DFII_PI1_WRDATA_ADDR;
		case 2: return CSR_SDRAM_DFII_PI2_WRDATA_ADDR;
		case 3: return CSR_SDRAM_DFII_PI3_WRDATA_ADDR;
        default: return 0;
        }
}
    
static inline unsigned long sdram_dfii_pix_rddata_addr(int phase){
    switch (phase) {
        case 0: return CSR_SDRAM_DFII_PI0_RDDATA_ADDR;
		case 1: return CSR_SDRAM_DFII_PI1_RDDATA_ADDR;
		case 2: return CSR_SDRAM_DFII_PI2_RDDATA_ADDR;
		case 3: return CSR_SDRAM_DFII_PI3_RDDATA_ADDR;
        default: return 0;
        }
}
    
#define DDRX_MR_WRLVL_ADDRESS 1
#define DDRX_MR_WRLVL_RESET 6
#define DDRX_MR_WRLVL_BIT 7

static inline void init_sequence(struct sbusfpga_sdram_softc *sc)
{
	/* Release reset */
	sdram_dfii_pi0_address_write(sc, 0x0);
	sdram_dfii_pi0_baddress_write(sc, 0);
	sdram_dfii_control_write(sc, DFII_CONTROL_ODT|DFII_CONTROL_RESET_N);
	cdelay(50000);

	/* Bring CKE high */
	sdram_dfii_pi0_address_write(sc, 0x0);
	sdram_dfii_pi0_baddress_write(sc, 0);
	sdram_dfii_control_write(sc, DFII_CONTROL_CKE|DFII_CONTROL_ODT|DFII_CONTROL_RESET_N);
	cdelay(10000);

	/* Load Mode Register 2, CWL=5 */
	sdram_dfii_pi0_address_write(sc, 0x200);
	sdram_dfii_pi0_baddress_write(sc, 2);
	command_p0(sc, DFII_COMMAND_RAS|DFII_COMMAND_CAS|DFII_COMMAND_WE|DFII_COMMAND_CS);

	/* Load Mode Register 3 */
	sdram_dfii_pi0_address_write(sc, 0x0);
	sdram_dfii_pi0_baddress_write(sc, 3);
	command_p0(sc, DFII_COMMAND_RAS|DFII_COMMAND_CAS|DFII_COMMAND_WE|DFII_COMMAND_CS);

	/* Load Mode Register 1 */
	sdram_dfii_pi0_address_write(sc, 0x6);
	sdram_dfii_pi0_baddress_write(sc, 1);
	command_p0(sc, DFII_COMMAND_RAS|DFII_COMMAND_CAS|DFII_COMMAND_WE|DFII_COMMAND_CS);

	/* Load Mode Register 0, CL=6, BL=8 */
	sdram_dfii_pi0_address_write(sc, 0x920);
	sdram_dfii_pi0_baddress_write(sc, 0);
	command_p0(sc, DFII_COMMAND_RAS|DFII_COMMAND_CAS|DFII_COMMAND_WE|DFII_COMMAND_CS);
	cdelay(200);

	/* ZQ Calibration */
	sdram_dfii_pi0_address_write(sc, 0x400);
	sdram_dfii_pi0_baddress_write(sc, 0);
	command_p0(sc, DFII_COMMAND_WE|DFII_COMMAND_CS);
	cdelay(200);
}

/* from hw/common.h, +sc */

/* CSR data width (subreg. width) in bytes, for direct comparson to sizeof() */
#define CSR_DW_BYTES     (CONFIG_CSR_DATA_WIDTH/8)
#define CSR_OFFSET_BYTES 4

/* Number of subregs required for various total byte sizes, by subreg width:
 * NOTE: 1, 2, 4, and 8 bytes represent uint[8|16|32|64]_t C types; However,
 *       CSRs of intermediate byte sizes (24, 40, 48, and 56) are NOT padded
 *       (with extra unallocated subregisters) to the next valid C type!
 *  +-----+-----------------+
 *  | csr |      bytes      |
 *  | _dw | 1 2 3 4 5 6 7 8 |
 *  |     |-----=---=-=-=---|
 *  |  1  | 1 2 3 4 5 6 7 8 |
 *  |  2  | 1 1 2 2 3 3 4 4 |
 *  |  4  | 1 1 1 1 2 2 2 2 |
 *  |  8  | 1 1 1 1 1 1 1 1 |
 *  +-----+-----------------+ */
static inline int num_subregs(int csr_bytes)
{
	return (csr_bytes - 1) / CSR_DW_BYTES + 1;
}

/* Read a CSR of size 'csr_bytes' located at address 'a'. */
static inline uint64_t _csr_rd(struct sbusfpga_sdram_softc *sc, unsigned long a, int csr_bytes)
{
	uint64_t r = bus_space_read_4(sc->sc_bustag, 0, a);
	for (int i = 1; i < num_subregs(csr_bytes); i++) {
		r <<= CONFIG_CSR_DATA_WIDTH;
		a += CSR_OFFSET_BYTES;
		r |= bus_space_read_4(sc->sc_bustag, 0, a);
	}
	return r;
}

/* Write value 'v' to a CSR of size 'csr_bytes' located at address 'a'. */
static inline void _csr_wr(struct sbusfpga_sdram_softc *sc, unsigned long a, uint64_t v, int csr_bytes)
{
	int ns = num_subregs(csr_bytes);
	for (int i = 0; i < ns; i++) {
		bus_space_write_4(sc->sc_bustag, 0, a , v >> (CONFIG_CSR_DATA_WIDTH * (ns - 1 - i)));
		a += CSR_OFFSET_BYTES;
	}
}

// FIXME: - should we provide 24, 40, 48, and 56 bit csr_[rd|wr] methods?

static inline uint8_t csr_rd_uint8(struct sbusfpga_sdram_softc *sc, unsigned long a)
{
	return _csr_rd(sc, a, sizeof(uint8_t));
}

static inline void csr_wr_uint8(struct sbusfpga_sdram_softc *sc, uint8_t v, unsigned long a)
{
	_csr_wr(sc, a, v, sizeof(uint8_t));
}

static inline uint16_t csr_rd_uint16(struct sbusfpga_sdram_softc *sc, unsigned long a)
{
	return _csr_rd(sc, a, sizeof(uint16_t));
}

static inline void csr_wr_uint16(struct sbusfpga_sdram_softc *sc, uint16_t v, unsigned long a)
{
	_csr_wr(sc, a, v, sizeof(uint16_t));
}

static inline uint32_t csr_rd_uint32(struct sbusfpga_sdram_softc *sc, unsigned long a)
{
	return _csr_rd(sc, a, sizeof(uint32_t));
}

static inline void csr_wr_uint32(struct sbusfpga_sdram_softc *sc, uint32_t v, unsigned long a)
{
	_csr_wr(sc, a, v, sizeof(uint32_t));
}

static inline uint64_t csr_rd_uint64(struct sbusfpga_sdram_softc *sc, unsigned long a)
{
	return _csr_rd(sc, a, sizeof(uint64_t));
}

static inline void csr_wr_uint64(struct sbusfpga_sdram_softc *sc, uint64_t v, unsigned long a)
{
	_csr_wr(sc, a, v, sizeof(uint64_t));
}

/* Read a CSR located at address 'a' into an array 'buf' of 'cnt' elements.
 *
 * NOTE: Since CSR_DW_BYTES is a constant here, we might be tempted to further
 * optimize things by leaving out one or the other of the if() branches below,
 * depending on each unsigned type width;
 * However, this code is also meant to serve as a reference for how CSRs are
 * to be manipulated by other programs (e.g., an OS kernel), which may benefit
 * from dynamically handling multiple possible CSR subregister data widths
 * (e.g., by passing a value in through the Device Tree).
 * Ultimately, if CSR_DW_BYTES is indeed a constant, the compiler should be
 * able to determine on its own whether it can automatically optimize away one
 * of the if() branches! */
#define _csr_rd_buf(sc, a, buf, cnt) \
{ \
	int i, j, nsubs, n_sub_elem; \
	uint64_t r; \
	if (sizeof(buf[0]) >= CSR_DW_BYTES) { \
		/* one or more subregisters per element */ \
		for (i = 0; i < cnt; i++) { \
			buf[i] = _csr_rd(sc, a, sizeof(buf[0])); \
			a += CSR_OFFSET_BYTES * num_subregs(sizeof(buf[0])); \
		} \
	} else { \
		/* multiple elements per subregister (2, 4, or 8) */ \
		nsubs = num_subregs(sizeof(buf[0]) * cnt); \
		n_sub_elem = CSR_DW_BYTES / sizeof(buf[0]); \
		for (i = 0; i < nsubs; i++) { \
			r = bus_space_read_4(sc->sc_bustag, 0, a);	\
			for (j = n_sub_elem - 1; j >= 0; j--) { \
				if (i * n_sub_elem + j < cnt) \
					buf[i * n_sub_elem + j] = r; \
				r >>= sizeof(buf[0]) * 8; \
			} \
			a += CSR_OFFSET_BYTES;	\
		} \
	} \
}

/* Write an array 'buf' of 'cnt' elements to a CSR located at address 'a'.
 *
 * NOTE: The same optimization considerations apply here as with _csr_rd_buf()
 * above.
 */
#define _csr_wr_buf(sc, a, buf, cnt) \
{ \
	int i, j, nsubs, n_sub_elem; \
	uint64_t v; \
	if (sizeof(buf[0]) >= CSR_DW_BYTES) { \
		/* one or more subregisters per element */ \
		for (i = 0; i < cnt; i++) { \
			_csr_wr(sc, a, buf[i], sizeof(buf[0]));				 \
			a += CSR_OFFSET_BYTES * num_subregs(sizeof(buf[0])); \
		} \
	} else { \
		/* multiple elements per subregister (2, 4, or 8) */ \
		nsubs = num_subregs(sizeof(buf[0]) * cnt); \
		n_sub_elem = CSR_DW_BYTES / sizeof(buf[0]); \
		for (i = 0; i < nsubs; i++) { \
			v = buf[i * n_sub_elem + 0]; \
			for (j = 1; j < n_sub_elem; j++) { \
				if (i * n_sub_elem + j == cnt) \
					break; \
				v <<= sizeof(buf[0]) * 8; \
				v |= buf[i * n_sub_elem + j]; \
			} \
			bus_space_write_4(sc->sc_bustag, 0, a, v);	\
			a += CSR_OFFSET_BYTES;	\
		} \
	} \
}

static inline void csr_rd_buf_uint8(struct sbusfpga_sdram_softc *sc, unsigned long a, uint8_t *buf, int cnt)
{
	_csr_rd_buf(sc, a, buf, cnt);
}

static inline void csr_wr_buf_uint8(struct sbusfpga_sdram_softc *sc, unsigned long a,
					const uint8_t *buf, int cnt)
{
	_csr_wr_buf(sc, a, buf, cnt);
}

static inline void csr_rd_buf_uint16(struct sbusfpga_sdram_softc *sc, unsigned long a, uint16_t *buf, int cnt)
{
	_csr_rd_buf(sc, a, buf, cnt);
}

static inline void csr_wr_buf_uint16(struct sbusfpga_sdram_softc *sc, unsigned long a,
					const uint16_t *buf, int cnt)
{
	_csr_wr_buf(sc, a, buf, cnt);
}

static inline void csr_rd_buf_uint32(struct sbusfpga_sdram_softc *sc, unsigned long a, uint32_t *buf, int cnt)
{
	_csr_rd_buf(sc, a, buf, cnt);
}

static inline void csr_wr_buf_uint32(struct sbusfpga_sdram_softc *sc, unsigned long a,
					const uint32_t *buf, int cnt)
{
	_csr_wr_buf(sc, a, buf, cnt);
}

/* NOTE: the macros' "else" branch is unreachable, no need to be warned
 * about a >= 64bit left shift! */
#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wshift-count-overflow"
static inline void csr_rd_buf_uint64(struct sbusfpga_sdram_softc *sc, unsigned long a, uint64_t *buf, int cnt)
{
	_csr_rd_buf(sc, a, buf, cnt);
}

static inline void csr_wr_buf_uint64(struct sbusfpga_sdram_softc *sc, unsigned long a,
					const uint64_t *buf, int cnt)
{
	_csr_wr_buf(sc, a, buf, cnt);
}
#pragma GCC diagnostic pop

/* sdram.c from liblitedram, preprocessed for our case, + sc */

static inline unsigned long 
lfsr (unsigned long  bits, unsigned long  prev)
{
  static const unsigned long long lfsr_taps[] = {
    0x0L,
    0x0L,
    0x3L,
    0x6L,
    0xcL,
    0x14L,
    0x30L,
    0x60L,
    0xb8L,
    0x110L,
    0x240L,
    0x500L,
    0x829L,
    0x100dL,
    0x2015L,
    0x6000L,
    0xd008L,
    0x12000L,
    0x20400L,
    0x40023L,
    0x90000L,
    0x140000L,
    0x300000L,
    0x420000L,
    0xe10000L,
    0x1200000L,
    0x2000023L,
    0x4000013L,
    0x9000000L,
    0x14000000L,
    0x20000029L,
    0x48000000L,
    0x80200003L,
    0x100080000L,
    0x204000003L,
    0x500000000L,
    0x801000000L,
    0x100000001fL,
    0x2000000031L,
    0x4400000000L,
    0xa000140000L,
    0x12000000000L,
    0x300000c0000L,
    0x63000000000L,
    0xc0000030000L,
    0x1b0000000000L,
    0x300003000000L,
    0x420000000000L,
    0xc00000180000L,
    0x1008000000000L,
    0x3000000c00000L,
    0x6000c00000000L,
    0x9000000000000L,
    0x18003000000000L,
    0x30000000030000L,
    0x40000040000000L,
    0xc0000600000000L,
    0x102000000000000L,
    0x200004000000000L,
    0x600003000000000L,
    0xc00000000000000L,
    0x1800300000000000L,
    0x3000000000000030L,
    0x6000000000000000L,
    0x800000000000000dL
  };
  unsigned long lsb = prev & 1;
  prev >>= 1;
  prev ^= (-lsb) & lfsr_taps[bits];
  return prev;
}

__attribute__((unused))
     void
     cdelay (int i)
{
  while (i > 0) {
    __asm__ volatile ("");
    i--;
  }
}
#if 0
int
sdram_get_databits (void)
{
  return 16;
}
int
sdram_get_freq (void)
{
  return 2 * 4 * 100000000;
}
int
sdram_get_cl (void)
{
  return 6;
}
int
sdram_get_cwl (void)
{
  return 5;
}
#endif
static unsigned char
sdram_dfii_get_rdphase(struct sbusfpga_sdram_softc *sc)
{
  return ddrphy_rdphase_read(sc);
}
static unsigned char
sdram_dfii_get_wrphase(struct sbusfpga_sdram_softc *sc)
{
  return ddrphy_wrphase_read(sc);
}
static void
sdram_dfii_pix_address_write(struct sbusfpga_sdram_softc *sc, unsigned char phase, unsigned int value)
{
  switch (phase) {
  case 3:
    sdram_dfii_pi3_address_write(sc, value);
    break;
  case 2:
    sdram_dfii_pi2_address_write(sc, value);
    break;
  case 1:
    sdram_dfii_pi1_address_write(sc, value);
    break;
  default:
    sdram_dfii_pi0_address_write(sc, value);
  }
}
static void
sdram_dfii_pird_address_write(struct sbusfpga_sdram_softc *sc, unsigned int value)
{
  unsigned char rdphase = sdram_dfii_get_rdphase(sc);
  sdram_dfii_pix_address_write(sc, rdphase, value);
}
static void
sdram_dfii_piwr_address_write(struct sbusfpga_sdram_softc *sc, unsigned int value)
{
  unsigned char wrphase = sdram_dfii_get_wrphase(sc);
  sdram_dfii_pix_address_write(sc, wrphase, value);
}
static void
sdram_dfii_pix_baddress_write(struct sbusfpga_sdram_softc *sc, unsigned char phase, unsigned int value)
{
  switch (phase) {
  case 3:
    sdram_dfii_pi3_baddress_write(sc, value);
    break;
  case 2:
    sdram_dfii_pi2_baddress_write(sc, value);
    break;
  case 1:
    sdram_dfii_pi1_baddress_write(sc, value);
    break;
  default:
    sdram_dfii_pi0_baddress_write(sc, value);
  }
}
static void
sdram_dfii_pird_baddress_write(struct sbusfpga_sdram_softc *sc, unsigned int value)
{
  unsigned char rdphase = sdram_dfii_get_rdphase(sc);
  sdram_dfii_pix_baddress_write(sc, rdphase, value);
}
static void
sdram_dfii_piwr_baddress_write(struct sbusfpga_sdram_softc *sc, unsigned int value)
{
  unsigned char wrphase = sdram_dfii_get_wrphase(sc);
  sdram_dfii_pix_baddress_write(sc, wrphase, value);
}
static void
command_px(struct sbusfpga_sdram_softc *sc, unsigned char phase, unsigned int value)
{
  switch (phase) {
  case 3:
	  command_p3(sc, value);
    break;
  case 2:
	  command_p2(sc, value);
    break;
  case 1:
	  command_p1(sc, value);
    break;
  default:
	  command_p0(sc, value);
  }
}
static void
command_prd(struct sbusfpga_sdram_softc *sc, unsigned int value)
{
  unsigned char rdphase = sdram_dfii_get_rdphase(sc);
  command_px(sc, rdphase, value);
}
static void
command_pwr (struct sbusfpga_sdram_softc *sc, unsigned int value)
{
  unsigned char wrphase = sdram_dfii_get_wrphase(sc);
  command_px(sc, wrphase, value);
}
static void
sdram_software_control_on(struct sbusfpga_sdram_softc *sc)
{
  unsigned int previous;
  previous = sdram_dfii_control_read(sc);
  if (previous != (0x02 | 0x04 | 0x08)) {
    sdram_dfii_control_write(sc, (0x02 | 0x04 | 0x08));
    aprint_normal ("Switching SDRAM to software control.\n");
  }
}
static void
sdram_software_control_off(struct sbusfpga_sdram_softc *sc)
{
  unsigned int previous;
  previous = sdram_dfii_control_read(sc);
  if (previous != (0x01)) {
    sdram_dfii_control_write(sc, (0x01));
    aprint_normal ("Switching SDRAM to hardware control.\n");
  }
}
__attribute__((unused)) static void
sdram_mode_register_write(struct sbusfpga_sdram_softc *sc, char reg, int value)
{
  sdram_dfii_pi0_address_write(sc, value);
  sdram_dfii_pi0_baddress_write(sc, reg);
  command_p0(sc, 0x08 | 0x04 | 0x02 | 0x01);
}
typedef void (*delay_callback) (struct sbusfpga_sdram_softc *sc, int module);
static void
sdram_activate_test_row(struct sbusfpga_sdram_softc *sc)
{
  sdram_dfii_pi0_address_write(sc, 0);
  sdram_dfii_pi0_baddress_write(sc, 0);
  command_p0(sc, 0x08 | 0x01);
  cdelay (15);
}
static void
sdram_precharge_test_row(struct sbusfpga_sdram_softc *sc)
{
  sdram_dfii_pi0_address_write(sc, 0);
  sdram_dfii_pi0_baddress_write(sc, 0);
  command_p0(sc, 0x08 | 0x02 | 0x01);
  cdelay (15);
}
#if 0
// available from kern.h
static unsigned int
popcount (unsigned int x)
{
  x -= ((x >> 1) & 0x55555555);
  x = (x & 0x33333333) + ((x >> 2) & 0x33333333);
  x = (x + (x >> 4)) & 0x0F0F0F0F;
  x += (x >> 8);
  x += (x >> 16);
  return x & 0x0000003F;
}
#endif
static void
print_scan_errors (unsigned int errors)
{
  aprint_normal ("%d", errors == 0);
}
static unsigned int
sdram_write_read_check_test_pattern (struct sbusfpga_sdram_softc *sc, int module, unsigned int seed)
{
  int p, i;
  unsigned int errors;
  unsigned int prv;
  unsigned char tst[1 * 32 / 8];
  unsigned char prs[4][1 * 32 / 8];
  prv = seed;
  for (p = 0; p < 4; p++) {
    for (i = 0; i < 1 * 32 / 8; i++) {
      prv = lfsr (32, prv);
      prs[p][i] = prv;
    }
  }
  sdram_activate_test_row(sc);
  for (p = 0; p < 4; p++)
	  csr_wr_buf_uint8(sc, sc->sc_bhregs_sdram + (sdram_dfii_pix_wrdata_addr (p) - CSR_SDRAM_BASE), prs[p], 1 * 32 / 8); /* cleanme */
  sdram_dfii_piwr_address_write(sc, 0);
  sdram_dfii_piwr_baddress_write(sc, 0);
  command_pwr(sc, 0x04 | 0x02 | 0x01 | 0x10);
  cdelay (15);
  sdram_dfii_pird_address_write(sc, 0);
  sdram_dfii_pird_baddress_write(sc, 0);
  command_prd(sc, 0x04 | 0x01 | 0x20);
  cdelay (15);
  sdram_precharge_test_row(sc);
  errors = 0;
  for (p = 0; p < 4; p++) {
	  csr_rd_buf_uint8(sc, sc->sc_bhregs_sdram + (sdram_dfii_pix_rddata_addr (p) - CSR_SDRAM_BASE), tst, 1 * 32 / 8); /* cleanme */
    errors +=
      popcount (prs[p][16 / 8 - 1 - module] ^ tst[16 / 8 - 1 - module]);
    errors +=
      popcount (prs[p][2 * 16 / 8 - 1 - module] ^
		tst[2 * 16 / 8 - 1 - module]);
  }
  return errors;
}
static void
sdram_leveling_center_module (struct sbusfpga_sdram_softc *sc, int module, int show_short, int show_long,
			      delay_callback rst_delay,
			      delay_callback inc_delay)
{
  int i;
  int show;
  int working;
  unsigned int errors;
  int delay, delay_mid, delay_range;
  int delay_min = -1, delay_max = -1;
  if (show_long)
    aprint_normal ("m%d: |", module);
  delay = 0;
  rst_delay(sc, module);
  while (1) {
    errors = sdram_write_read_check_test_pattern(sc, module, 42);
    errors += sdram_write_read_check_test_pattern(sc, module, 84);
    working = errors == 0;
    show = show_long;
    if (show)
      print_scan_errors (errors);
    if (working && delay_min < 0) {
      delay_min = delay;
      break;
    }
    delay++;
    if (delay >= 32)
      break;
    inc_delay(sc, module);
  }
  delay++;
  inc_delay(sc, module);
  while (1) {
    errors = sdram_write_read_check_test_pattern(sc, module, 42);
    errors += sdram_write_read_check_test_pattern(sc, module, 84);
    working = errors == 0;
    show = show_long;
    if (show)
      print_scan_errors (errors);
    if (!working && delay_max < 0) {
      delay_max = delay;
    }
    delay++;
    if (delay >= 32)
      break;
    inc_delay(sc, module);
  }
  if (delay_max < 0) {
    delay_max = delay;
  }
  if (show_long)
    aprint_normal ("| ");
  delay_mid = (delay_min + delay_max) / 2 % 32;
  delay_range = (delay_max - delay_min) / 2;
  if (show_short) {
    if (delay_min < 0)
      aprint_normal ("delays: -");
    else
      aprint_normal ("delays: %02d+-%02d", delay_mid, delay_range);
  }
  if (show_long)
    aprint_normal ("\n");
  rst_delay(sc, module);
  cdelay (100);
  for (i = 0; i < delay_mid; i++) {
    inc_delay(sc, module);
    cdelay (100);
  }
}
int _sdram_tck_taps;
int _sdram_write_leveling_bitslips[16];
static void
sdram_read_leveling_rst_delay (struct sbusfpga_sdram_softc *sc, int module)
{
  ddrphy_dly_sel_write(sc, 1 << module);
  ddrphy_rdly_dq_rst_write(sc, 1);
  ddrphy_dly_sel_write(sc, 0);
}
static void
sdram_read_leveling_inc_delay (struct sbusfpga_sdram_softc *sc, int module)
{
  ddrphy_dly_sel_write(sc, 1 << module);
  ddrphy_rdly_dq_inc_write(sc, 1);
  ddrphy_dly_sel_write(sc, 0);
}
static void
sdram_read_leveling_rst_bitslip (struct sbusfpga_sdram_softc *sc, char m)
{
  ddrphy_dly_sel_write(sc, 1 << m);
  ddrphy_rdly_dq_bitslip_rst_write(sc, 1);
  ddrphy_dly_sel_write(sc, 0);
}
static void
sdram_read_leveling_inc_bitslip (struct sbusfpga_sdram_softc *sc, char m)
{
  ddrphy_dly_sel_write(sc, 1 << m);
  ddrphy_rdly_dq_bitslip_write(sc, 1);
  ddrphy_dly_sel_write(sc, 0);
}
static unsigned int
sdram_read_leveling_scan_module (struct sbusfpga_sdram_softc *sc, int module, int bitslip, int show)
{
  const unsigned int max_errors = 2 * (4 * 2 * 32);
  int i;
  unsigned int score;
  unsigned int errors;
  score = 0;
  if (show)
    aprint_normal ("  m%d, b%02d: |", module, bitslip);
  sdram_read_leveling_rst_delay(sc, module);
  for (i = 0; i < 32; i++) {
    int working;
    int _show = show;
    errors = sdram_write_read_check_test_pattern(sc, module, 42);
    errors += sdram_write_read_check_test_pattern(sc, module, 84);
    working = errors == 0;
    score += (working * max_errors * 32) + (max_errors - errors);
    if (_show) {
      print_scan_errors (errors);
    }
    sdram_read_leveling_inc_delay(sc, module);
  }
  if (show)
    aprint_normal ("| ");
  return score;
}
static void
sdram_read_leveling(struct sbusfpga_sdram_softc *sc)
{
  int module;
  int bitslip;
  unsigned int score;
  unsigned int best_score;
  int best_bitslip;
  for (module = 0; module < 16 / 8; module++) {
    best_score = 0;
    best_bitslip = 0;
    sdram_read_leveling_rst_bitslip(sc, module);
    for (bitslip = 0; bitslip < 8; bitslip++) {
      score = sdram_read_leveling_scan_module(sc, module, bitslip, 1);
      sdram_leveling_center_module(sc, module, 1, 0,
				    sdram_read_leveling_rst_delay,
				    sdram_read_leveling_inc_delay);
      aprint_normal ("\n");
      if (score > best_score) {
	best_bitslip = bitslip;
	best_score = score;
      }
      if (bitslip == 8 - 1)
	break;
      sdram_read_leveling_inc_bitslip(sc, module);
    }
    aprint_normal ("  best: m%d, b%02d ", module, best_bitslip);
    sdram_read_leveling_rst_bitslip(sc, module);
    for (bitslip = 0; bitslip < best_bitslip; bitslip++)
      sdram_read_leveling_inc_bitslip(sc, module);
    sdram_leveling_center_module(sc, module, 1, 0,
				  sdram_read_leveling_rst_delay,
				  sdram_read_leveling_inc_delay);
    aprint_normal ("\n");
  }
}
static void
sdram_write_latency_calibration(struct sbusfpga_sdram_softc *sc)
{
  int i;
  int module;
  int bitslip;
  unsigned int score;
  unsigned int subscore;
  unsigned int best_score;
  int best_bitslip;
  for (module = 0; module < 16 / 8; module++) {
    best_score = 0;
    best_bitslip = -1;
    for (bitslip = 0; bitslip < 8; bitslip += 2) {
      score = 0;
      ddrphy_dly_sel_write(sc, 1 << module);
      ddrphy_wdly_dq_bitslip_rst_write(sc, 1);
      for (i = 0; i < bitslip; i++) {
	ddrphy_wdly_dq_bitslip_write(sc, 1);
      }
      ddrphy_dly_sel_write(sc, 0);
      score = 0;
      sdram_read_leveling_rst_bitslip(sc, module);
      for (i = 0; i < 8; i++) {
	subscore = sdram_read_leveling_scan_module(sc, module, i, 0);
	score = subscore > score ? subscore : score;
	sdram_read_leveling_inc_bitslip(sc, module);
      }
      if (score > best_score) {
	best_bitslip = bitslip;
	best_score = score;
      }
    }
    if (_sdram_write_leveling_bitslips[module] < 0)
      bitslip = best_bitslip;
    else
      bitslip = _sdram_write_leveling_bitslips[module];
    if (bitslip == -1)
      aprint_normal ("m%d:- ", module);
    else
      aprint_normal ("m%d:%d ", module, bitslip);
    ddrphy_dly_sel_write(sc, 1 << module);
    ddrphy_wdly_dq_bitslip_rst_write(sc, 1);
    for (i = 0; i < bitslip; i++) {
      ddrphy_wdly_dq_bitslip_write(sc, 1);
    }
    ddrphy_dly_sel_write(sc, 0);
  }
  aprint_normal ("\n");
}
static int
sdram_leveling(struct sbusfpga_sdram_softc *sc)
{
  int module;
  sdram_software_control_on(sc);
  for (module = 0; module < 16 / 8; module++) {
    sdram_read_leveling_rst_delay(sc, module);
    sdram_read_leveling_rst_bitslip(sc, module);
  }
  aprint_normal ("Write latency calibration:\n");
  sdram_write_latency_calibration(sc);
  aprint_normal ("Read leveling:\n");
  sdram_read_leveling(sc);
  sdram_software_control_off(sc);
  return 1;
}
int
sdram_init(struct sbusfpga_sdram_softc *sc)
{
  ddrphy_rdphase_write(sc, 2);
  ddrphy_wrphase_write(sc, 3);
  aprint_normal ("Initializing SDRAM @0x%08lx...\n", 0x80000000L);
  sdram_software_control_on(sc);
  ddrphy_rst_write(sc, 1);
  cdelay (1000);
  ddrphy_rst_write(sc, 0);
  cdelay (1000);
  init_sequence(sc);
  sdram_leveling(sc);
  sdram_software_control_off(sc);
#if 0
  if (!memtest ((unsigned int *) 0x80000000L, (2 * 1024 * 1024))) {
    return 0;
  }
  memspeed ((unsigned int *) 0x80000000L, (2 * 1024 * 1024), 0);
#endif
  return 1;
}
