#!/bin/bash -x

HRES=${1:-1280}
VRES=${2:-1024}
BASE_FB=${3:-0x8FE00000}

GCCDIR=~/LITEX/riscv64-unknown-elf-gcc-10.1.0-2020.08.2-x86_64-linux-ubuntu14
GCCPFX=riscv64-unknown-elf-
GCCLINK=${GCCDIR}/bin/${GCCPFX}gcc

#GCCDIR=/opt/rv32bk
#GCCPFX=riscv32-buildroot-linux-gnu-

GCCDIR=~dolbeau2/LITEX/buildroot-rv32/output/host
GCCPFX=riscv32-buildroot-linux-gnu-

GCC=${GCCDIR}/bin/${GCCPFX}gcc
OBJCOPY=${GCCDIR}/bin/${GCCPFX}objcopy

OPT=-Os #-fno-inline
ARCH=rv32i_zba_zbb_zbt

PARAM="-DHRES=${HRES} -DVRES=${VRES} -DBASE_FB=${BASE_FB}"

if test "x$1" != "xASM"; then
	$GCC $OPT -S -o blit_cg6.s $PARAM -march=$ARCH -mabi=ilp32 -mstrict-align -fno-builtin-memset -nostdlib -ffreestanding -nostartfiles blit_cg6.c
fi
$GCC     $OPT -c -o blit_cg6.o $PARAM -march=$ARCH -mabi=ilp32 -mstrict-align -fno-builtin-memset -nostdlib -ffreestanding -nostartfiles blit_cg6.s &&
$GCCLINK $OPT    -o blit_cg6   $PARAM -march=$ARCH -mabi=ilp32 -T blit_cg6.lds  -nostartfiles blit_cg6.o &&
$OBJCOPY  -O binary -j .text -j .rodata blit_cg6 blit_cg6.raw
