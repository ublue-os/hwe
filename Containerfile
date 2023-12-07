ARG IMAGE_NAME="${IMAGE_NAME:-silverblue}"
ARG BASE_IMAGE="ghcr.io/ublue-os/${IMAGE_NAME}-asus"
ARG FEDORA_MAJOR_VERSION="${FEDORA_MAJOR_VERSION:-39}"

FROM ${BASE_IMAGE}:${FEDORA_MAJOR_VERSION} AS asus-nvidia

ARG IMAGE_NAME="${IMAGE_NAME:-silverblue}"
ARG IMAGE_VENDOR="ublue-os"
ARG IMAGE_FLAVOR="${IMAGE_FLAVOR:-nvidia}"
ARG FEDORA_MAJOR_VERSION="${FEDORA_MAJOR_VERSION:-39}"
ARG NVIDIA_MAJOR_VERSION="${NVIDIA_MAJOR_VERSION:-545}"

COPY image-info.sh /tmp/image-info.sh
COPY install.sh /tmp/install.sh
COPY post-install.sh /tmp/post-install.sh

COPY --from=ghcr.io/ublue-os/akmods-nvidia:asus-${FEDORA_MAJOR_VERSION}-${NVIDIA_MAJOR_VERSION} /rpms /tmp/akmods-rpms

RUN /tmp/image-info.sh && \
    /tmp/install.sh && \
    /tmp/post-install.sh && \
    rm -rf /tmp/* /var/*

RUN ostree container commit && \
    mkdir -p /var/tmp && chmod -R 1777 /tmp /var/tmp
