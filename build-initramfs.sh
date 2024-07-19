#!/usr/bin/bash

set -ouex pipefail

ls -la /lib/modules/

if [[ "${KERNEL_FLAVOR}" == "surface" ]]; then
    KERNEL_SUFFIX="surface"
else
    KERNEL_SUFFIX=""
fi

if [ ! -f /usr/libexec/rpm-ostree/wrapped/dracut ]; then
    rpm-ostree cliwrap install-to-root /
fi

QUALIFIED_KERNEL="$(rpm -qa | grep -P 'kernel-(|'"$KERNEL_SUFFIX"'-)(\d+\.\d+\.\d+)' | sed -E 's/kernel-(|'"$KERNEL_SUFFIX"'-)//')"

/usr/libexec/rpm-ostree/wrapped/dracut --no-hostonly --kver "$(ls /lib/modules)" --reproducible -v --add ostree -f "/lib/modules/$(ls /lib/modules)/initramfs.img"

chmod 0600 "/lib/modules/$(ls /lib/modules)/initramfs.img"
