#!/bin/bash

set -ouex pipefail

RELEASE="$(rpm -E %fedora)"

# disable any remaining rpmfusion repos
sed -i 's@enabled=1@enabled=0@g' /etc/yum.repos.d/rpmfusion*.repo

sed -i 's@enabled=1@enabled=0@g' /etc/yum.repos.d/fedora-cisco-openh264.repo

## nvidia install steps
rpm-ostree install /tmp/akmods-rpms/ublue-os/ublue-os-nvidia-addons-*.rpm

# enables nvidia repos provided by ublue-os-nvidia-addons
sed -i '0,/enabled=0/{s/enabled=0/enabled=1/}' /etc/yum.repos.d/eyecantcu-supergfxctl.repo
sed -i '0,/enabled=0/{s/enabled=0/enabled=1/}' /etc/yum.repos.d/nvidia-container-toolkit.repo
#NOTE: nvidia drivers are already provided by negativo17-fedora-multimedia.repo, no need to enable
#sed -i '0,/enabled=0/{s/enabled=0/enabled=1/}' /etc/yum.repos.d/negativo17-fedora-nvidia.repo

source /tmp/akmods-rpms/kmods/nvidia-vars

if [[ "${IMAGE_NAME}" == "kinoite" ]]; then
    VARIANT_PKGS="supergfxctl-plasmoid supergfxctl"
elif [[ "${IMAGE_NAME}" == "silverblue" ]]; then
    VARIANT_PKGS="gnome-shell-extension-supergfxctl-gex supergfxctl"
else
    VARIANT_PKGS=""
fi

rpm-ostree install \
    libnvidia-fbc \
    libnvidia-ml.i686 \
    libva-nvidia-driver \
    mesa-vulkan-drivers.i686 \
    nvidia-driver \
    nvidia-driver-cuda \
    nvidia-driver-cuda-libs.i686 \
    nvidia-driver-libs.i686 \
    nvidia-modprobe \
    nvidia-persistenced \
    nvidia-settings \
    nvidia-container-toolkit ${VARIANT_PKGS} \
    /tmp/akmods-rpms/kmods/kmod-nvidia-${KERNEL_VERSION}-${NVIDIA_AKMOD_VERSION}.fc${RELEASE}.rpm


## nvidia post-install steps
# disables nvidia repos provided by ublue-os-nvidia-addons
sed -i 's@enabled=1@enabled=0@g' /etc/yum.repos.d/{eyecantcu-supergfxctl,negativo17-fedora-nvidia,nvidia-container-toolkit}.repo

# ensure kernel.conf matches NVIDIA_FLAVOR (which must be nvidia or nvidia-open)
# kmod-nvidia-common defaults to 'nvidia-open' but this will match our akmod image
sed -i "s/^MODULE_VARIANT=.*/MODULE_VARIANT=$KERNEL_MODULE_TYPE/" /etc/nvidia/kernel.conf

systemctl enable nvidia-persistenced.service

systemctl enable ublue-nvctk-cdi.service
semodule --verbose --install /usr/share/selinux/packages/nvidia-container.pp

# Universal Blue specific Initramfs fixes
echo "options nvidia NVreg_TemporaryFilePath=/var/tmp" >> /usr/lib/modprobe.d/nvidia-atomic.conf
cp /etc/modprobe.d/nvidia-modeset.conf /usr/lib/modprobe.d/nvidia-modeset.conf
sed -i 's@omit_drivers@force_drivers@g' /usr/lib/dracut/dracut.conf.d/99-nvidia.conf

if [[ "${IMAGE_NAME}" == "sericea" ]]; then
    mv /etc/sway/environment{,.orig}
    install -Dm644 /usr/share/ublue-os/etc/sway/environment /etc/sway/environment
fi
