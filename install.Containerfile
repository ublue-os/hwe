ARG IMAGE_NAME=silverblue
ARG BASE_IMAGE=ghcr.io/ublue-os/${IMAGE_NAME}-main
ARG FEDORA_MAJOR_VERSION=37

FROM ${BASE_IMAGE}:${FEDORA_MAJOR_VERSION}

ARG IMAGE_NAME="${IMAGE_NAME}"
ARG AKMODS_CACHE="ghcr.io/ublue-os/akmods-nvidia"
ARG AKMODS_VERSION="37"
ARG NVIDIA_MAJOR_VERSION="525"

COPY --from=${AKMODS_CACHE}:${AKMODS_VERSION}-${NVIDIA_MAJOR_VERSION} / .

COPY install.sh /tmp/install.sh
COPY post-install.sh /tmp/post-install.sh
RUN /tmp/install.sh
RUN /tmp/post-install.sh
RUN rm -rf /tmp/* /var/*
RUN ostree container commit
RUN mkdir -p /var/tmp && chmod -R 1777 /tmp /var/tmp
