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
	$GCC $OPT -S -o blit.s $PARAM -march=$ARCH -mabi=ilp32 -mstrict-align -fno-builtin-memset -nostdlib -ffreestanding -nostartfiles blit.c
fi
$GCC     $OPT -c -o blit.o $PARAM -march=$ARCH -mabi=ilp32 -mstrict-align -fno-builtin-memset -nostdlib -ffreestanding -nostartfiles blit.s &&
$GCCLINK $OPT    -o blit   $PARAM -march=$ARCH -mabi=ilp32 -T blit.lds  -nostartfiles blit.o &&
$OBJCOPY  -O binary -j .text -j .rodata blit blit.raw
