# Inspecting image internals

While I normally like to use purpose built tools for inspecting container internals, like dive, I will demonstrate for educational purposes how to inspect the internals of a container image. It is a good idea to verify that the contents of an image has what you expect to be in it. 

For this example I will be taking a look at the ```cgr.dev/chainguard/wolfi-base``` image by using the ctr command to export the image's content into a tarball. Here's how you can do it for the cgr.dev/chainguard/wolfi-base image:

For this guide first install `ctr` or `nerdctl`. Mac users can install `lima` and replace the ctr commands with lima:

```sh
brew install lima
limactl start default
limactl shell default
```
These may require sudo to execute:

```sh
ctr image pull cgr.dev/chainguard/wolfi-base:latest
ctr image export /tmp/wolfi-base.tar cgr.dev/chainguard/wolfi-base:latest```
```

After exporting, you can explore the contents of the `/tmp/wolfi-base.tar` file. This tarball contains the Wolfi image data stored using the OCI Image Layout format. To examine the contents, extract the tarball to a temporary directory:

```sh
mkdir /tmp/wolfi_base_image
tar -xf /tmp/wolfi-base.tar -C /tmp/wolfi_base_image/
ls -lah /tmp/wolfi_base_image/
```

The output will show the structure of the exported image, similar to this:

```sh
total 24K
drwxrwxr-x  3 a    a    4.0K Mar  6 12:29 .
drwxrwxrwt 15 root root 4.0K Mar  6 12:29 ..
drwxr-xr-x  3 a    a    4.0K Dec 31  1969 blobs
-rw-r--r--  1 a    a     378 Dec 31  1969 index.json
-rw-r--r--  1 a    a     235 Dec 31  1969 manifest.json
-r--r--r--  1 a    a      30 Dec 31  1969 oci-layout
```

Now let's mount the image and examine the filesystem:

```sh
mkdir /tmp/wolfi_rootfs
ctr image mount cgr.dev/chainguard/wolfi-base:latest /tmp/wolfi_rootfs
ls -l /tmp/wolfi_rootfs/
```

And lastly unmount the image when you are done:

```ctr image unmount /tmp/wolfi_rootfs```