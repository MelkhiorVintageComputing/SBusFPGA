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

typedef struct goblin_accel_regs {
	u_int32_t reg_status; // 0
	u_int32_t reg_cmd;
	u_int32_t reg_r5_cmd;
	u_int32_t resv0;
	u_int32_t reg_width; // 4
	u_int32_t reg_height;
	u_int32_t reg_fgcolor;
	u_int32_t resv2;
	u_int32_t reg_bitblt_src_x; // 8
	u_int32_t reg_bitblt_src_y;
	u_int32_t reg_bitblt_dst_x;
	u_int32_t reg_bitblt_dst_y;
	u_int32_t reg_src_stride; // 12
	u_int32_t reg_dst_stride;
	u_int32_t reg_src_ptr; // 14
	u_int32_t reg_dst_ptr;
} GoblinAccel, *GoblinAccelPtr;

#endif /* GOBLIN_REGS_H */
