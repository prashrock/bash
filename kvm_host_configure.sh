#!/bin/bash
#Run this script on a KVM Host machine to start and configure a Guest VM
#(configure Guest/Host cores and Guest Memory mapping)
set -e

GUESTNAME="BLD_VM"
GUESTIP="192.168.122.67"
HOST_CORES=$(grep -c ^processor /proc/cpuinfo)
GUEST_CORES=$(virsh vcpupin BLD_VM | awk '{print $2}' | sed 's/[^0-9]*//g')
HOST_FIRST_UNUSED_CORE=0
#Use a for-loop over all cores in Host to find out core not bound to Guest
for i in $(seq 0 ${HOST_CORES}); do
    if [[ ! ${GUEST_CORES} =~ "${i}" ]]; then
	HOST_FIRST_UNUSED_CORE=$i
	break
    fi ;
done

#Step 1 - Remove all 8x10G interfaces from Host control.
echo "Hijacking 8x10G interfaces from Host."
virsh nodedev-dettach pci_0000_04_00_0
virsh nodedev-dettach pci_0000_04_00_1

#Step 2 - Mount 20xhugepages (let XML control which to map)
echo "Mounting Hugepages."
kvm_gid=$(getent group kvm | awk -F':' '{ print $3 }')
mount -t hugetlbfs -o pagesize=1G,size=20G,rw,relatime,mode=775,gid=$kvm_gid none /run/hugepages/kvm
#mount -t hugetlbfs -o pagesize=1G,size=20G,rw,relatime,mode=775,gid=$kvm_gid libvirtd /run/hugepages/kvm

#Step 3 - Restart Libvirt after mounting hugepages
echo "Restarting Libvirt..."
/etc/init.d/libvirt-bin restart

#Step 4 - Start Build VM
echo "Starting $GUESTNAME..."
virsh start $GUESTNAME

#Step 5 - Make sure Build VM started up fine
echo "Waiting for the VM ($GUESTNAME) to bootup.."
PING="/bin/ping -q -c 1"
set +e
while [ true ]
do
    ${PING} ${GUESTIP} 1>/dev/null
    if [ $? = 0 ]; then
	echo "Use 'ssh root@${GUESTIP}' to connect to Guest"
	break
    else
	printf "."
    fi
    sleep 1
done
set -e


#Step 6 - Complete Host specific performance configurations
#a) Disable Host NUMA Balancing
#https://access.redhat.com/documentation/en-US/Red_Hat_Enterprise_Linux/7/html/Virtualization_Tuning_and_Optimization_Guide/sect-Virtualization_Tuning_Optimization_Guide-NUMA-Auto_NUMA_Balancing.html
echo "Disable NUMA Balancing"
echo 0 > /proc/sys/kernel/numa_balancing

#b) Set CPU Governor mode from powersave(default) to Performance
#http://epickrram.blogspot.co.uk/2015/09/reducing-system-jitter.html
echo "Set all ${HOST_CORES} CPU's Governor mode to Performance"
for i in `ls /sys/devices/system/cpu/ | grep cpu | grep -v idle | grep -v cpufreq`; do echo performance > /sys/devices/system/cpu/$i/cpufreq/scaling_governor ;done

#c) Set IRQ Affinity of all possible interrupts to a core not given to Guest
echo "Set all IRQ affinity to host-core ${HOST_FIRST_UNUSED_CORE}"
set +e
for i in `ls /proc/irq/ | grep -v default`; do echo ${HOST_FIRST_UNUSED_CORE} > /proc/irq/$i/smp_affinity_list ; done
set -e

#d) Set RCU Thread Affinity to unused core
echo "Set RCU Thread affinity to host-core ${HOST_FIRST_UNUSED_CORE}"
for i in `ps -aux | grep [r]cu | awk '{print $2}'`; do taskset -cp ${HOST_FIRST_UNUSED_CORE} $i ; done

echo "All done."

#Note: Below are some sample changes in the Guest XML file:
#cat /etc/libvirt/qemu/ZXTM_BLD_VM.xml
# <memoryBacking>
#    <hugepages/>
#    <nosharepages/>
# </memoryBacking>
# <vcpu placement='static'>3</vcpu>
# <cputune>
#    <vcpupin vcpu='0' cpuset='1'/>
#    <vcpupin vcpu='1' cpuset='2'/>
#    <vcpupin vcpu='2' cpuset='3'/>
#  </cputune>
#  <numatune>
#    <memory mode='strict' nodeset='0'/>
#  </numatune>
#  <cpu mode='host-model'>
#    <model fallback='allow'/>
#    <topology sockets='1' cores='9' threads='1'/>
#  </cpu>



