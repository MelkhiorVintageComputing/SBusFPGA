/*
 ~/LITEX/riscv64-unknown-elf-gcc-10.1.0-2020.08.2-x86_64-linux-ubuntu14/bin/riscv64-unknown-elf-gcc -Os -S blit.c -march=rv32ib -mabi=ilp32 -mstrict-align -fno-builtin-memset -nostdlib -ffreestanding -nostartfiles
 ~/LITEX/riscv64-unknown-elf-gcc-10.1.0-2020.08.2-x86_64-linux-ubuntu14/bin/riscv64-unknown-elf-gcc -Os -o blit -march=rv32ib -mabi=ilp32 -T blit.lds  -nostartfiles blit.s
 ~/LITEX/riscv64-unknown-elf-gcc-10.1.0-2020.08.2-x86_64-linux-ubuntu14/bin/riscv64-unknown-elf-objcopy  -O binary -j .text blit blit.raw
*/


#define HRES 1280 // FIXME : should be generated
#define VRES 1024
#define BASE_FB   0x8FE00000 // FIXME : should be generated ; 2+ MiB of SDRAM as framebuffer

#define BASE_ROM 0x00410000 // FIXME : should be generated ; 4-64 KiB of Wishbone ROM ? ; also in the LDS file ; also in the Vex config

#define BASE_RAM 0x00420000 // FIXME : should be generated : 4-64 KiB of Wishbone SRAM ? ; also in _start
#define BASE_RAM_SIZE 0x00001000 // FIXME : should be generated : 4-64 KiB of Wishbone SRAM ? ; also in _start

#define BASE_FBC 0x00700000 // mandated by CG6 compatibility

#if 0
static inline unsigned_param_type mul_768(const unsigned_param_type a) {
	unsigned_param_type b = a + a;
	b = b + a; // a * 3
	b = b + b; // a * 6
	b = b + b; // a * 12
	b = b + b; // a * 24
	b = b + b; // a * 48
	b = b + b; // a * 96
	b = b + b; // a * 192
	b = b + b; // a * 384
	b = b + b; // a * 768
	return b;
}
#else
#define mul_768(a) (a * 768)
#endif

#if HRES == 768
#define mul_HRES(a) mul_768(a)
#else
#define mul_HRES(a) (a * HRES)
#endif

//typedef void (*boot_t)(void);
//typedef void (*start_t)(unsigned short, unsigned short, unsigned short, unsigned short, unsigned short, unsigned short, unsigned short, unsigned short);

typedef unsigned int uint32_t;
typedef unsigned int u_int32_t;

/*
struct control_blitter {
	volatile unsigned int fun;
	volatile unsigned int done;
	volatile unsigned short arg[8];
};
*/

#define FUN_DRAW 0x00000001 // hardwired in cg6_accel.py
#define FUN_BLIT 0x00000002 // hardwired in cg6_accel.py
#define FUN_FONT 0x00000004 // hardwired in cg6_accel.py
#define FUN_DONE_BIT           31
#define FUN_FONT_NEXT_RDY_BIT  30
#define FUN_FONT_NEXT_REQ_BIT  29
#define FUN_FONT_NEXT_DONE_BIT 28
#define FUN_DONE           (1<<FUN_DONE_BIT)
#define FUN_FONT_NEXT_RDY  (1<<FUN_FONT_NEXT_RDY_BIT)
#define FUN_FONT_NEXT_REQ  (1<<FUN_FONT_NEXT_REQ_BIT)
#define FUN_FONT_NEXT_DONE (1<<FUN_FONT_NEXT_DONE_BIT)

/* from NetBSD */
/* bits in FHC register */
#define	FHC_FBID_MASK	0xff000000	/* bits 24..31 are frame buffer ID */
#define	FHC_FBID_SHIFT	24
#define	FHC_REV_MASK	0x00f00000	/* bits 20..23 are revision */
#define	FHC_REV_SHIFT	20
#define	FHC_FROP_DISABLE 0x00080000	/* disable fast rasterops */
#define	FHC_ROW_DISABLE	0x00040000	/* disable row cache */
#define	FHC_SRC_DISABLE	0x00020000	/* disable source cache */
#define	FHC_DST_DISABLE	0x00010000	/* disable destination cache */
#define	FHC_RESET	0x00008000	/* reset FBC */
#define	FHC_XXX0	0x00004000	/* unused */
#define	FHC_LEBO	0x00002000	/* set little endian byte order */
#define	FHC_RES_MASK	0x00001800	/* bits 11&12 are resolution */
#define	FHC_RES_1024	 0x00000000		/* res = 1024x768 */
#define	FHC_RES_1152	 0x00000800		/* res = 1152x900 */
#define	FHC_RES_1280	 0x00001000		/* res = 1280x1024 */
#define	FHC_RES_1600	 0x00001800		/* res = 1600x1200 */
#define	FHC_CPU_MASK	0x00000600	/* bits 9&10 are cpu type */
#define	FHC_CPU_SPARC	 0x00000000		/* cpu = sparc */
#define	FHC_CPU_68020	 0x00000200		/* cpu = 68020 */
#define	FHC_CPU_386	 0x00000400		/* cpu = 80386 */
#define	FHC_CPU_XXX	 0x00000600		/* unused */
#define	FHC_TEST	0x00000100	/* modify TESTX and TESTY */
#define	FHC_TESTX_MASK	0x000000f0	/* bits 4..7 are test window X */
#define	FHC_TESTX_SHIFT	4
#define	FHC_TESTY_MASK	0x0000000f	/* bits 0..3 are test window Y */
#define	FHC_TESTY_SHIFT	0

/* Values for the mode register */
#define CG6_MODE	(										\
					   0x00200000 /* GX_BLIT_SRC */			\
					 | 0x00020000 /* GX_MODE_COLOR8 */		\
					 | 0x00008000 /* GX_DRAW_RENDER */		\
					 | 0x00002000 /* GX_BWRITE0_ENABLE */	\
					 | 0x00001000 /* GX_BWRITE1_DISABLE */	\
					 | 0x00000200 /* GX_BREAD_0 */			\
					 | 0x00000080 /* GX_BDISP_0 */			\
											)
#define CG6_MODE_MASK	(									\
						   0x00300000 /* GX_BLIT_ALL */		\
						 | 0x00060000 /* GX_MODE_ALL */		\
						 | 0x00018000 /* GX_DRAW_ALL */		\
						 | 0x00006000 /* GX_BWRITE0_ALL */	\
						 | 0x00001800 /* GX_BWRITE1_ALL */	\
						 | 0x00000600 /* GX_BREAD_ALL */	\
						 | 0x00000180 /* GX_BDISP_ALL */	\
												)

/* Value for the alu register for screen-to-screen copies */
#define CG6_ALU_COPY	(												\
						   0x80000000 /* GX_PLANE_ONES (ignore planemask register) */	\
						 | 0x20000000 /* GX_PIXEL_ONES (ignore pixelmask register) */ \
						 | 0x00800000 /* GX_ATTR_SUPP (function unknown) */	\
						 | 0x00000000 /* GX_RAST_BOOL (function unknown) */	\
						 | 0x00000000 /* GX_PLOT_PLOT (function unknown) */	\
						 | 0x08000000 /* GX_PATTERN_ONES (ignore pattern) */ \
						 | 0x01000000 /* GX_POLYG_OVERLAP (unsure - handle overlap?) */	\
						 | 0x0000cccc /* ALU = src */					\
												)

/* Value for the alu register for region fills */
#define CG6_ALU_FILL	(												\
						   0x80000000 /* GX_PLANE_ONES (ignore planemask register) */	\
						 | 0x20000000 /* GX_PIXEL_ONES (ignore pixelmask register) */ \
						 | 0x00800000 /* GX_ATTR_SUPP (function unknown) */	\
						 | 0x00000000 /* GX_RAST_BOOL (function unknown) */	\
						 | 0x00000000 /* GX_PLOT_PLOT (function unknown) */	\
						 | 0x08000000 /* GX_PATTERN_ONES (ignore pattern) */ \
						 | 0x01000000 /* GX_POLYG_OVERLAP (unsure - handle overlap?) */	\
						 | 0x0000ff00 /* ALU = fg color */				\
												)

/* Value for the alu register for toggling an area */
#define CG6_ALU_FLIP	(												\
						   0x80000000 /* GX_PLANE_ONES (ignore planemask register) */	\
						 | 0x20000000 /* GX_PIXEL_ONES (ignore pixelmask register) */ \
						 | 0x00800000 /* GX_ATTR_SUPP (function unknown) */	\
						 | 0x00000000 /* GX_RAST_BOOL (function unknown) */	\
						 | 0x00000000 /* GX_PLOT_PLOT (function unknown) */	\
						 | 0x08000000 /* GX_PATTERN_ONES (ignore pattern) */ \
						 | 0x01000000 /* GX_POLYG_OVERLAP (unsure - handle overlap?) */	\
						 | 0x00005555 /* ALU = ~dst */					\
												)

/* rasterops */
#define GX_ROP_CLEAR        0x0
#define GX_ROP_INVERT       0x1
#define GX_ROP_NOOP         0x2
#define GX_ROP_SET          0x3

#define GX_ROP_00_0(rop)    ((rop) << 0)
#define GX_ROP_00_1(rop)    ((rop) << 2)
#define GX_ROP_01_0(rop)    ((rop) << 4)
#define GX_ROP_01_1(rop)    ((rop) << 6)
#define GX_ROP_10_0(rop)    ((rop) << 8)
#define GX_ROP_10_1(rop)    ((rop) << 10)
#define GX_ROP_11_0(rop)    ((rop) << 12)
#define GX_ROP_11_1(rop)    ((rop) << 14)
#define GX_PLOT_PLOT        0x00000000
#define GX_PLOT_UNPLOT      0x00020000
#define GX_RAST_BOOL        0x00000000
#define GX_RAST_LINEAR      0x00040000
#define GX_ATTR_UNSUPP      0x00400000
#define GX_ATTR_SUPP        0x00800000
#define GX_POLYG_OVERLAP    0x01000000
#define GX_POLYG_NONOVERLAP 0x02000000
#define GX_PATTERN_ZEROS    0x04000000
#define GX_PATTERN_ONES     0x08000000
#define GX_PATTERN_MASK     0x0c000000
#define GX_PIXEL_ZEROS      0x10000000
#define GX_PIXEL_ONES       0x20000000
#define GX_PIXEL_MASK       0x30000000
#define GX_PLANE_ZEROS      0x40000000
#define GX_PLANE_ONES       0x80000000
#define GX_PLANE_MASK       0xc0000000
/* rops for bit blit / copy area
   with:
       Plane Mask - use plane mask reg.
       Pixel Mask - use all ones.
       Patt  Mask - use all ones.
*/

#define POLY_O          GX_POLYG_OVERLAP
#define POLY_N          GX_POLYG_NONOVERLAP

#define ROP_STANDARD    (GX_PLANE_MASK |\
                        GX_PIXEL_ONES |\
                        GX_ATTR_SUPP |\
                        GX_RAST_BOOL |\
                        GX_PLOT_PLOT)

/* fg = don't care  bg = don't care */

#define ROP_BLIT(O,I)   (ROP_STANDARD | \
                        GX_PATTERN_ONES |\
                        GX_ROP_11_1(I) |\
                        GX_ROP_11_0(O) |\
                        GX_ROP_10_1(I) |\
                        GX_ROP_10_0(O) |\
                        GX_ROP_01_1(I) |\
                        GX_ROP_01_0(O) |\
                        GX_ROP_00_1(I) |\
                        GX_ROP_00_0(O))

/* fg = fgPixel     bg = don't care */

#define ROP_FILL(O,I)   (ROP_STANDARD | \
                        GX_PATTERN_ONES |\
                        GX_ROP_11_1(I) |\
                        GX_ROP_11_0(I) |\
                        GX_ROP_10_1(I) |\
                        GX_ROP_10_0(I) | \
                        GX_ROP_01_1(O) |\
                        GX_ROP_01_0(O) |\
                        GX_ROP_00_1(O) |\
                        GX_ROP_00_0(O))

/* fg = fgPixel     bg = don't care */
 
#define ROP_STIP(O,I)   (ROP_STANDARD |\
                        GX_ROP_11_1(I) |\
                        GX_ROP_11_0(GX_ROP_NOOP) |\
                        GX_ROP_10_1(I) |\
                        GX_ROP_10_0(GX_ROP_NOOP) | \
                        GX_ROP_01_1(O) |\
                        GX_ROP_01_0(GX_ROP_NOOP) |\
                        GX_ROP_00_1(O) |\
                        GX_ROP_00_0(GX_ROP_NOOP))

/* fg = fgPixel     bg = bgPixel */
                            
#define ROP_OSTP(O,I)   (ROP_STANDARD |\
                        GX_ROP_11_1(I) |\
                        GX_ROP_11_0(I) |\
                        GX_ROP_10_1(I) |\
                        GX_ROP_10_0(O) |\
                        GX_ROP_01_1(O) |\
                        GX_ROP_01_0(I) |\
                        GX_ROP_00_1(O) |\
                        GX_ROP_00_0(O))

#define GX_ROP_USE_PIXELMASK    0x30000000

#define GX_BLT_INPROGRESS       0x20000000


/* status register(s) */
#define GX_EXCEPTION		0x80000000
#define GX_TEC_EXCEPTION	0x40000000
#define GX_FULL                 0x20000000
#define GX_INPROGRESS           0x10000000
#define GX_UNSUPPORTED_ATTR	0x02000000
#define GX_HRMONO		0x01000000
#define GX_OVERFLOW		0x00200000
#define GX_PICK			0x00100000
#define GX_TEC_HIDDEN		0x00040000
#define GX_TEC_INTERSECT	0x00020000
#define GX_TEC_VISIBLE		0x00010000
#define GX_BLIT_HARDWARE	0x00008000	/* hardware can blit this */
#define GX_BLIT_SOFTWARE	0x00004000	/* software must blit this */
#define GX_BLIT_SRC_HIDDEN	0x00002000
#define GX_BLIT_SRC_INTERSECT	0x00001000
#define GX_BLIT_SRC_VISIBLE	0x00000800
#define GX_BLIT_DST_HIDDEN	0x00000400
#define GX_BLIT_DST_INTERSECT	0x00000200
#define GX_BLIT_DST_VISIBLE	0x00000100
#define GX_DRAW_HARDWARE	0x00000010	/* hardware can draw this */
#define GX_DRAW_SOFTAWRE	0x00000008	/* software must draw this */
#define GX_DRAW_HIDDEN		0x00000004
#define GX_DRAW_INTERSECT	0x00000002
#define GX_DRAW_VISIBLE		0x00000001

/* MISC register */
#define GX_INDEX(n)         ((n) << 4)
#define GX_INDEX_ALL        0x00000030
#define GX_INDEX_MOD        0x00000040
#define GX_BDISP_0          0x00000080
#define GX_BDISP_1          0x00000100
#define GX_BDISP_ALL        0x00000180
#define GX_BREAD_0          0x00000200
#define GX_BREAD_1          0x00000400
#define GX_BREAD_ALL        0x00000600
#define GX_BWRITE1_ENABLE   0x00000800
#define GX_BWRITE1_DISABLE  0x00001000
#define GX_BWRITE1_ALL      0x00001800
#define GX_BWRITE0_ENABLE   0x00002000
#define GX_BWRITE0_DISABLE  0x00004000
#define GX_BWRITE0_ALL      0x00006000
#define GX_DRAW_RENDER      0x00008000
#define GX_DRAW_PICK        0x00010000
#define GX_DRAW_ALL         0x00018000
#define GX_MODE_COLOR8      0x00020000
#define GX_MODE_COLOR1      0x00040000
#define GX_MODE_HRMONO      0x00060000
#define GX_MODE_ALL         0x00060000
#define GX_VBLANK           0x00080000
#define GX_BLIT_NOSRC       0x00100000
#define GX_BLIT_SRC         0x00200000
#define GX_BLIT_ALL         0x00300000


/* the FBC, mapped at BASE_FDC */
struct cg6_fbc {
	u_int32_t fbc_config;		/* r/o CONFIG register */
	u_int32_t fbc_mode;	/* mode setting */
	u_int32_t fbc_clip;		/* TEC clip check */
	u_int32_t fbc_pad2[1];
	u_int32_t fbc_s;		/* global status */
	u_int32_t fbc_draw;		/* drawing pipeline status */
	u_int32_t fbc_blit;		/* blitter status */
    u_int32_t fbc_font;		/* pixel transfer register */
	u_int32_t fbc_pad3[24];
	u_int32_t fbc_x0;		/* blitter, src llx */
	u_int32_t fbc_y0;		/* blitter, src lly */
	u_int32_t fbc_pad4[2];
	u_int32_t fbc_x1;		/* blitter, src urx */
	u_int32_t fbc_y1;		/* blitter, src ury */
	u_int32_t fbc_pad5[2];
	u_int32_t fbc_x2;		/* blitter, dst llx */
	u_int32_t fbc_y2;		/* blitter, dst lly */
	u_int32_t fbc_pad6[2];
	u_int32_t fbc_x3;		/* blitter, dst urx */
	u_int32_t fbc_y3;		/* blitter, dst ury */
	u_int32_t fbc_pad7[2];
	u_int32_t fbc_offx;		/* x offset for drawing */
	u_int32_t fbc_offy;		/* y offset for drawing */
	u_int32_t fbc_pad8[2];
	u_int32_t fbc_incx;		/* x offset for drawing */
	u_int32_t fbc_incy;		/* y offset for drawing */
	u_int32_t fbc_pad81[2];
	u_int32_t fbc_clipminx;		/* clip rectangle llx */
	u_int32_t fbc_clipminy;		/* clip rectangle lly */
	u_int32_t fbc_pad9[2];
	u_int32_t fbc_clipmaxx;		/* clip rectangle urx */
	u_int32_t fbc_clipmaxy;		/* clip rectangle ury */
	u_int32_t fbc_pad10[2];
	u_int32_t fbc_fg;		/* fg value for rop */
	u_int32_t fbc_bg;
	u_int32_t fbc_alu;		/* operation to be performed */
	u_int32_t fbc_pad12[509];
	u_int32_t fbc_arectx;		/* rectangle drawing, x coord */
	u_int32_t fbc_arecty;		/* rectangle drawing, y coord */
	/* actually much more, but nothing more we need */
	// extra stuff
	u_int32_t fbc_pad13[22];
	u_int32_t fbc_arectx_prev;		/* rectangle drawing, x coord */
	u_int32_t fbc_arecty_prev;		/* rectangle drawing, y coord */
	volatile u_int32_t fbc_r5_cmd;
	u_int32_t fbc_pad14;
	volatile u_int32_t fbc_r5_status[4];
    volatile u_int32_t fbc_next_font;
    volatile u_int32_t fbc_next_x0;
    volatile u_int32_t fbc_next_x1;
    volatile u_int32_t fbc_next_y0;
};

//#include "./rvintrin.h"

void from_reset(void) __attribute__ ((noreturn)); // nothrow, 

static inline void flush_cache(void) {
	asm volatile(".word 0x0000500F\n"); // flush the Dcache so that we get updated data
}

typedef unsigned int unsigned_param_type;

void rectfill(unsigned_param_type xd,
			  unsigned_param_type yd,
			  unsigned_param_type wi,
			  unsigned_param_type re,
			  unsigned_param_type color
			  );
void invert(unsigned_param_type xd,
			unsigned_param_type yd,
			unsigned_param_type wi,
			unsigned_param_type re
			);
void bitblit(unsigned_param_type xs,
			 unsigned_param_type ys,
			 unsigned_param_type wi,
			 unsigned_param_type re,
			 unsigned_param_type xd,
			 unsigned_param_type yd,
			 unsigned char gxop
			 );

asm(".global _start\n"
	"_start:\n"
	// ".word 0x0000500F\n" // flush cache ; should not be needed after reset
	//"addi sp,zero,66\n" // 0x0042
	//"slli sp,sp,16\n" // 0x00420000, BASE_RAM
	//"addi a0,zero,1\n" // 0x0001
	//"slli a0,a0,12\n" // 0x00001000, BASE_RAM_SIZE
	//"add sp,sp,a0\n" // SP at the end of the SRAM
	"nop\n"
	"li sp, 0x00420ffc\n" // SP at the end of the SRAM - normally unused
	//"li a0, 0x00700968\n" // @ of r5_cmd
	//"li a1, 0x00C0FFEE\n"
	//"sw a1, 0(a0)\n"
	"call from_reset\n"
	".size	_start, .-_start\n"
	".align	4\n"
	".globl	_start\n"
	".type	_start, @function\n"
	);

#define imax(a,b) ((a>b)?(a):(b))
#define imin(a,b) ((a<b)?(a):(b))

#define DEBUG
#ifdef DEBUG
#define SHOW_FUN(a) fbc->fbc_r5_status[0] = a
#define SHOW_PC() SHOW_FUN(cmd); do { u_int32_t rd; asm volatile("auipc %[rd], 0" : [rd]"=r"(rd) ) ; fbc->fbc_r5_status[1] = rd; } while (0)
#define SHOW_PC_2VAL(a, b) SHOW_PC(); fbc->fbc_r5_status[2] = a; fbc->fbc_r5_status[3] = b
#else
#define SHOW_FUN(a)
#define SHOW_PC()
#define SHOW_PC_2VAL(a, b)
#endif

/* need some way to have identifiable proc# and multiple struct control_blitter for //ism */
/* First need  to set up essential C stuff like the stack */
/* maybe pass core-id as the first parameter (in a0) to everyone */
/* also need to figure out the non-coherent caches ... */
void from_reset(void) {
	struct cg6_fbc* fbc = (struct cg6_fbc*)BASE_FBC;
	unsigned int cmd = fbc->fbc_r5_cmd;

	// we don't want stale data from the previous run
	// (write are write-through so we should be OK on that aspect)
	// maybe should be at the end to save time ?
	// moved to _start
	// flush_cache();

	switch (cmd & 0xF) {
	case FUN_DRAW: {
		switch (fbc->fbc_alu) {
		case CG6_ALU_FILL:  // ____ff00 console
		case CG6_ALU_COPY:  // ____cccc equivalent to fill if patterns == 1 (... which is the case with GX_PATTERN_ONES)
		case ROP_FILL(GX_ROP_CLEAR,  GX_ROP_SET): // ____ff00 Draw/GXcopy in X11 FIXME: planemask ?
			// //case ROP_FILL(GX_ROP_SET,  GX_ROP_SET): // ____ffff Draw/GXset in X11 FIXME: planemask ?
		case ROP_BLIT(GX_ROP_CLEAR,  GX_ROP_SET): // ____cccc Blit/GXcopy in X11 FIXME: planemask ?
			{
				switch (fbc->fbc_mode) {
				case (GX_BLIT_SRC | GX_MODE_COLOR8): // console: rectfill & clearscreen
				case (GX_BLIT_SRC |	GX_MODE_COLOR8 | GX_DRAW_RENDER | GX_BWRITE0_ENABLE | GX_BWRITE1_DISABLE | GX_BREAD_0 | GX_BDISP_0): // X11 FIXME:planemask?
					rectfill(fbc->fbc_arectx_prev,
							 fbc->fbc_arecty_prev,
							 1 + fbc->fbc_arectx - fbc->fbc_arectx_prev,
							 1 + fbc->fbc_arecty - fbc->fbc_arecty_prev,
							 fbc->fbc_fg);
					break;
				default:
					SHOW_PC_2VAL(fbc->fbc_alu, fbc->fbc_mode);
					break;
				}
			} break;
		case CG6_ALU_FLIP: { // console
			switch (fbc->fbc_mode)
				{
				case (GX_BLIT_SRC | GX_MODE_COLOR8): // invert
					invert(fbc->fbc_arectx_prev,
						   fbc->fbc_arecty_prev,
						   1 + fbc->fbc_arectx - fbc->fbc_arectx_prev,
						   1 + fbc->fbc_arecty - fbc->fbc_arecty_prev);
					break;
				default:
					SHOW_PC_2VAL(fbc->fbc_alu, fbc->fbc_mode);
					break;
				}
		} break;
		default:
			SHOW_PC_2VAL(fbc->fbc_alu, fbc->fbc_mode);
			break;
		}
	} break;
	case FUN_BLIT: {
		switch (fbc->fbc_alu)
			{
			case CG6_ALU_COPY: // console
			case ROP_BLIT(GX_ROP_CLEAR,  GX_ROP_SET): // Blit/GXcopy in X11
			case ROP_BLIT(GX_ROP_SET,  GX_ROP_SET): // Blit/GXset in X11 FIXME: correct or not ?
				{
					switch (fbc->fbc_mode) {
					case (GX_BLIT_SRC | GX_MODE_COLOR8): // console
					case (GX_BLIT_SRC |	GX_MODE_COLOR8 | GX_DRAW_RENDER | GX_BWRITE0_ENABLE | GX_BWRITE1_DISABLE | GX_BREAD_0 | GX_BDISP_0): // X11 FIXME:planemask?
						{
							unsigned_param_type xs = fbc->fbc_x0;
							unsigned_param_type ys = fbc->fbc_y0;
							unsigned_param_type wi = fbc->fbc_x1 - xs + 1;
							unsigned_param_type re = fbc->fbc_y1 - ys + 1;
							unsigned_param_type xd = fbc->fbc_x2;
							unsigned_param_type yd = fbc->fbc_y2;
							unsigned_param_type wi_dup = fbc->fbc_x3 - xd + 1;
							unsigned_param_type re_dup = fbc->fbc_y3 - yd + 1;
#if 0
							int do_blit = 1;
							if (wi_dup != wi)
								do_blit = 0;
							if (re_dup != re)
								do_blit = 0;
					
							if (xs > HRES)
								do_blit = 0;
							if (ys > VRES)
								do_blit = 0;
							if (xd > HRES)
								do_blit = 0;
							if (yd > VRES)
								do_blit = 0;
					
							if (wi > HRES)
								do_blit = 0;
							if (re > VRES)
								do_blit = 0;
					
							if ((xs+wi) > HRES)
								do_blit = 0;
							if ((ys+re) > VRES)
								do_blit = 0;
							if ((xd+wi) > HRES)
								do_blit = 0;
							if ((yd+re) > VRES)
								do_blit = 0;
							if (do_blit)
#endif
								bitblit(xs, ys, wi, re, xd, yd, 0x3); // GXcopy
						}
						break;
					default:
						SHOW_PC_2VAL(fbc->fbc_alu, fbc->fbc_mode);
						break;
					}	  
				} break;
			case ROP_BLIT(GX_ROP_NOOP,  GX_ROP_INVERT): // Blit/GXxor in X11
				{
					switch (fbc->fbc_mode) {
					case (GX_BLIT_SRC |	GX_MODE_COLOR8 | GX_DRAW_RENDER | GX_BWRITE0_ENABLE | GX_BWRITE1_DISABLE | GX_BREAD_0 | GX_BDISP_0): // X11 FIXME:planemask?
						{
							unsigned_param_type xs = fbc->fbc_x0;
							unsigned_param_type ys = fbc->fbc_y0;
							unsigned_param_type wi = fbc->fbc_x1 - xs + 1;
							unsigned_param_type re = fbc->fbc_y1 - ys + 1;
							unsigned_param_type xd = fbc->fbc_x2;
							unsigned_param_type yd = fbc->fbc_y2;
							unsigned_param_type wi_dup = fbc->fbc_x3 - xd + 1;
							unsigned_param_type re_dup = fbc->fbc_y3 - yd + 1;
							bitblit(xs, ys, wi, re, xd, yd, 0x6); // GXor
						}
						break;
					
					default:
						SHOW_PC_2VAL(fbc->fbc_alu, fbc->fbc_mode);
						break;
					}
				} break;
			default:
				SHOW_PC_2VAL(fbc->fbc_alu, fbc->fbc_mode);
				break;
			}
	} break;
	case FUN_FONT:
		{
			switch (fbc->fbc_alu)
				{
				case CG6_ALU_COPY: { // console
					case ROP_BLIT(GX_ROP_CLEAR,  GX_ROP_SET): // Blit/GXcopy in X11
						switch (fbc->fbc_mode) {
						case (GX_BLIT_NOSRC | GX_MODE_COLOR8): // console
						case (GX_BLIT_NOSRC | GX_MODE_COLOR8 | GX_DRAW_RENDER | GX_BWRITE0_ENABLE | GX_BWRITE1_DISABLE | GX_BREAD_0 | GX_BDISP_0): // X11 FIXME:planemask?
							//case (GX_BLIT_SRC | GX_MODE_COLOR8): // what is SRC then?
							{
								// cgsix_putchar_aa
								// Cg6UploadToScreen
								const unsigned int xdsm = fbc->fbc_clipminx;
								const unsigned int xdem = fbc->fbc_clipmaxx;
								do {
									while ((cmd & FUN_FONT_NEXT_RDY) == 0) {
										if ((cmd & FUN_FONT_NEXT_DONE) != 0)
											goto finish;
										cmd = fbc->fbc_r5_cmd;
									}
									const unsigned int xdsr = fbc->fbc_next_x0;
									const unsigned int xds =  imax(xdsr, xdsm);
									const unsigned int xder = fbc->fbc_next_x1;
									const unsigned int xde =  imin(xder, xdem);
									const unsigned int yd =   fbc->fbc_next_y0;
									const unsigned int we =   xde - xdsr + 1;
									const unsigned int xoff = xds - xdsr;
									if ((xde >= xds) && (xoff<we)) {
										unsigned int bits = fbc->fbc_next_font;
										unsigned char *dptr = (((unsigned char *)BASE_FB) + mul_HRES(yd) + xdsr);
										for (unsigned i = xoff ; i < we ; i++) {
											unsigned char data = (bits >> (((we-1)-i) * 8)) & 0xFF;
											//if (((dptr + i) >= ((unsigned char *)BASE_FB)) &&
											//    ((dptr + i) <  ((1048576*2)+(unsigned char *)BASE_FB)))
											dptr[i] = data;
										}
									}
									cmd = (FUN_FONT_NEXT_REQ | FUN_FONT);
									fbc->fbc_r5_cmd = cmd;
								} while (1);
							}
							break;
						default:
							SHOW_PC_2VAL(fbc->fbc_alu, fbc->fbc_mode);
							break;
						}	  
				} break;
				case (GX_PATTERN_ONES | ROP_OSTP(GX_ROP_CLEAR, GX_ROP_SET)): // console, also X11 OpaqueStipple/GXcopy FIXME:planemask?
					{
						switch (fbc->fbc_mode) {
						case (GX_BLIT_NOSRC | GX_MODE_COLOR1):
							{
								const unsigned int xdsm = fbc->fbc_clipminx;
								const unsigned int xdem = fbc->fbc_clipmaxx;
								// cgsix_putchar
								do {
									while ((cmd & FUN_FONT_NEXT_RDY) == 0) {
										if ((cmd & FUN_FONT_NEXT_DONE) != 0)
											goto finish;
										cmd = fbc->fbc_r5_cmd;
									}
									const unsigned int xdsr = fbc->fbc_next_x0;
									const unsigned int xds =  imax(xdsr, xdsm);
									const unsigned int xder = fbc->fbc_next_x1;
									const unsigned int xde =  imin(xder,xdem);
									const unsigned int yd =   fbc->fbc_next_y0;
									const unsigned int we =   xde - xdsr + 1;
									const unsigned int xoff = xds - xdsr;
									const unsigned char fg8 = (unsigned char)(fbc->fbc_fg & 0xFF);
									const unsigned char bg8 = (unsigned char)(fbc->fbc_bg & 0xFF);
									if ((xde >= xds) && (xoff<we)) {
										unsigned int bits = fbc->fbc_next_font << xoff;
										unsigned char *dptr = (((unsigned char *)BASE_FB) + mul_HRES(yd) + xdsr);
										for (unsigned i = xoff ; i < we ; i++) {
											if (bits & 0x80000000) dptr[i] = fg8; else dptr[i] = bg8;
											bits <<= 1;
										}
									}
									cmd = (FUN_FONT_NEXT_REQ | FUN_FONT);
									fbc->fbc_r5_cmd = cmd;
								} while (1);
							}
							break;
						default:
							SHOW_PC_2VAL(fbc->fbc_alu, fbc->fbc_mode);
							break;
						}	  
					} break;
				case (GX_PATTERN_ONES | ROP_STIP(GX_ROP_CLEAR, GX_ROP_SET)): // X11 Stipple/GXcopy (not used in console) FIXME:planemask?
					{
						switch (fbc->fbc_mode)
							{
							case (GX_BLIT_NOSRC | GX_MODE_COLOR1):
								{
									const unsigned int xdsm = fbc->fbc_clipminx;
									const unsigned int xdem = fbc->fbc_clipmaxx;
									// cgsix_putchar
									do {
										while ((cmd & FUN_FONT_NEXT_RDY) == 0) {
											if ((cmd & FUN_FONT_NEXT_DONE) != 0)
												goto finish;
											cmd = fbc->fbc_r5_cmd;
										}
										const unsigned int xdsr = fbc->fbc_next_x0;
										const unsigned int xds =  imax(xdsr, xdsm);
										const unsigned int xder = fbc->fbc_next_x1;
										const unsigned int xde =  imin(xder,xdem);
										const unsigned int yd =   fbc->fbc_next_y0;
										const unsigned int we =   xde - xdsr + 1;
										const unsigned int xoff = xds - xdsr;
										const unsigned char fg8 = (unsigned char)(fbc->fbc_fg & 0xFF);
										//const unsigned char bg8 = (unsigned char)(fbc->fbc_bg & 0xFF);
										if ((xde >= xds) && (xoff<we)) {
											unsigned int bits = fbc->fbc_next_font << xoff;
											unsigned char *dptr = (((unsigned char *)BASE_FB) + mul_HRES(yd) + xdsr);
											for (unsigned i = xoff ; i < we ; i++) {
												if (bits & 0x80000000) dptr[i] = fg8;
												bits <<= 1;
											}
										}
										cmd = (FUN_FONT_NEXT_REQ | FUN_FONT);
										fbc->fbc_r5_cmd = cmd;
									} while (1);
								}
								break;
							default:
								SHOW_PC_2VAL(fbc->fbc_alu, fbc->fbc_mode);
								break;
							}	  
					} break;
				default:
					SHOW_PC_2VAL(fbc->fbc_alu, fbc->fbc_mode);
					break;
				}
		} break;
	default:
		break;
	}

	// make sure we have nothing left in the cache
 finish:
	flush_cache();

	fbc->fbc_r5_cmd = FUN_DONE;

 done:
	/* wait for reset */
	goto done;
}

#define bitblit_proto_int(a, b, suf) \
		void bitblit##a##b##suf(unsigned_param_type xs,					\
								unsigned_param_type ys,					\
								unsigned_param_type wi,					\
								unsigned_param_type re,					\
								unsigned_param_type xd,					\
								unsigned_param_type yd					\
								);
#define bitblit_proto(suf) \
		bitblit_proto_int(_fwd, _fwd, suf)	\
		bitblit_proto_int(_bwd, _fwd, suf)	\
		bitblit_proto_int(_fwd, _bwd, suf)	\
		bitblit_proto_int(_bwd, _bwd, suf)

bitblit_proto(_copy)
bitblit_proto(_xor)

void bitblit(unsigned_param_type xs,
			 unsigned_param_type ys,
			 unsigned_param_type wi,
			 unsigned_param_type re,
			 unsigned_param_type xd,
			 unsigned_param_type yd,
			 unsigned char gxop
			 ) {
	struct cg6_fbc* fbc = (struct cg6_fbc*)BASE_FBC;
	
	if (ys > yd) {
		switch(gxop) {
		case 0x3: // GXcopy
			bitblit_fwd_fwd_copy(xs, ys, wi, re, xd, yd);
			break;
		case 0x6: // GXxor
			bitblit_fwd_fwd_xor(xs, ys, wi, re, xd, yd);
			break;
		}
	} else if (ys < yd) {
		switch(gxop) {
		case 0x3: // GXcopy
			bitblit_bwd_fwd_copy(xs, ys, wi, re, xd, yd);
			break;
		case 0x6: // GXxor
			bitblit_bwd_fwd_xor(xs, ys, wi, re, xd, yd);
			break;
		}
	} else { // ys == yd
		if (xs > xd) {
			switch(gxop) {
			case 0x3: // GXcopy
				bitblit_fwd_fwd_copy(xs, ys, wi, re, xd, yd);
				break;
			case 0x6: // GXxor
				bitblit_fwd_fwd_xor(xs, ys, wi, re, xd, yd);
				break;
			}
		} else if (xs < xd) {
			switch(gxop) {
			case 0x3: // GXcopy
				bitblit_fwd_bwd_copy(xs, ys, wi, re, xd, yd);
				break;
			case 0x6: // GXxor
				bitblit_fwd_bwd_xor(xs, ys, wi, re, xd, yd);
				break;
			}
		} else { // xs == xd
			switch(gxop) {
			case 0x3: // GXcopy
				/* don't bother */
				break;
			case 0x6:  // GXxor
				rectfill(xd, yd, wi, re, 0);
				break;
			}
		}
	}
 }


void rectfill(unsigned_param_type xd,
			  unsigned_param_type yd,
			  unsigned_param_type wi,
			  unsigned_param_type re,
			  unsigned_param_type color
			  ) {
	struct cg6_fbc* fbc = (struct cg6_fbc*)BASE_FBC;
	unsigned int i, j;
	unsigned char *dptr = (((unsigned char *)BASE_FB) + mul_HRES(yd) + xd);
	unsigned char *dptr_line = dptr;
	unsigned char u8color = color & 0xFF;

	for (j = 0 ; j < re ; j++) {
		unsigned char *dptr_elt = dptr_line;
		i = 0;
		if ((xd & 0x3) == 0) {
			unsigned int u32color = (unsigned int)u8color | ((unsigned int)u8color)<<8 | ((unsigned int)u8color)<<16 | ((unsigned int)u8color)<<24;
			for ( ; i < (wi&(~3)) ; i+=4) {
				*(unsigned int*)dptr_elt = u32color;
				dptr_elt +=4;
			}
		}
		for ( ; i < wi ; i++) {
			*dptr_elt = u8color;
			dptr_elt ++;
		}
		dptr_line += HRES;
	}
}

void invert(unsigned_param_type xd,
			unsigned_param_type yd,
			unsigned_param_type wi,
			unsigned_param_type re
			) {
	struct cg6_fbc* fbc = (struct cg6_fbc*)BASE_FBC;
	unsigned int i, j;
	unsigned char *dptr = (((unsigned char *)BASE_FB) + mul_HRES(yd) + xd);
	unsigned char *dptr_line = dptr;
	
	for (j = 0 ; j < re ; j++) {
		unsigned char *dptr_elt = dptr_line;
		i = 0;
		if ((xd & 0x3) == 0) {
			for ( ; i < (wi&(~3)) ; i+=4) {
				*(unsigned int*)dptr_elt = ~(*(unsigned int*)dptr_elt);
				dptr_elt +=4;
			}
		}
		for ( ; i < wi ; i++) {
			*dptr_elt = ~(*dptr_elt);
			dptr_elt ++;
		}
		dptr_line += HRES;
	}
}


void bitblit_fwd_fwd_copy(unsigned_param_type xs,
						  unsigned_param_type ys,
						  unsigned_param_type wi,
						  unsigned_param_type re,
						  unsigned_param_type xd,
						  unsigned_param_type yd
						  ) {
	unsigned int i, j;
	unsigned char *sptr = (((unsigned char *)BASE_FB) + mul_HRES(ys) + xs);
	unsigned char *dptr = (((unsigned char *)BASE_FB) + mul_HRES(yd) + xd);
	unsigned char *sptr_line = sptr;
	unsigned char *dptr_line = dptr;

	// flush_cache(); // handled in boot()
  
	for (j = 0 ; j < re ; j++) {
		unsigned char *sptr_elt = sptr_line;
		unsigned char *dptr_elt = dptr_line;
		i = 0;
		/* this case is the console case */
		if (((xs & 0xf) == 0) && ((xd & 0xf) == 0)) {
			for ( ; i < (wi&(~0xf)) ; i+= 16) {
				((unsigned int*)dptr_elt)[0] = ((unsigned int*)sptr_elt)[0];
				((unsigned int*)dptr_elt)[1] = ((unsigned int*)sptr_elt)[1];
				((unsigned int*)dptr_elt)[2] = ((unsigned int*)sptr_elt)[2];
				((unsigned int*)dptr_elt)[3] = ((unsigned int*)sptr_elt)[3];
				dptr_elt += 16;
				sptr_elt += 16;
			}
		}
		if (((xs & 0x3) == 0) && ((xd & 0x3) == 0)) {
			for ( ; i < (wi&(~3)) ; i+= 4) {
				((unsigned int*)dptr_elt)[0] = ((unsigned int*)sptr_elt)[0];
				dptr_elt += 4;
				sptr_elt += 4;
			}
		}
		for ( ; i < wi ; i++) {
			*dptr_elt = *sptr_elt;
			dptr_elt ++;
			sptr_elt ++;
		}
		sptr_line += HRES;
		dptr_line += HRES;
	}
}

void bitblit_fwd_bwd_copy(unsigned_param_type xs,
						  unsigned_param_type ys,
						  unsigned_param_type wi,
						  unsigned_param_type re,
						  unsigned_param_type xd,
						  unsigned_param_type yd
						  ) {
	unsigned int i, j;
	unsigned char *sptr = (((unsigned char *)BASE_FB) + mul_HRES(ys) + xs);
	unsigned char *dptr = (((unsigned char *)BASE_FB) + mul_HRES(yd) + xd);
	unsigned char *sptr_line = sptr + wi - 1;
	unsigned char *dptr_line = dptr + wi - 1;

	// flush_cache(); // handled in boot()
  
	for (j = 0 ; j < re ; j++) {
		unsigned char *sptr_elt = sptr_line;
		unsigned char *dptr_elt = dptr_line;
		for (i = 0 ; i < wi ; i++) {
			*dptr_elt = *sptr_elt;
			dptr_elt --;
			sptr_elt --;
		}
		sptr_line += HRES;
		dptr_line += HRES;
	}
}
void bitblit_bwd_fwd_copy(unsigned_param_type xs,
						  unsigned_param_type ys,
						  unsigned_param_type wi,
						  unsigned_param_type re,
						  unsigned_param_type xd,
						  unsigned_param_type yd
						  ) {
	unsigned int i, j;
	unsigned char *sptr = (((unsigned char *)BASE_FB) + mul_HRES(ys) + xs);
	unsigned char *dptr = (((unsigned char *)BASE_FB) + mul_HRES(yd) + xd);
	unsigned char *sptr_line = sptr + mul_HRES((re-1));
	unsigned char *dptr_line = dptr + mul_HRES((re-1));

	// flush_cache(); // handled in boot()
  
	for (j = 0 ; j < re ; j++) {
		unsigned char *sptr_elt = sptr_line;
		unsigned char *dptr_elt = dptr_line;
		i = 0;
		if (((xs & 0xf) == 0) && ((xd & 0xf) == 0)) {
			for ( ; i < (wi&(~0xf)) ; i+= 16) {
				((unsigned int*)dptr_elt)[0] = ((unsigned int*)sptr_elt)[0];
				((unsigned int*)dptr_elt)[1] = ((unsigned int*)sptr_elt)[1];
				((unsigned int*)dptr_elt)[2] = ((unsigned int*)sptr_elt)[2];
				((unsigned int*)dptr_elt)[3] = ((unsigned int*)sptr_elt)[3];
				dptr_elt += 16;
				sptr_elt += 16;
			}
		}
		if (((xs & 0x3) == 0) && ((xd & 0x3) == 0)) {
			for ( ; i < (wi&(~3)) ; i+= 4) {
				((unsigned int*)dptr_elt)[0] = ((unsigned int*)sptr_elt)[0];
				dptr_elt += 4;
				sptr_elt += 4;
			}
		}
		for ( ; i < wi ; i++) {
			*dptr_elt = *sptr_elt;
			dptr_elt ++;
			sptr_elt ++;
		}
		sptr_line -= HRES;
		dptr_line -= HRES;
	}
}



void bitblit_fwd_fwd_xor(unsigned_param_type xs,
						  unsigned_param_type ys,
						  unsigned_param_type wi,
						  unsigned_param_type re,
						  unsigned_param_type xd,
						  unsigned_param_type yd
						  ) {
	unsigned int i, j;
	unsigned char *sptr = (((unsigned char *)BASE_FB) + mul_HRES(ys) + xs);
	unsigned char *dptr = (((unsigned char *)BASE_FB) + mul_HRES(yd) + xd);
	unsigned char *sptr_line = sptr;
	unsigned char *dptr_line = dptr;

	// flush_cache(); // handled in boot()
  
	for (j = 0 ; j < re ; j++) {
		unsigned char *sptr_elt = sptr_line;
		unsigned char *dptr_elt = dptr_line;
		i = 0;
		/* this case is the console case */
		if (((xs & 0xf) == 0) && ((xd & 0xf) == 0)) {
			for ( ; i < (wi&(~0xf)) ; i+= 16) {
				((unsigned int*)dptr_elt)[0] ^= ((unsigned int*)sptr_elt)[0];
				((unsigned int*)dptr_elt)[1] ^= ((unsigned int*)sptr_elt)[1];
				((unsigned int*)dptr_elt)[2] ^= ((unsigned int*)sptr_elt)[2];
				((unsigned int*)dptr_elt)[3] ^= ((unsigned int*)sptr_elt)[3];
				dptr_elt += 16;
				sptr_elt += 16;
			}
		}
		if (((xs & 0x3) == 0) && ((xd & 0x3) == 0)) {
			for ( ; i < (wi&(~3)) ; i+= 4) {
				((unsigned int*)dptr_elt)[0] ^= ((unsigned int*)sptr_elt)[0];
				dptr_elt += 4;
				sptr_elt += 4;
			}
		}
		for ( ; i < wi ; i++) {
			*dptr_elt ^= *sptr_elt;
			dptr_elt ++;
			sptr_elt ++;
		}
		sptr_line += HRES;
		dptr_line += HRES;
	}
}

void bitblit_fwd_bwd_xor(unsigned_param_type xs,
						  unsigned_param_type ys,
						  unsigned_param_type wi,
						  unsigned_param_type re,
						  unsigned_param_type xd,
						  unsigned_param_type yd
						  ) {
	unsigned int i, j;
	unsigned char *sptr = (((unsigned char *)BASE_FB) + mul_HRES(ys) + xs);
	unsigned char *dptr = (((unsigned char *)BASE_FB) + mul_HRES(yd) + xd);
	unsigned char *sptr_line = sptr + wi - 1;
	unsigned char *dptr_line = dptr + wi - 1;

	// flush_cache(); // handled in boot()
  
	for (j = 0 ; j < re ; j++) {
		unsigned char *sptr_elt = sptr_line;
		unsigned char *dptr_elt = dptr_line;
		for (i = 0 ; i < wi ; i++) {
			*dptr_elt ^= *sptr_elt;
			dptr_elt --;
			sptr_elt --;
		}
		sptr_line += HRES;
		dptr_line += HRES;
	}
}
void bitblit_bwd_fwd_xor(unsigned_param_type xs,
						  unsigned_param_type ys,
						  unsigned_param_type wi,
						  unsigned_param_type re,
						  unsigned_param_type xd,
						  unsigned_param_type yd
						  ) {
	unsigned int i, j;
	unsigned char *sptr = (((unsigned char *)BASE_FB) + mul_HRES(ys) + xs);
	unsigned char *dptr = (((unsigned char *)BASE_FB) + mul_HRES(yd) + xd);
	unsigned char *sptr_line = sptr + mul_HRES((re-1));
	unsigned char *dptr_line = dptr + mul_HRES((re-1));

	// flush_cache(); // handled in boot()
  
	for (j = 0 ; j < re ; j++) {
		unsigned char *sptr_elt = sptr_line;
		unsigned char *dptr_elt = dptr_line;
		i = 0;
		if (((xs & 0xf) == 0) && ((xd & 0xf) == 0)) {
			for ( ; i < (wi&(~0xf)) ; i+= 16) {
				((unsigned int*)dptr_elt)[0] ^= ((unsigned int*)sptr_elt)[0];
				((unsigned int*)dptr_elt)[1] ^= ((unsigned int*)sptr_elt)[1];
				((unsigned int*)dptr_elt)[2] ^= ((unsigned int*)sptr_elt)[2];
				((unsigned int*)dptr_elt)[3] ^= ((unsigned int*)sptr_elt)[3];
				dptr_elt += 16;
				sptr_elt += 16;
			}
		}
		if (((xs & 0x3) == 0) && ((xd & 0x3) == 0)) {
			for ( ; i < (wi&(~3)) ; i+= 4) {
				((unsigned int*)dptr_elt)[0] ^= ((unsigned int*)sptr_elt)[0];
				dptr_elt += 4;
				sptr_elt += 4;
			}
		}
		for ( ; i < wi ; i++) {
			*dptr_elt ^= *sptr_elt;
			dptr_elt ++;
			sptr_elt ++;
		}
		sptr_line -= HRES;
		dptr_line -= HRES;
	}
}

#if 0
		else if ((xd & 0xf) == 0) {
			unsigned int fsr_cst = xs & 0x3;
			unsigned char* sptr_elt_al = sptr_elt - fsr_cst;
			unsigned int src0 = ((unsigned int*)sptr_elt_al)[0];
			for ( ; i < (wi&(~0xf)) ; i+= 16) {
				unsigned int src1, val;

				src1 = ((unsigned int*)sptr_elt_al)[1];
				val = _rv32_fsr(src0, src1, fsr_cst);
				((unsigned int*)dptr_elt)[0] = val;
				src0 = src1;

				src1 = ((unsigned int*)sptr_elt_al)[2];
				val = _rv32_fsr(src0, src1, fsr_cst);
				((unsigned int*)dptr_elt)[1] = val;
				src0 = src1;

				src1 = ((unsigned int*)sptr_elt_al)[3];
				val = _rv32_fsr(src0, src1, fsr_cst);
				((unsigned int*)dptr_elt)[2] = val;
				src0 = src1;

				src1 = ((unsigned int*)sptr_elt_al)[4];
				val = _rv32_fsr(src0, src1, fsr_cst);
				((unsigned int*)dptr_elt)[3] = val;
				src0 = src1;
	
				dptr_elt += 16;
				sptr_elt_al += 16;
			}
      
		}
#endif

#if 0
void bitblit_bwd_bwd_copy(unsigned_param_type xs,
						  unsigned_param_type ys,
						  unsigned_param_type wi,
						  unsigned_param_type re,
						  unsigned_param_type xd,
						  unsigned_param_type yd
						  ) {
	unsigned int i, j;
	unsigned char *sptr = (((unsigned char *)BASE_FB) + mul_HRES(ys) + xs);
	unsigned char *dptr = (((unsigned char *)BASE_FB) + mul_HRES(yd) + xd);
	unsigned char *sptr_line = sptr + mul_HRES((re-1));
	unsigned char *dptr_line = dptr + mul_HRES((re-1));

	// flush_cache(); // handled in boot()
  
	for (j = 0 ; j < re ; j++) {
		unsigned char *sptr_elt = sptr_line + wi - 1;
		unsigned char *dptr_elt = dptr_line + wi - 1;
		for (i = 0 ; i < wi ; i++) {
			*dptr_elt = *sptr_elt;
			dptr_elt --;
			sptr_elt --;
		}
		sptr_line -= HRES;
		dptr_line -= HRES;
	}
}
#endif

