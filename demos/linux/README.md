# Linux Kernel & System Research

**Linux kernel internals, system calls, and low-level programming research for DevOps and SRE.**

## Overview

This demo contains research notes on Linux kernel internals, system programming, and system calls. Focus areas include kernel architecture, memory management, and system call interfaces between user space and kernel space.

**Target Audience**: DevOps engineers, SREs, and system administrators who want deeper understanding of Linux internals.

## Why Linux Kernel Research?

- **Performance tuning**: Understanding kernel behavior enables optimization
- **Debugging**: System call tracing reveals root causes
- **Security**: Kernel-level security controls and syscalls
- **System programming**: Direct interaction with kernel for critical applications

## Core Concepts

### 1. Kernel Definition

A kernel is **software that handles data input and output of programs in the hardware of a computer**. It manages:
- **CPU scheduling**: Process and thread execution
- **Memory management**: Virtual memory, paging, swapping
- **Device drivers**: Hardware abstraction layer
- **File systems**: File I/O, mounting, permissions
- **Network stack**: TCP/IP, sockets, routing

### 2. User Space vs Kernel Space

```
┌─────────────────────────────────────────────────────┐
│                  Applications                     │
│              (User Space - Ring 3)                  │
├─────────────────────────────────────────────────────┤
│                   System Calls                     │
│                   (Interface)                       │
├─────────────────────────────────────────────────────┤
│                   Linux Kernel                      │
│              (Kernel Space - Ring 0)                 │
│  ┌──────────┐  ┌──────────┐  ┌──────────┐  │
│  │ CPU      │  │ Memory   │  │ Drivers  │  │
│  │ Scheduler│  │ Manager  │  │          │  │
│  └──────────┘  └──────────┘  └──────────┘  │
└─────────────────────────────────────────────────────┘
```

**User Space**: Applications run here (Ring 3)
- Restricted hardware access
- Must use syscalls to request kernel services
- Lower privilege level for security

**Kernel Space**: Kernel runs here (Ring 0)
- Direct hardware access
- Full system privileges
- Executes system calls on behalf of user space

### 3. System Calls (Syscalls)

Syscalls are the **interface between kernel space and user space**. They allow programs to request services from the Linux kernel.

**Common Syscalls**:
| Category | Syscalls | Description |
|----------|-----------|-------------|
| File I/O | `read()`, `write()`, `open()`, `close()` | File operations |
| Process | `fork()`, `exec()`, `exit()`, `wait()` | Process management |
| Memory | `mmap()`, `brk()`, `munmap()` | Memory allocation |
| Network | `socket()`, `bind()`, `listen()`, `accept()` | Network operations |
| IPC | `pipe()`, `shmget()`, `msgsnd()` | Inter-process communication |

**Syscall Flow**:
```
User Space Application
       │
       │ invoke syscall
       ▼
System Call Interface
       │
       │ switch to kernel mode
       ▼
Linux Kernel
       │
       │ execute operation
       │ access hardware
       ▼
Hardware
       │
       │ return result
       ▼
User Space Application
```

## System Calls Reference

### Official Linux Source Code

The most comprehensive resource for Linux syscalls is the **Linux kernel source code itself**.

**File**: `arch/x86/include/asm/unistd.h`

```c
// Example: syscall definitions for x86_64
#define __NR_read 0
#define __NR_write 1
#define __NR_open 2
#define __NR_close 3
#define __NR_stat 4
...
```

**Link**: [Linux Syscalls Reference: unistd.h](https://github.com/torvalds/linux/blob/master/arch/x86/include/asm/unistd.h)

This file is part of the Linux kernel and is maintained by Linus Torvalds and other kernel developers. It's updated regularly as new syscalls are added or existing ones are modified.

### Why Source Code Reference?

- **Most accurate**: Direct from kernel maintainers
- **Always up-to-date**: Updated with kernel releases
- **Platform-specific**: Separate definitions for each architecture
- **Complete**: Lists all syscalls, no missing ones

## Educational Resources

### Video Tutorials

| Title | Link | Duration | Focus |
|-------|-------|----------|-------|
| Building Simplest Possible Linux System | [Rob Landley](https://www.youtube.com/watch?v=Sk9TatW9ino) | 1h 30m | Build minimal Linux from scratch |
| Learning Linux Kernel with Tracing | [BPF tracing](https://www.youtube.com/watch?v=JRyrhsx-L5Y) | 45m | Kernel internals overview |
| Introduction to Memory Management | [Kernel memory](https://www.youtube.com/watch?v=7aONIVSXiJ8) | 30m | Virtual memory, mappings |

### Recommended Reading

- **Linux Kernel Development** by Robert Love
- **Understanding the Linux Kernel** by Daniel Bovet
- **Linux Device Drivers** by Jonathan Corbet

## Practical Applications

### 1. Performance Profiling

Use syscalls to debug performance issues:

```bash
# Trace syscalls with strace
strace -p <pid> -o trace.log

# Count syscalls by process
strace -c <command>

# Real-time syscall monitoring
strace -f -e trace=network <command>
```

**Example**: Debug slow application startup
```bash
strace -c ./my-app
# Shows which syscalls take most time
```

### 2. System Call Filtering

Seccomp-BPF for syscall filtering:
```c
#include <linux/seccomp.h>
#include <seccomp.h>

// Filter syscalls for security
scmp_filter_ctx ctx = seccomp_init(SCMP_ACT_KILL);
seccomp_rule_add(ctx, SCMP_ACT_ALLOW, SCMP_SYS(read), 0);
seccomp_rule_add(ctx, SCMP_ACT_ALLOW, SCMP_SYS(write), 0);
seccomp_load(ctx);
```

### 3. Kernel Tuning

Adjust kernel parameters for performance:

```bash
# View current sysctl settings
sysctl -a | grep vm

# Modify for performance
echo 'vm.swappiness=10' >> /etc/sysctl.conf

# Apply changes
sysctl -p
```

## Advanced Topics

### Memory Management

**Types of Virtual Memory**:
- **User memory**: Per-process virtual address space
- **Kernel memory**: Shared kernel address space
- **Physical memory**: Actual RAM pages
- **Swap space**: Disk-backed memory

**Memory Mapping Types**:
- **Anonymous**: `malloc()` allocations
- **File-backed**: `mmap()` on files
- **Shared**: IPC shared memory

### Process Scheduling

**Scheduling Algorithms**:
- **CFS**: Completely Fair Scheduler (default)
- **RT**: Real-time scheduler (low-latency)
- **Deadline**: Latency-sensitive tasks

**Priority Levels**:
```
0-99:   Real-time priority
100-139: Normal priority (nice -20 to +19)
```

### Device Drivers

**Driver Types**:
- **Character devices**: Serial ports, terminals (/dev/tty)
- **Block devices**: Hard drives, SSDs (/dev/sda)
- **Network devices**: Ethernet cards, WiFi (/dev/eth0)

**Driver Development**:
```c
#include <linux/module.h>
#include <linux/fs.h>

// Simple character device driver
static int my_open(struct inode *inode, struct file *file) {
    printk(KERN_INFO "Device opened\n");
    return 0;
}

// Module initialization
static int __init my_init(void) {
    printk(KERN_INFO "Module loaded\n");
    return register_chrdev(MAJOR_NUM, "mydevice", &fops);
}
```

## DevOps/SRE Applications

### 1. Container Orchestration

Understanding syscalls is crucial for:
- **Container isolation**: Namespace, cgroup syscalls
- **Performance monitoring**: `strace` inside containers
- **Security**: Seccomp syscall filtering

### 2. Debugging Production Issues

```bash
# Investigate slow database
strace -f -p $(pgrep postgres)

# Trace file access patterns
strace -f -e trace=openat,read,write <command>

# Monitor network syscalls
strace -f -e trace=socket,connect,accept <command>
```

### 3. Performance Tuning

- **Kernel parameters**: `sysctl` optimization
- **System calls**: Minimize expensive syscalls
- **Memory management**: Tune `vm.swappiness`, `vm.dirty_ratio`

## Quick Reference

### Common Syscalls Quick Look

| Syscall | Purpose | Man Page |
|----------|---------|-----------|
| `fork()` | Create process | `man 2 fork` |
| `execve()` | Execute program | `man 2 execve` |
| `open()` | Open file | `man 2 open` |
| `read()` | Read from descriptor | `man 2 read` |
| `write()` | Write to descriptor | `man 2 write` |
| `mmap()` | Map memory | `man 2 mmap` |
| `brk()` | Change heap size | `man 2 brk` |
| `socket()` | Create socket | `man 2 socket` |
| `bind()` | Bind socket to address | `man 2 bind` |
| `listen()` | Listen for connections | `man 2 listen` |

### Debugging Tools

| Tool | Purpose | Example |
|------|---------|---------|
| `strace` | Trace syscalls | `strace ls` |
| `ltrace` | Trace library calls | `ltrace ls` |
| `ftrace` | Kernel function tracing | `echo function > /sys/kernel/debug/tracing/set_ftrace_filter` |
| `perf` | Performance profiling | `perf top` |
| `sysdig` | System-wide monitoring | `sysdig` |

## Related Research

This research connects to other demos in this portfolio:

- `demos/kubernetes/` - Container orchestration (uses kernel namespaces)
- `demos/llm/` - GPU management (requires kernel drivers)
- `demos/security/` - Kernel-level security controls

## Future Research

- [ ] Complete container namespace research
- [ ] Add eBPF syscall filtering examples
- [ ] Document syscalls for each demo category
- [ ] Kernel version comparison (4.x vs 5.x vs 6.x)
- [ ] Performance tuning guidelines for Kubernetes

## Resources

### Official Documentation
- [Linux Kernel Documentation](https://www.kernel.org/doc/html/latest/)
- [Linux Syscalls Man Pages](https://man7.org/linux/man-pages/)
- [Source Code](https://github.com/torvalds/linux)

### Community
- [LKML (Linux Kernel Mailing List)](https://lkml.org/)
- [Linux Kernel Newbies](https://kernelnewbies.org/)
- [Stack Overflow (linux-kernel tag)](https://stackoverflow.com/questions/tagged/linux-kernel)

---

**Research Status**: 📝 Ongoing - more details and practical examples forthcoming.
