ARG BASE_IMAGE='quay.io/fedora-ostree-desktops/base'
ARG FEDORA_MAJOR_VERSION='37'

FROM ${BASE_IMAGE}:${FEDORA_MAJOR_VERSION} AS builder

RUN rpm-ostree install https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm \
                       https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm \
                       fedora-repos-archive

RUN rpm-ostree install mock xorg-x11-drv-nvidia{,-cuda} binutils \
                       kernel-devel-$(rpm -qa kernel --queryformat '%{VERSION}-%{RELEASE}.%{ARCH}')

RUN ln -fs /usr/bin/ld.bfd /usr/bin/ld

RUN akmods --force --kernels "$(rpm -qa kernel --queryformat '%{VERSION}-%{RELEASE}.%{ARCH}')"

FROM ${BASE_IMAGE}:${FEDORA_MAJOR_VERSION}

COPY --from=builder /var/cache/akmods/nvidia /tmp/nvidia

RUN KERNEL_VERSION="$(rpm -qa kernel --queryformat '%{VERSION}-%{RELEASE}.%{ARCH}')" && \
    rpm-ostree install https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm \
                       https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm && \
    rpm-ostree install xorg-x11-drv-nvidia{,-cuda} kernel-devel-${KERNEL_VERSION} \
                       /tmp/nvidia/kmod-nvidia-${KERNEL_VERSION}-*.rpm && \
    rm -rf /tmp/nvidia /var/* && \
    ostree container commit
