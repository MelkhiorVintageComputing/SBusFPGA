#!/bin/bash

GERBER_FILES="sbus-to-ztex-B_Cu.gbr sbus-to-ztex-B_Mask.gbr sbus-to-ztex-B_Paste.gbr sbus-to-ztex-B_SilkS.gbr sbus-to-ztex-Edge_Cuts.gbr sbus-to-ztex-F_Cu.gbr sbus-to-ztex-F_Mask.gbr sbus-to-ztex-F_Paste.gbr sbus-to-ztex-F_SilkS.gbr sbus-to-ztex-In1_Cu.gbr sbus-to-ztex-In2_Cu.gbr"

POS_FILES="sbus-to-ztex-bottom.pos sbus-to-ztex-top.pos"

DRL_FILES="sbus-to-ztex-NPTH.drl sbus-to-ztex-PTH.drl sbus-to-ztex-PTH-drl_map.ps sbus-to-ztex-NPTH-drl_map.ps"

FILES="${GERBER_FILES} ${POS_FILES} ${DRL_FILES} top.pdf sbus-to-ztex.d356 sbus-to-ztex.csv"

echo $FILES

KICAD_PCB=sbus-to-ztex.kicad_pcb

ABORT=no
for F in $FILES; do 
    if test \! -f $F || test $KICAD_PCB -nt $F; then
	echo "Regenerate file $F"
	ABORT=yes
    fi
done

if test $ABORT == "yes"; then
    exit -1;
fi

zip sbus-to-ztex.zip $FILES top.jpg bottom.jpg
