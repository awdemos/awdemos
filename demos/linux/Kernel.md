# Kernel

A kernel is the sotware that handles the data input and output of programs in the hardware of a computer. I have been a fan of it since first installing Red Hat 6.2 which I installed from a CD that came from a magazine I bought in a book store.

More information and important aspects of the Linux kernel for Devops and SRE (forthcoming).

## Educational videos

- [Tutorial: Building the Simplest Possible Linux System - Rob Landley] (https://www.youtube.com/watch?v=Sk9TatW9ino) - Obsolete but fantastic educational resource.

- [Learning the Linux Kernel with tracing] (https://www.youtube.com/watch?v=JRyrhsx-L5Y) - A comprehensive overview of Linux kernel internals by one of the leading figures in the Linux community.

- [Introduction to Memory Management in Linux] (https://www.youtube.com/watch?v=7aONIVSXiJ8) - This presentation will describe the different types of virtual memory spaces and mappings used in the Linux kernel


## Important source code

## Important Linux Syscalls Reference

For those interested in diving deeper into the Linux kernel's operations, understanding system calls (syscalls) is crucial. Syscalls form the interface between the kernel space and user space, allowing programs to request services from the Linux kernel.

One of the most comprehensive resources for Linux syscalls can be found in the Linux source code itself. Specifically, the file `unistd.h` within the x86 architecture directory provides a detailed list of syscalls available in Linux.

- [Linux Syscalls Reference: unistd.h](https://github.com/torvalds/linux/blob/master/arch/x86/include/asm/unistd.h)

This file is part of the Linux kernel source and is maintained by Linus Torvalds and other kernel developers. It's updated regularly as new syscalls are added or existing ones are modified. For anyone looking to understand the low-level operations of the Linux kernel, this file is an invaluable resource.
