#!/bin/bash

set -ouex pipefail

RELEASE="$(rpm -E %fedora)"

# https://negativo17.org/nvidia-driver/
wget https://negativo17.org/repos/fedora-nvidia.repo -O /etc/yum.repos.d/fedora-nvidia.repo

# nvidia install steps
rpm-ostree install /tmp/akmods-rpms/ublue-os/ublue-os-nvidia-addons-*.rpm

source /tmp/akmods-rpms/kmods/nvidia-vars.${NVIDIA_MAJOR_VERSION}

if [[ "${IMAGE_NAME}" == "kinoite" ]]; then
    VARIANT_PKGS="supergfxctl-plasmoid supergfxctl"
elif [[ "${IMAGE_NAME}" == "silverblue" ]]; then
    VARIANT_PKGS="gnome-shell-extension-supergfxctl-gex supergfxctl"
else
    VARIANT_PKGS=""
fi

rpm-ostree install nvidia-driver nvidia-driver-libs.i686 nvidia-settings \
 nvidia-container-toolkit nvidia-vaapi-driver ${VARIANT_PKGS}

## TODO: Add open Nvidia driver (this codepath is untested):
if [[ "{NVIDIA_DRIVER_TYPE}" == "open"]]; then
    sed -i -e 's/kernel$/kernel-open/g' /etc/nvidia/kernel.conf
    akmods --rebuild
fi

# nvidia post-install steps
sed -i 's@enabled=1@enabled=0@g' /etc/yum.repos.d/{eyecantcu-supergfxctl,nvidia-container-toolkit}.repo

systemctl enable ublue-nvctk-cdi.service
semodule --verbose --install /usr/share/selinux/packages/nvidia-container.pp

if [[ "${IMAGE_NAME}" == "sericea" ]]; then
    mv /etc/sway/environment{,.orig}
    install -Dm644 /usr/share/ublue-os/etc/sway/environment /etc/sway/environment
fi