#!/bin/bash

GERBER_FILES="VGA222-PMOD-B.Cu.gbr VGA222-PMOD-B.Mask.gbr VGA222-PMOD-B.Paste.gbr VGA222-PMOD-B.SilkS.gbr VGA222-PMOD-Edge.Cuts.gbr VGA222-PMOD-F.Cu.gbr VGA222-PMOD-F.Mask.gbr VGA222-PMOD-F.Paste.gbr VGA222-PMOD-F.SilkS.gbr"

POS_FILES="VGA222-PMOD-top.pos"

DRL_FILES="VGA222-PMOD-NPTH.drl VGA222-PMOD-PTH.drl VGA222-PMOD-PTH-drl_map.ps VGA222-PMOD-NPTH-drl_map.ps"

FILES="${GERBER_FILES} ${POS_FILES} ${DRL_FILES} top.pdf VGA222-PMOD.d356 VGA222-PMOD.csv"

echo $FILES

KICAD_PCB=VGA222-PMOD.kicad_pcb

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

zip VGA222-PMOD.zip $FILES
