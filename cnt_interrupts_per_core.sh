#!/bin/bash
#prints sum of all interrupts in cores given as input
#example: cnt_interrupts_per_core.sh 0 1 #returns total num interrupts in 1st 2 cores
#Note: this script needs some cleanup, can print per-core total followed by global total

if [ $# -le 0 ]; then
    echo "Usage: `basename $0` <CPU_Core#> [CPU_Core#] ..." >&2
    echo "Prints total interrupts for all CPUs provided as command line arguments" >&2
    exit 1
fi

p=""
while [ $# -gt 0 ]; do
    p="$p+\$$[2+$1]"
    shift
done
awk "//{s+=$p}END{print s}" /proc/interrupts
