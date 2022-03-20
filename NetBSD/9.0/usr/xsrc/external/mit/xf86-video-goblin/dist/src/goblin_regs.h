/*
 * GX and Turbo GX framebuffer - hardware registers.
 *
 * Copyright (C) 2000 Jakub Jelinek (jakub@redhat.com)
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.  IN NO EVENT SHALL
 * JAKUB JELINEK BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
 * IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
 * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */

#ifndef GOBLIN_REGS_H
#define GOBLIN_REGS_H

/* offsets */
#define GOBOFB_REG_BASE       0x200000
#define GOBOFB_MEM_BASE       0x1000000
#define GOBOFB_MODE           0x0
#define GOBOFB_VBL_MASK       0x4
#define GOBOFB_VIDEOCTRL      0x8
#define GOBOFB_INTR_CLEAR     0xc
#define GOBOFB_RESET          0x10
#define GOBOFB_LUT_ADDR       0x14
#define GOBOFB_LUT            0x18

#define GOBOFB_MODE_1BIT  0x0
#define GOBOFB_MODE_2BIT  0x1
#define GOBOFB_MODE_4BIT  0x2
#define GOBOFB_MODE_8BIT  0x3
#define GOBOFB_MODE_24BIT 0x10

#define GOBOFB_VBL_MASK_OFF 0x0
#define GOBOFB_VBL_MASK_ON 0x1

#define GOBOFB_VIDEOCTRL_OFF 0x0
#define GOBOFB_VIDEOCTRL_ON 0x1

#define GOBOFB_INTR_CLEAR_CLEAR     0x0

typedef struct goblin_fbc {
	volatile uint32_t mode; /* 0 */
	volatile uint32_t vbl_mask;
	volatile uint32_t videoctrl;
	volatile uint32_t intr_clear;
	volatile uint32_t reset; /* 4 */
	volatile uint32_t lut_addr;
	volatile uint32_t lut;
	volatile uint32_t debug;
	volatile uint32_t cursor_lut; /* 8 */
	volatile uint32_t cursor_xy;
	uint32_t padding[6]; /* 0xa..0xf */
        uint32_t padding2[16]; /* 0x10 .. 0x1f */
        volatile uint32_t curmask[32]; /* 0x20 .. 0x3f */
        volatile uint32_t curbits[32]; /* 0x40 .. 0x5f */
} GoblinFbc, *GoblinFbcPtr;

typedef struct jareth_reg {
	volatile uint32_t window;
	volatile uint32_t mpstart;
	volatile uint32_t mplen;
	volatile uint32_t control;
	volatile uint32_t mpresume;
	volatile uint32_t power;
	volatile uint32_t status;
	volatile uint32_t ev_status;
	volatile uint32_t ev_prending;
	volatile uint32_t ev_enable;
	volatile uint32_t instruction;
	volatile uint32_t ls_status;
	volatile uint32_t cyc_counter;
} JarethReg, *JarethRegPtr;

typedef struct jareth_microcode {
	volatile uint32_t mc[1024];
} JarethMicrocode, *JarethMicrocodePtr;

typedef struct jareth_regfile {
	volatile uint32_t reg[32][8];
} JarethRegfile, *JarethRegfilePtr;

#endif /* GOBLIN_REGS_H */
