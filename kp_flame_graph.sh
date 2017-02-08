#!/bin/bash
#Run perf_record with user specified options, use
#FlameGraph to create output visualization and
#copy this output to a network share(CIFS) for easy access.

set -e

SLEEP_TIME=10
FLAMEGRAPH_DIR="FlameGraph"
CIFS_USER="pkannan"
CIFS_LOCATION="//Server/$CIFS_USER"
CIFS_MOUNT_DIR="/mnt/${CIFS_USER}_cifs"
PERF_OPTIONS=${*:1}                               #Treat all arguments as 1 string
FLAMEGRAPH_SVG="perf_vtm${PERF_OPTIONS// /_}.svg" #Append Perf_options to SVGname

#Make sure user gives atleast one argument to record
if [ $# -lt 1 ]; then
    echo "Error: need an option to perf-record"
    echo "Usage: $0 [--cpu X | --pid Y | other record events]"
    exit 1
fi

#Make sure FlameGraph is available
if [ ! -d $FLAMEGRAPH_DIR ]; then
  echo "Error: $FLAMEGRAPH_DIR not found. Need to install FlameGraph:"
  echo "git clone https://github.com/brendangregg/FlameGraph"
  exit 1
fi

#Let's copy the FlameGraph to a CIFS Mount for easy access
#apt-get install cifs-utils
if [ ! -d $CIFS_MOUNT_DIR ]; then
    mkdir $CIFS_MOUNT_DIR
fi
CIFS_MOUNT_GREP="grep $CIFS_MOUNT_DIR /proc/mounts"
set +e                             #Ignore errors
${CIFS_MOUNT_GREP} 1>/dev/null
if [[ $?  -ne 0 ]]; then
    echo  "Mounting CIFS to $CIFS_MOUNT_DIR"
    mount -t cifs -o domain=brocade,user=$CIFS_USER $CIFS_LOCATION $CIFS_MOUNT_DIR
    mkdir $CIFS_MOUNT_DIR/$FLAMEGRAPH_DIR
fi
set -e


#------------ All sanity done, now lets run perf -----------------------

#Run Perf record -F 99
echo  "Running perf record with '$PERF_OPTIONS' arguments for $SLEEP_TIME secs"
perf record -g $PERF_OPTIONS -- sleep $SLEEP_TIME

#Run Perf script and stack-collapse script
echo  "Running perf script and stackcollapse script"
perf script | $FLAMEGRAPH_DIR/stackcollapse-perf.pl > out.perf-folded

#Generate the flame graph
echo  "Generating FlameGraph SVG - $FLAMEGRAPH_SVG"
$FLAMEGRAPH_DIR/flamegraph.pl out.perf-folded > $FLAMEGRAPH_SVG
#Note, if there is sufficient idle time, use below to elide cpu_idle and focus on
#real threads that are consuming CPU resources
#grep -v cpu_idle out.perf-folded | $FLAMEGRAPH_DIR//flamegraph.pl > nonidle.svg


#Lastly, copy FlameGraph to CIFS mount
echo "Copy FlameGraph to Network mount"
mv $FLAMEGRAPH_SVG $CIFS_MOUNT_DIR/$FLAMEGRAPH_DIR/$FLAMEGRAPH_SVG

echo "All Done"
