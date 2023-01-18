#!/bin/bash

#set -ouex pipefail

readonly KERNEL_VERSION="$(rpm -q kernel-devel --queryformat='%{VERSION}-%{RELEASE}.%{ARCH}')"
NVIDIA_VERSION=525.78.01

curl https://download.nvidia.com/XFree86/Linux-x86_64/${NVIDIA_VERSION}/NVIDIA-Linux-x86_64-${NVIDIA_VERSION}.run \
    --output nvidia-driver.run

chmod +x ./nvidia-driver.run

./nvidia-driver.run \
    --kernel-name="${KERNEL_VERSION}" \
    --kernel-source-path="${KERNEL_VERSION}" \
    --x-library-path=/usr/lib64 \
    --x-module-path=/usr/lib64/xorg/modules \
    --no-nouveau-check \
    --skip-depmod \
    --no-questions \
    --silent
