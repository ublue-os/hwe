#!/bin/sh

set -ouex pipefail

mv /etc/nvidia-container-runtime/config.toml{,.orig}
cp /etc/nvidia-container-runtime/config{-rootless,}.toml

semodule --verbose --install /usr/share/selinux/packages/nvidia-container.pp
sed -i 's@enabled=1@enabled=0@g' /etc/yum.repos.d/rpmfusion-{,non}free{,-updates}.repo
ln -s /usr/bin/ld.bfd /etc/alternatives/ld
ln -s /etc/alternatives/ld /usr/bin/ld

if [[ "${IMAGE_NAME}" == "sericea" ]]; then
    mv /etc/sway/environment{,.orig}
    install -Dm644 /usr/share/ublue-os/etc/sway/environment /etc/sway/environment
fi
