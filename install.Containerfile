ARG IMAGE_NAME="${IMAGE_NAME:-silverblue}"
ARG BASE_IMAGE="ghcr.io/ublue-os/${IMAGE_NAME}-extended"
ARG FEDORA_MAJOR_VERSION="${FEDORA_MAJOR_VERSION:-37}"

FROM ${BASE_IMAGE}:${FEDORA_MAJOR_VERSION}

ARG IMAGE_NAME="${IMAGE_NAME}"
ARG AKMODS_NVIDIA="ghcr.io/ublue-os/ublue-akmod-nvidia"
ARG AKMODS_VERSION="${FEDORA_MAJOR_VERSION:-37}"
ARG NVIDIA_MAJOR_VERSION="${NVIDIA_MAJOR_VERSION}"

COPY --from=${AKMODS_NVIDIA}:${AKMODS_VERSION}-${NVIDIA_MAJOR_VERSION} / .

ADD justfile-nvidia /tmp/justfile-nvidia
RUN cat /tmp/justfile-nvidia >> /usr/share/ublue-os/ublue-os-just/justfile

COPY install.sh /tmp/install.sh
COPY post-install.sh /tmp/post-install.sh
RUN /tmp/install.sh
RUN /tmp/post-install.sh
RUN rm -rf /tmp/* /var/*
RUN ostree container commit
RUN mkdir -p /var/tmp && chmod -R 1777 /tmp /var/tmp
