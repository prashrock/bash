#! /bin/bash
#Calculate #Cores in a Linux machine and set IRQ affinity for all possible interrupts to the last core
#Calculate # Sockets
NUM_SOCKETS=$((`cat /proc/cpuinfo | grep "physical id" | sort | uniq | wc -l`))

#Calculate # Cores
NUM_CORES_PER_SOCKET=$((`cat /proc/cpuinfo | egrep "core id|physical id" | tr -d "\n" | sed s/physical/\\nphysical/g | grep -v ^$ | sort | uniq | wc -l`))

#Calculate total # Cores
NUM_CORES=$((`cat /proc/cpuinfo | grep processor | tail -1 | awk '{print $3}'`+1))
LAST_CORE_MASK=$((1<<(NUM_CORES-1)))

echo NUM_SOCKETS:$NUM_SOCKETS NUM_CORES_PER_SOCKET:$NUM_CORES_PER_SOCKET
echo NUM_CORES:$NUM_CORES     LAST_CORE_MASK:$LAST_CORE_MASK

#Generate List of interrupts (Except Named interrupts)
INTLIST=($(cat /proc/interrupts  | awk  '{ print $1}' | awk -F ":" '{print $1}' | sed '/[A-Za-z ]/d'))

#Remove 1st interrupt (timer interrupt) (IRQ0 cannot be moved to a different core)
INTLIST=("${INTLIST[@]:1}")

#Now set affinity for all interrupts in INTLIST
for i in "${!INTLIST[@]}"
do
    #echo "cat /proc/irq/${INTLIST[$i]}/smp_affinity";
    echo $LAST_CORE_MASK > /proc/irq/${INTLIST[$i]}/smp_affinity;
done

echo IRQ Affinity set successfully for ${#INTLIST[@]} IRQs.
