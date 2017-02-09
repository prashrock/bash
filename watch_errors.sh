#!/bin/bash
#Live trouble-shooting helper script - run a sequence of commands,
#wait for user input between each command


#1) Dump errors in Log
echo "Dumping errors in log/errors and log/startup"
dmesg | grep -in 'error\|fail\|warn'
read  -n 1 -p "Logs Done. Press any key to continue to Command..."

#2) Watch some-command output
echo "Dumping command stats"
watch -d -n 0.5 bash -c 'command'
read  -n 1 -p "Command Done. Press any key to continue to Exit..."

echo "KP_INFO: All done."
