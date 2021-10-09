#!/bin/bash

PFX=prom_migen

rm -f ${PFX}.fc

# (export BP=~/SPARC/SBusFPGA/sbus-to-ztex/openfirmware ; toke ${PFX}.forth )

( export BP=`pwd`/openfirmware ; openfirmware/cpu/x86/Linux/forth openfirmware/cpu/x86/build/builder.dic prom_migen.bth ) 2>&1 | tee forth.log

rm -f /tmp/${PFX}.hexa

od --endian=big -w4 -x ${PFX}.fc  | awk '{ print $2,$3"," }' >| /tmp/${PFX}.hexa

rm -f /tmp/${PFX}.txt_hexa

cat /tmp/${PFX}.hexa | sed -e 's/^\([a-f0-9][a-f0-9][a-f0-9][a-f0-9]\) \([a-f0-9][a-f0-9][a-f0-9][a-f0-9]\),/0x\1\2,/g' -e 's/^\([a-f0-9][a-f0-9]*\) ,/0x\10000,/' -e 's/^ ,/0x00000000,/' -e 's/\(0x[0-9a-fA-F]*\),/if (idx == 0):\n\treturn \1;/' > /tmp/${PFX}.txt_hexa

#echo "rom = ["
#cat /tmp/${PFX}.txt_hexa
#echo "]"
