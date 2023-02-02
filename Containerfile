ARG BASE_IMAGE='quay.io/fedora-ostree-desktops/silverblue'
ARG FEDORA_MAJOR_VERSION='37'

FROM ${BASE_IMAGE}:${FEDORA_MAJOR_VERSION} AS builder

RUN sed -i 's@enabled=1@enabled=0@g' /etc/yum.repos.d/fedora-{cisco-openh264,modular,updates-modular,updates-archive}.repo


RUN rpm-ostree install https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm \
                       fedora-repos-archive

RUN rpm-ostree install akmods mock xorg-x11-drv-nvidia{,-cuda} binutils \
                       kernel-devel-$(rpm -qa kernel --queryformat '%{VERSION}-%{RELEASE}.%{ARCH}')

# alternatives cannot create symlinks on its own during a container build
RUN ln -s /usr/bin/ld.bfd /etc/alternatives/ld && ln -s /etc/alternatives/ld /usr/bin/ld

ADD certs/public_key.der   /etc/pki/akmods/certs/public_key.der
ADD certs/private_key.priv /etc/pki/akmods/private/private_key.priv
RUN chmod 644 /etc/pki/akmods/{private/private_key.priv,certs/public_key.der}

RUN akmods --force --kernels "$(rpm -qa kernel --queryformat '%{VERSION}-%{RELEASE}.%{ARCH}')" --kmod nvidia

FROM ${BASE_IMAGE}:${FEDORA_MAJOR_VERSION}

COPY --from=builder /var/cache/akmods/nvidia /tmp/nvidia
# Have different name for *.der in case kmodgenca is needed for creating more keys
COPY --from=builder /etc/pki/akmods/certs/public_key.der /etc/pki/akmods/certs/akmods-nvidia.der

RUN KERNEL_VERSION="$(rpm -qa kernel --queryformat '%{VERSION}-%{RELEASE}.%{ARCH}')" && \
    rpm-ostree install https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm \
                       https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm && \
    rpm-ostree install xorg-x11-drv-nvidia{,-cuda} kernel-devel-${KERNEL_VERSION} \
                       /tmp/nvidia/kmod-nvidia-${KERNEL_VERSION}-*.rpm && \
    ln -s /usr/bin/ld.bfd /etc/alternatives/ld && ln -s /etc/alternatives/ld /usr/bin/ld && \
    rm -rf /tmp/nvidia /var/* && \
    ostree container commit
