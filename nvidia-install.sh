#!/bin/bash

set -ouex pipefail

RELEASE="$(rpm -E %fedora)"

if [[ "${FEDORA_MAJOR_VERSION}" -le 38 ]]; then
    sed -i 's@enabled=1@enabled=0@g' /etc/yum.repos.d/fedora-{cisco-openh264,modular,updates-modular}.repo
else
    sed -i 's@enabled=1@enabled=0@g' /etc/yum.repos.d/fedora-cisco-openh264.repo
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


# nvidia install steps
rpm-ostree install /tmp/akmods-rpms/ublue-os/ublue-os-nvidia-addons-*.rpm

source /tmp/akmods-rpms/kmods/nvidia-vars

if [[ "${IMAGE_NAME}" == "kinoite" ]]; then
    VARIANT_PKGS="supergfxctl-plasmoid supergfxctl"
elif [[ "${IMAGE_NAME}" == "silverblue" ]]; then
    VARIANT_PKGS="gnome-shell-extension-supergfxctl-gex supergfxctl"
else
    VARIANT_PKGS=""
fi

rpm-ostree install \
    xorg-x11-drv-${NVIDIA_PACKAGE_NAME}-{,cuda-,devel-,kmodsrc-,power-}${NVIDIA_FULL_VERSION} \
    xorg-x11-drv-${NVIDIA_PACKAGE_NAME}-libs.i686 \
    nvidia-container-toolkit nvidia-vaapi-driver ${VARIANT_PKGS} \
    /tmp/akmods-rpms/kmods/kmod-${NVIDIA_PACKAGE_NAME}-${KERNEL_VERSION}-${NVIDIA_AKMOD_VERSION}.fc${RELEASE}.rpm


# nvidia post-install steps
sed -i 's@enabled=1@enabled=0@g' /etc/yum.repos.d/{eyecantcu-supergfxctl,nvidia-container-toolkit}.repo

systemctl enable ublue-nvctk-cdi.service
semodule --verbose --install /usr/share/selinux/packages/nvidia-container.pp

if [[ "${IMAGE_NAME}" == "sericea" ]]; then
    mv /etc/sway/environment{,.orig}
    install -Dm644 /usr/share/ublue-os/etc/sway/environment /etc/sway/environment
fi


if [ -n "${RPMFUSION_MIRROR}" ]; then
    # reset forced use of single rpmfusion mirror
    echo "Revert from single rpmfusion mirror: ${RPMFUSION_MIRROR}"
    rename -v .repo.bak .repo /etc/yum.repos.d/rpmfusion-*repo.bak
fi
