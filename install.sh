#!/bin/bash

set -ouex pipefail

RELEASE="$(rpm -E %fedora)"

if [ "${HWE_FLAVOR}" = "main" ]; then
    # HWE_FLAVOR is main, no need to do anything
    exit 0
fi

# after F40 launches, bump to 41
if [[ "${FEDORA_MAJOR_VERSION}" -ge 40 ]]; then
    # note: this is done before single mirror hack to ensure this persists in image and is not reset
    # pre-release rpmfusion is in a different location
    sed -i "s%free/fedora/releases%free/fedora/development%" /etc/yum.repos.d/rpmfusion-*.repo
fi

if [ -n "${RPMFUSION_MIRROR}" ]; then
    # force use of single rpmfusion mirror
    echo "Using single rpmfusion mirror: ${RPMFUSION_MIRROR}"
    sed -i.bak "s%^metalink=%#metalink=%" /etc/yum.repos.d/rpmfusion-*.repo
    sed -i "s%^#baseurl=http://download1.rpmfusion.org%baseurl=${RPMFUSION_MIRROR}%" /etc/yum.repos.d/rpmfusion-*.repo
fi

# do HWE specific things
if [ "${HWE_FLAVOR}" = "asus" ]; then
    echo "install.sh: steps for HWE_FLAVOR: ${HWE_FLAVOR}"
    # Install Asus kernel
    wget https://copr.fedorainfracloud.org/coprs/lukenukem/asus-linux/repo/fedora-${RELEASE}/lukenukem-asus-linux-fedora-${RELEASE}.repo -O /etc/yum.repos.d/_copr_lukenukem-asus-linux.repo
    wget https://copr.fedorainfracloud.org/coprs/lukenukem/asus-kernel/repo/fedora-${RELEASE}/lukenukem-asus-kernel-fedora-${RELEASE}repo -O /etc/yum.repos.d/_copr_lukenukem-asus-kernel.repo
    rpm-ostree cliwrap install-to-root /
    rpm-ostree override replace \
    --experimental \
    --from repo=copr:copr.fedorainfracloud.org:lukenukem:asus-kernel \
        kernel \
        kernel-core \
        kernel-modules \
        kernel-modules-core \
        kernel-modules-extra
    git clone https://gitlab.com/asus-linux/firmware.git --depth 1 /tmp/asus-firmware
    cp -rf /tmp/asus-firmware/* /usr/lib/firmware/
    rm -rf /tmp/asus-firmware
elif [ "${HWE_FLAVOR}" = "surface" ]; then
    echo "install.sh: steps for HWE_FLAVOR: ${HWE_FLAVOR}"
    # Install Surface kernel
    wget https://pkg.surfacelinux.com/fedora/linux-surface.repo -P /etc/yum.repos.d
    wget https://github.com/linux-surface/linux-surface/releases/download/silverblue-20201215-1/kernel-20201215-1.x86_64.rpm -O /tmp/surface-kernel.rpm
    rpm-ostree cliwrap install-to-root /
    rpm-ostree override replace /tmp/surface-kernel.rpm \
        --remove kernel-core \
        --remove kernel-modules \
        --remove kernel-modules-extra \
        --remove libwacom \
        --remove libwacom-data \
        --install kernel-surface \
        --install iptsd \
        --install libwacom-surface \
        --install libwacom-surface-data
else
    echo "install.sh: steps for unexpected HWE_FLAVOR: ${HWE_FLAVOR}"
fi

# copy any shared sys files
if [ -d "/tmp/system_files/shared" ]; then
    rsync -rvK /tmp/system_files/shared/ /
fi

# copy any flavor specific files, eg silverblue
if [ -d "/tmp/system_files/${IMAGE_NAME}" ]; then
    rsync -rvK /tmp/system_files/"${IMAGE_NAME}"/ /
fi

# install any packages from packages.json
if [ -f "/tmp/packages.json" ]; then
    /tmp/packages.sh /tmp/packages.json
fi

# do HWE specific post-install things
if [ "${HWE_FLAVOR}" = "asus" ]; then
    echo "install.sh: post-install for: ${HWE_FLAVOR}"
elif [ "${HWE_FLAVOR}" = "surface" ]; then
    echo "install.sh: post-install for: ${HWE_FLAVOR}"
    if grep -q "silverblue" <<< "${IMAGE_NAME}"; then
      systemctl enable dconf-update
    fi
    systemctl enable fprintd
    systemctl enable surface-hardware-setup
else
    echo "install.sh: post-install for unexpected HWE_FLAVOR: ${HWE_FLAVOR}"
fi

if [ -n "${RPMFUSION_MIRROR}" ]; then
    # reset forced use of single rpmfusion mirror
    echo "Revert from single rpmfusion mirror: ${RPMFUSION_MIRROR}"
    rename -v .repo.bak .repo /etc/yum.repos.d/rpmfusion-*repo.bak
fi