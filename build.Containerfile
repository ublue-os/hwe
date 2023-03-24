#Build from ublue/base, simpley because it's the smallest image
ARG IMAGE_NAME="${IMAGE_NAME:-base-main}"
ARG BASE_IMAGE="ghcr.io/ublue-os/${IMAGE_NAME}"
ARG FEDORA_MAJOR_VERSION="${FEDORA_MAJOR_VERSION:-37}"

FROM ${BASE_IMAGE}:${FEDORA_MAJOR_VERSION} AS builder

ARG NVIDIA_MAJOR_VERSION="${NVIDIA_MAJOR_VERSION:-525}"

COPY build.sh /tmp/build.sh

ADD certs /tmp/certs

ADD ublue-os-nvidia-addons.spec /tmp/ublue-os-nvidia-addons/ublue-os-nvidia-addons.spec

ADD https://nvidia.github.io/nvidia-docker/rhel9.0/nvidia-docker.repo \
    /tmp/ublue-os-nvidia-addons/rpmbuild/SOURCES/nvidia-container-runtime.repo

ADD https://nvidia.github.io/nvidia-docker/rhel9.0/nvidia-docker.repo \
    /etc/yum.repos.d/nvidia-container-runtime.repo

ADD files/etc/nvidia-container-runtime/config-rootless.toml \
    /tmp/ublue-os-nvidia-addons/rpmbuild/SOURCES/config-rootless.toml
ADD https://raw.githubusercontent.com/NVIDIA/dgx-selinux/master/bin/RHEL9/nvidia-container.pp \
    /tmp/ublue-os-nvidia-addons/rpmbuild/SOURCES/nvidia-container.pp
ADD files/etc/sway/environment /tmp/ublue-os-nvidia-addons/rpmbuild/SOURCES/environment

RUN /tmp/build.sh

FROM scratch

COPY --from=builder /var/cache /var/cache
COPY --from=builder /tmp/ublue-os-nvidia-addons /tmp/ublue-os-nvidia-addons
