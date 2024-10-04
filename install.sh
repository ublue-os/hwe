#!/bin/bash

set -ouex pipefail

RELEASE="$(rpm -E %fedora)"

if [ "${KERNEL_FLAVOR}" = "main" ]; then
    # KERNEL_FLAVOR is main, no need to do anything
    exit 0
fi

# disable any remaining rpmfusion repos
sed -i 's@enabled=1@enabled=0@g' /etc/yum.repos.d/rpmfusion*.repo

# do HWE specific things
if [ "${KERNEL_FLAVOR}" = "asus" ]; then
    echo "install.sh: steps for KERNEL_FLAVOR: ${KERNEL_FLAVOR}"
    # Install Asus kernel
    curl -Lo /etc/yum.repos.d/_copr_lukenukem-asus-linux.repo \
        https://copr.fedorainfracloud.org/coprs/lukenukem/asus-linux/repo/fedora-"${RELEASE}"/lukenukem-asus-linux-fedora-"${RELEASE}".repo
    rpm-ostree cliwrap install-to-root /
    rpm-ostree override replace \
        --experimental \
        /tmp/kernel-rpms/kernel-"${KERNEL_VERSION}".rpm \
        /tmp/kernel-rpms/kernel-core-"${KERNEL_VERSION}".rpm \
        /tmp/kernel-rpms/kernel-modules-"${KERNEL_VERSION}".rpm \
        /tmp/kernel-rpms/kernel-modules-core-"${KERNEL_VERSION}".rpm \
        /tmp/kernel-rpms/kernel-modules-extra-"${KERNEL_VERSION}".rpm
    git clone https://gitlab.com/asus-linux/firmware.git --depth 1 /tmp/asus-firmware
    cp -rf /tmp/asus-firmware/* /usr/lib/firmware/
    rm -rf /tmp/asus-firmware
elif [ "${KERNEL_FLAVOR}" = "surface" ]; then
    echo "install.sh: steps for KERNEL_FLAVOR: ${KERNEL_FLAVOR}"
    curl -Lo /etc/yum.repos.d/linux-surface.repo \
        https://pkg.surfacelinux.com/fedora/linux-surface.repo
    # curl -Lo /tmp/surface-kernel.rpm \
    #     https://github.com/linux-surface/linux-surface/releases/download/silverblue-20201215-1/kernel-20201215-1.x86_64.rpm
    # Install Surface kernel
    rpm-ostree cliwrap install-to-root /
    rpm-ostree override replace \
        --experimental \
        --remove kernel \
        --remove kernel-core \
        --remove kernel-modules \
        --remove kernel-modules-core \
        --remove kernel-modules-extra \
        --remove libwacom \
        --remove libwacom-data \
        /tmp/kernel-rpms/kernel-surface-"${KERNEL_VERSION}".rpm \
        /tmp/kernel-rpms/kernel-surface-core-"${KERNEL_VERSION}".rpm \
        /tmp/kernel-rpms/kernel-surface-modules-"${KERNEL_VERSION}".rpm \
        /tmp/kernel-rpms/kernel-surface-modules-core-"${KERNEL_VERSION}".rpm \
        /tmp/kernel-rpms/kernel-surface-modules-extra-"${KERNEL_VERSION}".rpm \
        /tmp/kernel-rpms/kernel-surface-default-watchdog-"${KERNEL_VERSION}".rpm \
        /tmp/kernel-rpms/libwacom-surface*.rpm \
        /tmp/kernel-rpms/iptsd*.rpm
else
    echo "install.sh: steps for unexpected KERNEL_FLAVOR: ${KERNEL_FLAVOR}"
fi

# copy any shared sys files
if [[ -d /ctx/"${KERNEL_FLAVOR}"/system_files/shared ]]; then
    rsync -rvK /ctx/"${KERNEL_FLAVOR}"/system_files/shared/ /
fi

# copy any flavor specific files, eg silverblue
if [[ -d "/ctx/${KERNEL_FLAVOR}/system_files/${IMAGE_NAME}" ]]; then
    rsync -rvK "/ctx/${KERNEL_FLAVOR}/system_files/${IMAGE_NAME}"/ /
fi

# install any packages from packages.json
if [ -f "/ctx/${KERNEL_FLAVOR}/packages.json" ]; then
    cp /ctx/"${KERNEL_FLAVOR}"/packages.json /tmp/packages.json
    /ctx/packages.sh /tmp/packages.json
fi

# do HWE specific post-install things
if [ "${KERNEL_FLAVOR}" = "asus" ]; then
    echo "install.sh: post-install for: ${KERNEL_FLAVOR}"
elif [ "${KERNEL_FLAVOR}" = "surface" ]; then
    echo "install.sh: post-install for: ${KERNEL_FLAVOR}"
    if grep -q "silverblue" <<< "${IMAGE_NAME}"; then
      systemctl enable dconf-update
    fi
    systemctl enable fprintd
    systemctl enable surface-hardware-setup
else
    echo "install.sh: post-install for unexpected KERNEL_FLAVOR: ${KERNEL_FLAVOR}"
fi

/ctx/build-initramfs.sh
