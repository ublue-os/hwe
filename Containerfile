ARG IMAGE_NAME="${IMAGE_NAME:-silverblue}"
ARG BASE_IMAGE="quay.io/fedora-ostree-desktops/${IMAGE_NAME}"
ARG FEDORA_MAJOR_VERSION="${FEDORA_MAJOR_VERSION:-37}"

FROM ${BASE_IMAGE}:${FEDORA_MAJOR_VERSION} AS builder

ARG NVIDIA_MAJOR_VERSION="${NVIDIA_MAJOR_VERSION:-525}"

RUN sed -i 's@enabled=1@enabled=0@g' /etc/yum.repos.d/fedora-{cisco-openh264,modular,updates-modular}.repo

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
        kernel-devel-$(rpm -q kernel --queryformat '%{VERSION}-%{RELEASE}.%{ARCH}')


# alternatives cannot create symlinks on its own during a container build
RUN ln -s /usr/bin/ld.bfd /etc/alternatives/ld && ln -s /etc/alternatives/ld /usr/bin/ld

ADD certs /tmp/certs

RUN [[ -s "/tmp/certs/private_key.priv" ]] || \
    echo "WARNING: Using test signing key. Run './generate-akmods-key' for production builds." && \
    cp /tmp/certs/private_key.priv{.test,} && \
    cp /tmp/certs/public_key.der{.test,}

RUN install -Dm644 /tmp/certs/public_key.der   /etc/pki/akmods/certs/public_key.der
RUN install -Dm644 /tmp/certs/private_key.priv /etc/pki/akmods/private/private_key.priv

# Either successfully build and install the kernel modules, or fail early with debug output
RUN NVIDIA_PACKAGE_NAME="$(cat /tmp/nvidia-package-name.txt)" \
    KERNEL_VERSION="$(rpm -q kernel --queryformat '%{VERSION}-%{RELEASE}.%{ARCH}')" \
    NVIDIA_VERSION="$(basename "$(rpm -q "xorg-x11-drv-$(cat /tmp/nvidia-package-name.txt)" --queryformat '%{VERSION}-%{RELEASE}')" ".fc$(rpm -E '%fedora')")" \
    && \
        echo $NVIDIA_VERSION && akmods --force --kernels "${KERNEL_VERSION}" --kmod "${NVIDIA_PACKAGE_NAME}" \
    && \
        modinfo /usr/lib/modules/${KERNEL_VERSION}/extra/${NVIDIA_PACKAGE_NAME}/nvidia{,-drm,-modeset,-peermem,-uvm}.ko.xz > /dev/null \
    || \
        (cat /var/cache/akmods/${NVIDIA_PACKAGE_NAME}/${NVIDIA_VERSION}-for-${KERNEL_VERSION}.failed.log && exit 1)

ADD ublue-os-nvidia-addons.spec /tmp/ublue-os-nvidia-addons/ublue-os-nvidia-addons.spec

ADD https://nvidia.github.io/nvidia-docker/rhel9.0/nvidia-docker.repo \
    /tmp/ublue-os-nvidia-addons/rpmbuild/SOURCES/nvidia-container-runtime.repo

RUN sed -i "s@gpgcheck=0@gpgcheck=1@" /tmp/ublue-os-nvidia-addons/rpmbuild/SOURCES/nvidia-container-runtime.repo

ADD files/etc/nvidia-container-runtime/config-rootless.toml \
    /tmp/ublue-os-nvidia-addons/rpmbuild/SOURCES/config-rootless.toml
ADD https://raw.githubusercontent.com/NVIDIA/dgx-selinux/master/bin/RHEL9/nvidia-container.pp \
    /tmp/ublue-os-nvidia-addons/rpmbuild/SOURCES/nvidia-container.pp
ADD files/etc/sway/environment /tmp/ublue-os-nvidia-addons/rpmbuild/SOURCES/environment

RUN install -D /etc/pki/akmods/certs/public_key.der /tmp/ublue-os-nvidia-addons/rpmbuild/SOURCES/public_key.der

RUN rpmbuild -ba \
    --define '_topdir /tmp/ublue-os-nvidia-addons/rpmbuild' \
    --define '%_tmppath %{_topdir}/tmp' \
    /tmp/ublue-os-nvidia-addons/ublue-os-nvidia-addons.spec


RUN cp /tmp/nvidia-package-name.txt /var/cache/akmods/nvidia-package-name.txt
RUN echo "${NVIDIA_MAJOR_VERSION}" > /var/cache/akmods/nvidia-major-version.txt
RUN rpm -q "xorg-x11-drv-$(cat /tmp/nvidia-package-name.txt)" \
    --queryformat '%{EPOCH}:%{VERSION}-%{RELEASE}.%{ARCH}' > /var/cache/akmods/nvidia-full-version.txt

FROM ${BASE_IMAGE}:${FEDORA_MAJOR_VERSION}

ARG IMAGE_NAME="${IMAGE_NAME}"

COPY --from=builder /var/cache/akmods /tmp/akmods
COPY --from=builder /tmp/ublue-os-nvidia-addons /tmp/ublue-os-nvidia-addons

RUN sed -i 's@enabled=1@enabled=0@g' /etc/yum.repos.d/fedora-{cisco-openh264,modular,updates-modular}.repo

RUN install -D /tmp/ublue-os-nvidia-addons/rpmbuild/SOURCES/nvidia-container-runtime.repo \
    /etc/yum.repos.d/nvidia-container-runtime.repo

RUN KERNEL_VERSION="$(rpm -q kernel --queryformat '%{VERSION}-%{RELEASE}.%{ARCH}')" \
    NVIDIA_FULL_VERSION="$(cat /tmp/akmods/nvidia-full-version.txt)" \
    NVIDIA_PACKAGE_NAME="$(cat /tmp/akmods/nvidia-package-name.txt)" \
    && \
        rpm-ostree install \
            https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm \
            https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm \
    && \
        rpm-ostree install \
            xorg-x11-drv-${NVIDIA_PACKAGE_NAME}-{,cuda-,devel-,kmodsrc-,power-}${NVIDIA_FULL_VERSION} \
            kernel-devel-${KERNEL_VERSION} nvidia-container-toolkit \
            "/tmp/akmods/${NVIDIA_PACKAGE_NAME}/kmod-${NVIDIA_PACKAGE_NAME}-${KERNEL_VERSION}-${NVIDIA_FULL_VERSION#*:}.rpm" \
            /tmp/ublue-os-nvidia-addons/rpmbuild/RPMS/noarch/ublue-os-nvidia-addons-*.rpm \
    && \
        rpm-ostree override remove $(rpm -qa --queryformat='%{NAME} ' \
            mesa-va-drivers \
            libavutil-free \
            libswscale-free \
            libswresample-free \
            libavformat-free \
            libavcodec-free \
            libavfilter-free \
            libavdevice-free \
            libpostproc-free) \
            --install=mesa-va-drivers-freeworld \
            --install=mesa-vdpau-drivers-freeworld \
            --install=libva-intel-driver \
            --install=nvtop \
            --install=nvidia-vaapi-driver \
            --install=ffmpeg-libs \
            --install=ffmpeg \
            --install=libavcodec-freeworld \
            --install=libva-utils \
    && \
        mv /etc/nvidia-container-runtime/config.toml{,.orig} && \
        cp /etc/nvidia-container-runtime/config{-rootless,}.toml \
    && \
        semodule --verbose --install /usr/share/selinux/packages/nvidia-container.pp \
    && \
        sed -i 's@enabled=1@enabled=0@g' /etc/yum.repos.d/rpmfusion-{,non}free{,-updates}.repo \
    && \
        ln -s /usr/bin/ld.bfd /etc/alternatives/ld && \
        ln -s /etc/alternatives/ld /usr/bin/ld \
    && \
       ([[ "${IMAGE_NAME}" == "sericea" ]] && \
       mv /etc/sway/environment{,.orig} && \
       install -Dm644 /usr/share/ublue-os/etc/sway/environment /etc/sway/environment) ||: \
    && \
        rm -rf \
            /tmp/* \
            /var/* \
    && \
        ostree container commit \
    && \
        mkdir -p /var/tmp && \
        chmod -R 1777 /var/tmp
