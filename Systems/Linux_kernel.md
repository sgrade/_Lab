# Linux Kernel

## Overview

[Source](https://www.redhat.com/en/topics/linux/what-is-the-linux-kernel)

The Linux® kernel is the main component of a Linux operating system (OS) and is the core interface between a computer’s hardware and its processes.

The kernel has 4 jobs:
- Memory management: Keep track of how much memory is used to store what, and where
- Process management: Determine which processes can use the central processing unit (CPU), when, and for how long
- Device drivers: Act as mediator/interpreter between the hardware and processes
- System calls and security: Receive requests for service from the processes

The kernel, if implemented properly, is invisible to the user, working in its own little world known as **kernel space**, where it allocates memory and keeps track of where everything is stored. What the user sees—like web browsers and files—are known as the **user space**. These applications interact with the kernel through a **system call interface (SCI)**.

Code executed by the system runs on CPUs in 1 of 2 modes: **kernel mode** or **user mode**. Code running in the kernel mode has unrestricted access to the hardware, while user mode restricts access to the CPU and memory to the SCI.

## Details

[Kernel docs](https://docs.kernel.org/) and [Wikipedia](https://en.wikipedia.org/wiki/Linux_kernel) are chaotic.

Linux is a **monolithic kernel with a modular design** (e.g., it can insert and remove loadable kernel modules at runtime).

Most Device drivers and kernel extensions run in kernel space (ring 0 in many CPU architectures), with full access to the hardware.

Unlike standard monolithic kernels, device drivers are easily configured as modules, and loaded or unloaded while the system is running.

Linux typically makes use of memory protection and virtual memory and can also handle non-uniform memory access.
