Shell Scripts and configuration
===================
- This collection includes some of my useful bash scripts and configuration files.

----------------------------------------------------------------------------------------
Scripts
====
- Below is a list of scripts along with a brief description:

  | Script Name       | Description                                                                           |
  |:------------------|:--------------------------------------------------------------------------------------|
  | [kvm_host_configure.sh](./kvm_host_configure.sh)           | Run this script on a KVM Host machine to configure CPU/Memory for a Guest VM and start it |
  | [perf_flamegraph_wrapper.sh](./perf_flamegraph_wrapper.sh) | Run perf record with user specified options, use [FlameGraph](https://github.com/brendangregg/FlameGraph) for visualization and copy the output to a network share         |
  | [cnt_interrupts_per_core.sh](./cnt_interrupts_per_core.sh) | Count total number of interrupts across all cores |
  | [watch_errors.sh](./watch_errors.sh)                       | Live trouble-shooting helper script - run a sequence of commands, wait for user input between each command |
  | [misc_tasks.sh](./misc_tasks.sh)                           | 1) Assert if given key is present in the file. <br> 2) Block and Kill a running process and cleanup error logs <br> 3) Block and monitor a log file for a particular line to get logged (waiting for init) <br>  4) Set desired runtime properties -- pinning cores, change ARP and other Linux network timeouts, grep Error log for any warnings/errors <br> 5) SCP a file from one machine to another with prompting for password |
  
----------------------------------------------------------------------------------------
