#!/bin/sh

set -ouex pipefail

# Modularity repositories are not available on Fedora 39 and above, so don't try to disable them
if [[ "${FEDORA_VERSION}" -le 38 ]]; then
    sed -i 's@enabled=1@enabled=0@g' /etc/yum.repos.d/fedora-{cisco-openh264,modular,updates-modular}.repo
else
    sed -i 's@enabled=1@enabled=0@g' /etc/yum.repos.d/fedora-cisco-openh264.repo
fi

install -D /tmp/ublue-os-nvidia-addons/rpmbuild/SOURCES/nvidia-container-runtime.repo \
    /etc/yum.repos.d/nvidia-container-runtime.repo
install -D /tmp/ublue-os-nvidia-addons/rpmbuild/SOURCES/eyecantcu-supergfxctl.repo \
    /etc/yum.repos.d/eyecantcu-supergfxctl.repo

source /var/cache/akmods/nvidia-vars

if [[ "${IMAGE_NAME}" == "kinoite" ]]; then
    VARIANT_PKGS="supergfxctl-plasmoid"
elif [[ "${IMAGE_NAME}" == "silverblue" ]]; then
    VARIANT_PKGS="gnome-shell-extension-supergfxctl-gex"
else
    VARIANT_PKGS=""
fi

rpm-ostree install \
    xorg-x11-drv-${NVIDIA_PACKAGE_NAME}-{,cuda-,devel-,kmodsrc-,power-}${NVIDIA_FULL_VERSION} \
    nvidia-container-toolkit nvidia-vaapi-driver supergfxctl ${VARIANT_PKGS} \
    /var/cache/akmods/${NVIDIA_PACKAGE_NAME}/kmod-${NVIDIA_PACKAGE_NAME}-${KERNEL_VERSION}-${NVIDIA_AKMOD_VERSION}.fc${RELEASE}.rpm \
    /tmp/ublue-os-nvidia-addons/rpmbuild/RPMS/noarch/ublue-os-nvidia-addons-*.rpm
