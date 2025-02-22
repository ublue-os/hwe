ARG IMAGE_NAME="${IMAGE_NAME:-silverblue}"
ARG SOURCE_IMAGE="${SOURCE_IMAGE:-silverblue-main}"
ARG SOURCE_ORG="${SOURCE_ORG:-ublue-os}"
ARG BASE_IMAGE="ghcr.io/${SOURCE_ORG}/${SOURCE_IMAGE}"
ARG FEDORA_MAJOR_VERSION="${FEDORA_MAJOR_VERSION:-40}"
ARG KERNEL_FLAVOR="${KERNEL_FLAVOR:-main}"
ARG KERNEL_VERSION="${KERNEL_VERSION:-6.9.7-200.fc40.x86_64}"

FROM ghcr.io/${SOURCE_ORG}/akmods-nvidia:${KERNEL_FLAVOR}-${FEDORA_MAJOR_VERSION} AS akmods_nvidia

FROM scratch AS ctx
COPY / /

FROM ${BASE_IMAGE}:${FEDORA_MAJOR_VERSION} AS main

ARG FEDORA_MAJOR_VERSION="${FEDORA_MAJOR_VERSION:-40}"
ARG KERNEL_FLAVOR="${KERNEL_FLAVOR:-main}"
ARG IMAGE_NAME="${IMAGE_NAME:-silverblue}"
ARG IMAGE_VENDOR="${IMAGE_VENDOR:-ublue-os}"
ARG KERNEL_VERSION="${KERNEL_VERSION:-6.9.7-200.fc40.x86_64}"

RUN --mount=type=cache,dst=/var/cache/rpm-ostree \
    --mount=type=bind,from=ctx,src=/,dst=/ctx \
    --mount=type=bind,from=akmods_nvidia,src=/kernel-rpms,dst=/tmp/kernel-rpms \
    mkdir -p /var/lib/alternatives && \
    IMAGE_FLAVOR=main /ctx/image-info.sh && \
    /ctx/install.sh && \
    mv /var/lib/alternatives /staged-alternatives && \
    /ctx/cleanup.sh && \
    ostree container commit && \
    mkdir -p /var/lib && mv /staged-alternatives /var/lib/alternatives && \
    mkdir -p /var/tmp && \
    chmod -R 1777 /var/tmp

FROM main AS nvidia

ARG SOURCE_ORG="${SOURCE_ORG:-ublue-os}"
ARG FEDORA_MAJOR_VERSION="${FEDORA_MAJOR_VERSION:-40}"
ARG KERNEL_FLAVOR="${KERNEL_FLAVOR:-main}"
ARG IMAGE_NAME="${IMAGE_NAME:-silverblue}"
ARG IMAGE_VENDOR="${IMAGE_VENDOR:-ublue-os}"

RUN --mount=type=cache,dst=/var/cache/rpm-ostree \
    --mount=type=bind,from=ctx,src=/,dst=/ctx \
    --mount=type=bind,from=akmods_nvidia,src=/rpms,dst=/tmp/akmods-rpms \
    mkdir -p /var/lib/alternatives && \
    if [ ! -x /usr/bin/dnf5 ]; then \
    rpm-ostree install --idempotent dnf5 dnf5-plugins && \
    dnf5 versionlock add kernel kernel-core kernel-modules kernel-modules-core kernel-modules-extra \
    ; fi && \
    IMAGE_FLAVOR=nvidia /ctx/image-info.sh && \
    NVIDIA_FLAVOR=nvidia /ctx/nvidia-install.sh && \
    /ctx/build-initramfs.sh && \
    mv /var/lib/alternatives /staged-alternatives && \
    /ctx/cleanup.sh && \
    ostree container commit && \
    mkdir -p /var/lib && mv /staged-alternatives /var/lib/alternatives && \
    mkdir -p /var/tmp && \
    chmod -R 1777 /var/tmp
