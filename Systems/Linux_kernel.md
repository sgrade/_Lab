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

## Memory management

[Kernel docs](https://docs.kernel.org/admin-guide/mm/concepts.html)

Here we assume that an MMU is available and a CPU can translate a virtual address to a physical address.

The virtual memory abstracts the details of physical memory from the application software, allows to keep only needed information in the physical memory (demand paging) and provides a mechanism for the protection and controlled sharing of data between processes.

With virtual memory, each and every memory access uses a virtual address. When the CPU decodes an instruction that reads (or writes) from (or to) the system memory, it translates the virtual address encoded in that instruction to a physical address that the memory controller can understand.

The physical system memory is divided into page frames, or pages. The size of each page is architecture specific.

The address translation requires several memory accesses and memory accesses are slow relatively to CPU speed. To avoid spending precious processor cycles on the address translation, CPUs maintain a cache of such translations called Translation Lookaside Buffer (or TLB).

### Shared memory

A parent and its children have separate address spaces. While this would provide a more secured way of executing parent and children processes (because they will not interfere each other), they shared nothing and have no way to communicate with each other.

A shared memory is an extra piece of memory that is attached to some address spaces for their owners to use. As a result, all of these processes share the same memory segment and have access to it.
