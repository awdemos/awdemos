Here's a step-by-step guide to create a container from scratch using Linux namespace tools:

## Create Root Filesystem
```bash
# Create base directory
mkdir -p container/rootfs
cd container

# Create minimal filesystem structure
mkdir -p rootfs/{bin,dev,etc,home,lib,proc,sys}
```

## Setup Namespaces and Container Environment
```bash
# Create new namespaces
unshare --fork --pid --mount --net --uts /bin/bash

# Mount proc filesystem
mount -t proc none rootfs/proc

# Setup cgroups for resource control
mkdir -p /sys/fs/cgroup/cpu/container1
echo 100000 > /sys/fs/cgroup/cpu/container1/cpu.cfs_quota_us
echo $$ > /sys/fs/cgroup/cpu/container1/tasks
```

## Enter Container Namespace
```bash
# Get container PID
PID=$(ps -ef | grep unshare | grep -v grep | awk '{print $2}')

# Enter namespaces
nsenter --target $PID --mount --uts --ipc --net --pid chroot rootfs /bin/sh
```

## Resource Management
```bash
# Set memory limits
echo "50M" > /sys/fs/cgroup/memory/container1/memory.limit_in_bytes

# Set CPU shares
echo "512" > /sys/fs/cgroup/cpu/container1/cpu.shares
```

## Cleanup
```bash
# Unmount filesystems
umount rootfs/proc

# Remove cgroup configuration
rmdir /sys/fs/cgroup/cpu/container1
rmdir /sys/fs/cgroup/memory/container1
```

These commands create a basic container with:
- Isolated process namespace
- Resource limitations
- Separate mount points
- Network isolation
- Custom root filesystem

The container will be isolated from the host system while maintaining controlled resource usage through cgroups[4][7].

Citations:
[1] https://pplx-res.cloudinary.com/image/upload/v1736009814/user_uploads/duBHkSTCzUwCxCw/image.jpg
[2] https://github.com/jpetazzo/nsenter/blob/master/README.md
[3] https://stackoverflow.com/questions/66688853/run-a-process-without-actually-execing-into-a-container-using-nsenter
[4] https://dev.to/imransaifi/master-the-art-of-manual-container-creation-in-linux-no-docker-needed-3gg5
[5] https://contractdesign.github.io/docker/2021/06/10/nsenter.html
[6] https://ericchiang.github.io/post/containers-from-scratch/
[7] https://akashrajpurohit.com/blog/build-your-own-docker-with-linux-namespaces-cgroups-and-chroot-handson-guide/
[8] https://stackoverflow.com/questions/69893706/how-to-connect-host-machine-from-container-using-nsenter-utility
[9] https://www.bomberbot.com/docker/building-a-custom-container-system-from-scratch/
