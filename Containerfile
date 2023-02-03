ARG BASE_IMAGE='quay.io/fedora-ostree-desktops/silverblue'
ARG FEDORA_MAJOR_VERSION="${FEDORA_MAJOR_VERSION:-37}"

FROM ${BASE_IMAGE}:${FEDORA_MAJOR_VERSION} AS builder

ARG NVIDIA_MAJOR_VERSION="${NVIDIA_MAJOR_VERSION:-525}"

RUN sed -i 's@enabled=1@enabled=0@g' /etc/yum.repos.d/fedora-{cisco-openh264,modular,updates-modular,updates-archive}.repo

RUN rpm-ostree install \
        https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm \
        fedora-repos-archive

# nvidia 520.xxx and newer currently don't have a -$VERSIONxx suffix in their
# package names
RUN if [ "${NVIDIA_MAJOR_VERSION}" -ge 520 ]; then echo "nvidia"; else echo "nvidia-${NVIDIA_MAJOR_VERSION}xx"; fi > /tmp/nvidia-package-name.txt

RUN rpm-ostree install \
        akmods \
        mock \
        xorg-x11-drv-$(cat /tmp/nvidia-package-name.txt)-{,cuda,devel,kmodsrc,power}*:${NVIDIA_MAJOR_VERSION}.*.fc$(rpm -E '%fedora.%_arch')  \
        binutils \
        kernel-devel-$(rpm -qa kernel --queryformat '%{VERSION}-%{RELEASE}.%{ARCH}')


# alternatives cannot create symlinks on its own during a container build
RUN ln -s /usr/bin/ld.bfd /etc/alternatives/ld && ln -s /etc/alternatives/ld /usr/bin/ld

ADD certs/public_key.der   /etc/pki/akmods/certs/public_key.der
ADD certs/private_key.priv /etc/pki/akmods/private/private_key.priv

RUN chmod 644 /etc/pki/akmods/{private/private_key.priv,certs/public_key.der}

# Either successfully build and install the kernel modules, or fail early with debug output
RUN NVIDIA_PACKAGE_NAME="$(cat /tmp/nvidia-package-name.txt)" \
    KERNEL_VERSION="$(rpm -qa kernel --queryformat '%{VERSION}-%{RELEASE}.%{ARCH}')" \
    && \
        akmods --force --kernels "${KERNEL_VERSION}" --kmod "${NVIDIA_PACKAGE_NAME}" \
    && \
        [ -f "/usr/lib/modules/${KERNEL_VERSION}/extra/${NVIDIA_PACKAGE_NAME}/nvidia.ko.xz" ] \
    || \
        (cat /var/cache/akmods/${NVIDIA_PACKAGE_NAME}/${NVIDIA_MAJOR_VERSION}.*-for-${KERNEL_VERSION}.failed.log && exit 1)

ADD akmods-nvidia-key.spec /tmp/akmods-nvidia-key/akmods-nvidia-key.spec

RUN install -D /etc/pki/akmods/certs/public_key.der /tmp/akmods-nvidia-key/rpmbuild/SOURCES/public_key.der

RUN rpmbuild -ba \
    --define '_topdir /tmp/akmods-nvidia-key/rpmbuild' \
    --define '%_tmppath %{_topdir}/tmp' \
    /tmp/akmods-nvidia-key/akmods-nvidia-key.spec


RUN cp /tmp/nvidia-package-name.txt /var/cache/akmods/nvidia-package-name.txt
RUN echo "${NVIDIA_MAJOR_VERSION}" > /var/cache/akmods/nvidia-major-version.txt


FROM ${BASE_IMAGE}:${FEDORA_MAJOR_VERSION}

COPY --from=builder /var/cache/akmods     /tmp/akmods
COPY --from=builder /tmp/akmods-nvidia-key /tmp/akmods-nvidia-key


RUN KERNEL_VERSION="$(rpm -qa kernel --queryformat '%{VERSION}-%{RELEASE}.%{ARCH}')" \
    NVIDIA_MAJOR_VERSION="$(cat /tmp/akmods/nvidia-major-version.txt)" \
    NVIDIA_PACKAGE_NAME="$(cat /tmp/akmods/nvidia-package-name.txt)" \
    && \
        rpm-ostree install \
            https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm \
            https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm \
    && \
        rpm-ostree install \
            xorg-x11-drv-${NVIDIA_PACKAGE_NAME}-{,cuda,devel,kmodsrc,power}*:${NVIDIA_MAJOR_VERSION}.*.fc$(rpm -E '%fedora.%_arch') \
            kernel-devel-${KERNEL_VERSION} \
            /tmp/akmods/${NVIDIA_PACKAGE_NAME}/kmod-${NVIDIA_PACKAGE_NAME}-${KERNEL_VERSION}-*.rpm \
            /tmp/akmods-nvidia-key/rpmbuild/RPMS/noarch/akmods-nvidia-key-*.rpm \
    && \
        ln -s /usr/bin/ld.bfd /etc/alternatives/ld && \
        ln -s /etc/alternatives/ld /usr/bin/ld \
    && \
        rm -rf \
            /tmp/* \
            /var/* \
    && \
        ostree container commit
