# oxidatedBSD Technical Note

oxidatedBSD is a Rust rewrite of zedBSD: a bootable `no_std` amd64 operating system with an interactive shell, disk-loaded programs, preemptible syscalls, and a separate address space for each process.

**Source status:** The implementation is currently unpublished. This note provides a public architectural overview and the verification results recorded in the project documentation. It is not a source release.

## Current milestone

The current milestone boots in QEMU through the PVH ELF note and starts a small, usable operating system. PID 1 loads an interactive serial shell from the disk filesystem. Shell commands run as separate preemptively scheduled processes.

Implemented capabilities include:

- 32-bit to 64-bit entry, serial console, interrupt handling, and panic backtraces.
- Physical frame allocation, a kernel heap, and per-process page tables.
- ACPI discovery, local APIC and IOAPIC setup, PIT timing, and PS/2 keyboard interrupts.
- PCI discovery, a virtio-blk driver, and a virtio-net driver with RX and TX virtqueues.
- Ring-3 user processes, an ELF64 loader, and round-robin preemption.
- Per-process kernel stacks, allowing the timer to preempt a process during a syscall.
- Syscalls for process creation, memory mapping, file reads, directory listing, console input, sleeping, and process exit.
- OXIDFS, a small read-only flat filesystem stored on the virtio test disk.
- A Rust userland with `init`, `sh`, `ls`, `cat`, `echo`, `logd`, and demonstration programs.

## Architecture

### Kernel

The kernel targets `x86_64-unknown-none` and uses Rust without the standard library. Its main modules cover interrupts, physical and virtual memory, ACPI, APIC, PCI, virtio drivers, OXIDFS, ELF loading, scheduling, and syscall dispatch.

Each process receives a private PML4. User memory is mapped into a per-process window, and page tables change during context switches. Syscalls execute on the current process's own kernel stack with interrupts enabled, so blocking input does not prevent scheduling.

### Userland

The userland is a freestanding Rust workspace. Programs link at a common user-space base but execute in separate address spaces. The loader reads `init` from OXIDFS at boot. Later process creation checks the disk first, with an embedded program registry as a fallback.

A fixed argument page passes one argument string to a new process. Exit handling reaps process stacks and mapped frames before scheduling another process.

### Storage and networking

A host-side tool builds the OXIDFS image from freshly compiled userland binaries. QEMU attaches the image as a virtio-blk device and provides a user-mode virtio-net interface. The network driver transmits a test frame during startup.

## Verification recorded by the project

The source documentation records these checks:

- Two instances of the same program run concurrently at the same link base with distinct page-table roots.
- An unmapped user access produces a clean page fault rather than silently succeeding.
- The virtio-net driver transmits a test frame.
- The shell lists files, reads `hello.txt`, and echoes an argument through separate disk-loaded programs.
- A heartbeat daemon and countdown program run alongside the interactive shell.
- After all processes exit, the scheduler halts cleanly with zero exceptions.

The development history also documents fixes for allocator block rewriting, virtio ring allocation, timer end-of-interrupt handling, kernel-frame restoration, syscall state tracking, ELF `.bss` handling, and argument-page aliasing.

## Engineering relevance

The project exercises low-level systems work that is also relevant to infrastructure debugging: memory isolation, interrupt safety, driver bring-up, executable loading, process lifecycle management, and reproducible QEMU-based verification.
