#!/bin/bash
set -e

#
# 1) Assert if given key is present in the file.
#
assert_key_in_file() {
    if grep -Fq "$1" $2 
    then
	return 0
    else
	echo "Error: Key $1 missing in $2"
	exit 1
    fi
}
#Use above fun
assert_key_in_file "key"               "$HOME/config.cfg"

# 2) Block and Kill previous instance, remove error log
echo "Stop previous instance and remove error log..."
$STOP_BINARY
rm -rf $HOME/log/errors
BINPGREP="pgrep -f binary_name"
set +e
while [ true ]
do
    ${BINPGREP} 1>/dev/null
    if [ $? = 0 ]; then
	printf "."
    else
        break
    fi
    sleep 0.5
done
set -e

# 3) Wait for BINARY to fully bootup. Use nproc to calculate last core
#and use timeout to block till BINARY is up and logs a particular line
num_cores=$(nproc --all)
last_core=$((num_cores - 1))
timeout 60 grep -q 'Line of interest' <(tail -f $HOME/log/errors)
sleep 1

#4) Set desired runtime properties
#a) Pinning cores
echo "Info: Pinning to last core"
ps -aux | grep [b]inary | awk '{print $2}' | xargs -n 1 taskset -cp $last_core

#b) Increase ARP and networking timeouts
echo "Info: Increasing ARP and other Linux networking timeouts/intervals"
echo 300000 > /proc/sys/net/ipv4/neigh/default/base_reachable_time_ms
cat /proc/sys/net/ipv4/neigh/default/base_reachable_time_ms
echo 300 > /proc/sys/net/ipv4/neigh/default/gc_interval
cat /proc/sys/net/ipv4/neigh/default/gc_interval
echo 600 > /proc/sys/net/ipv4/neigh/default/gc_stale_time
cat /proc/sys/net/ipv4/neigh/default/gc_stale_time
echo 600 > /proc/sys/net/ipv4/route/gc_interval 
cat /proc/sys/net/ipv4/route/gc_interval
echo 3000 > /proc/sys/net/ipv4/route/gc_timeout
cat /proc/sys/net/ipv4/route/gc_timeout

#c) Dump Error log file
echo "Info: Dumping log/errors:"
grep --text -in 'error\|fail\|warn' $HOME/log/errors

#5) SCP a file between two machines without using password
SCP_PASS="demo"
#apt-get install sshpass
sshpass -p $SCP_PASS scp BINARY root@${IPADDR}:/root/BINARY
