#!/bin/bash

egrep 'SBUS_3V3|JCD|JAB' sbus-to-ztex.net  | grep -A1 SBUS_3V3 | grep -v '^--' | tr '\n' ' ' | sed -e 's/(net/\n(net/g' | sed -e 's/.*name \(SBUS[^)]*\).*ref \(J..\).*pin \([0-9]*\).*/\2 \3 \1/' | sort -k 1,1 -k 2,2n
