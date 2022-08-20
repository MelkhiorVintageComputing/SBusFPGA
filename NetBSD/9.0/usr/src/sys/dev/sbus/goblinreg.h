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
 * goblin display registers
 */

/* offsets */
#define GOBOFB_REG_BASE       0x200000
#define GOBOFB_MEM_BASE       0x1000000
#define GOBOFB_MODE           0x0
#define GOBOFB_VBL_MASK       0x4
#define GOBOFB_VIDEOCTRL      0x8
#define GOBOFB_INTR_CLEAR     0xc
#define GOBOFB_RESET          0x10 /* unused */
#define GOBOFB_LUT_ADDR       0x14
#define GOBOFB_LUT            0x18
#define GOBOFB_DEBUG          0x1c /* SW only */
#define GOBOFB_CURSOR_LUT     0x20
#define GOBOFB_CURSOR_XY      0x24
#define GOBOFB_MASK_BASE      0x80
#define GOBOFB_BITS_BASE      0x100

#define GOBOFB_MODE_1BIT  0x0
#define GOBOFB_MODE_2BIT  0x1
#define GOBOFB_MODE_4BIT  0x2
#define GOBOFB_MODE_8BIT  0x3
#define GOBOFB_MODE_24BIT 0x10

#define GOBOFB_VBL_MASK_OFF 0x0
#define GOBOFB_VBL_MASK_ON  0x1

#define GOBOFB_VIDEOCTRL_OFF 0x0
#define GOBOFB_VIDEOCTRL_ON  0x1

#define GOBOFB_INTR_CLEAR_CLEAR     0x0

#define GOBOFB_ACCEL_REG_STATUS     0x00
#define GOBOFB_ACCEL_REG_CMD        0x04
#define GOBOFB_ACCEL_REG_R5_CMD     0x08
#define GOBOFB_ACCEL_REG_OP         0x0C
#define GOBOFB_ACCEL_REG_WIDTH      0x10
#define GOBOFB_ACCEL_REG_HEIGHT     0x14
#define GOBOFB_ACCEL_REG_FGCOLOR    0x18
#define GOBOFB_ACCEL_REG_DEPTH      0x1C
#define GOBOFB_ACCEL_REG_SRC_X      0x20
#define GOBOFB_ACCEL_REG_SRC_Y      0x24
#define GOBOFB_ACCEL_REG_DST_X      0x28
#define GOBOFB_ACCEL_REG_DST_Y      0x2C
#define GOBOFB_ACCEL_REG_SRC_STRIDE 0x30
#define GOBOFB_ACCEL_REG_DST_STRIDE 0x34
#define GOBOFB_ACCEL_REG_SRC_PTR    0x38
#define GOBOFB_ACCEL_REG_DST_PTR    0x3c

#define GOBOFB_ACCEL_REG_MSK_X      0x40
#define GOBOFB_ACCEL_REG_MSK_Y      0x44
#define GOBOFB_ACCEL_REG_MSK_STRIDE 0x48
#define GOBOFB_ACCEL_REG_MSK_PTR    0x4c

// status
#define WORK_IN_PROGRESS_BIT 0

// cmd
#define DO_BLIT_BIT            0 // hardwired in goblin_accel.py
#define DO_FILL_BIT            1 // hardwired in goblin_accel.py
#define DO_PATT_BIT            2 // hardwired in goblin_accel.py
#define DO_TEST_BIT            3 // hardwired in goblin_accel.py

