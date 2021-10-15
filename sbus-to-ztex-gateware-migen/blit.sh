#!/bin/bash -x

GCCDIR=~/LITEX/riscv64-unknown-elf-gcc-10.1.0-2020.08.2-x86_64-linux-ubuntu14
GCCPFX=riscv64-unknown-elf-

#GCCDIR=/opt/rv32bk
#GCCPFX=riscv32-buildroot-linux-gnu-

#GCCDIR=~dolbeau/LITEX/buildroot-32SF/output/host
#GCCPFX=riscv32-buildroot-linux-gnu-

GCC=${GCCDIR}/bin/${GCCPFX}gcc
OBJCOPY=${GCCDIR}/bin/${GCCPFX}objcopy

if test "x$1" == "xASM"; then
	$GCC -Os -o blit -march=rv32ib -mabi=ilp32 -T blit.lds  -nostartfiles blit.s &&
	$OBJCOPY  -O binary -j .text blit blit.raw
else
$GCC -Os -S blit.c -march=rv32ib -mabi=ilp32 -mstrict-align -fno-builtin-memset -nostdlib -ffreestanding -nostartfiles &&
	$GCC -Os -o blit -march=rv32ib -mabi=ilp32 -T blit.lds  -nostartfiles blit.s &&
	$OBJCOPY  -O binary -j .text blit blit.raw
fi
