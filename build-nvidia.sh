#!/bin/bash

set -ouex pipefail

readonly KERNEL_VERSION="$(rpm -q kernel-devel --queryformat='%{VERSION}-%{RELEASE}.%{ARCH}')"

curl https://download.nvidia.com/XFree86/Linux-x86_64/${NVIDIA_VERSION}/NVIDIA-Linux-x86_64-${NVIDIA_VERSION}.run \
    --output nvidia-driver.run

chmod +x ./nvidia-driver.run

# The nvidia driver installer will try to load the nvidia kernel modules after
# building them if it detects an nvidia card, which will fail in a container
# build environment. The workaround is to build the kernel modules manually.
./nvidia-driver.run --extract-only

make -C /NVIDIA-Linux-x86_64-${NVIDIA_VERSION}/kernel -j8

install -D NVIDIA-Linux-x86_64-${NVIDIA_VERSION}/kernel/nvidia{,-{drm,modeset,peermem,uvm}}.ko \
	--target-directory="/build/usr/lib/modules/${KERNEL_VERSION}/kernel/drivers/video"

date > /.builddate

./nvidia-driver.run \
    --kernel-name="${KERNEL_VERSION}" \
    --kernel-source-path="/usr/src/kernels/${KERNEL_VERSION}" \
    --x-library-path=/usr/lib64 \
    --x-module-path=/usr/lib64/xorg/modules \
    --no-nouveau-check \
    --no-precompiled-interface \
    --no-rpms \
    --skip-depmod \
    --no-questions \
    --no-distro-scripts \
    --no-dkms \
    --no-kernel-module-source \
    --skip-module-unload \
    --silent \
    --no-kernel-modules
