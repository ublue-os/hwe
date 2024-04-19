ARG IMAGE_NAME="${IMAGE_NAME:-silverblue}"
ARG SOURCE_IMAGE="${SOURCE_IMAGE:-silverblue-main}"
ARG SOURCE_ORG="${SOURCE_ORG:-ublue-os}"
ARG BASE_IMAGE="ghcr.io/${SOURCE_ORG}/${SOURCE_IMAGE}"
ARG FEDORA_MAJOR_VERSION="${FEDORA_MAJOR_VERSION:-39}"

FROM ${BASE_IMAGE}:${FEDORA_MAJOR_VERSION} AS main

ARG FEDORA_MAJOR_VERSION="${FEDORA_MAJOR_VERSION:-39}"
ARG KERNEL_FLAVOR="{KERNEL_FLAVOR:-main}"
ARG IMAGE_NAME="${IMAGE_NAME:-silverblue}"
ARG IMAGE_VENDOR="${IMAGE_VENDOR:-ublue-os}"
ARG RPMFUSION_MIRROR=""

COPY *.sh /tmp/
COPY ${KERNEL_FLAVOR}/ /tmp/

RUN mkdir -p /var/lib/alternatives && \
    IMAGE_FLAVOR=main /tmp/image-info.sh && \
    /tmp/install.sh && \
    mv /var/lib/alternatives /staged-alternatives && \
    rm -rf /tmp/* /var/* && \
    ostree container commit && \
    mkdir -p /var/lib && mv /staged-alternatives /var/lib/alternatives && \
    mkdir -p /tmp /var/tmp && \
    chmod -R 1777 /tmp /var/tmp

FROM main AS nvidia

ARG SOURCE_ORG="${SOURCE_ORG:-ublue-os}"
ARG FEDORA_MAJOR_VERSION="${FEDORA_MAJOR_VERSION:-39}"
ARG KERNEL_FLAVOR="{KERNEL_FLAVOR:-main}"
ARG IMAGE_NAME="${IMAGE_NAME:-silverblue}"
ARG IMAGE_VENDOR="${IMAGE_VENDOR:-ublue-os}"
ARG RPMFUSION_MIRROR=""

COPY --from=ghcr.io/${SOURCE_ORG}/akmods-nvidia:${KERNEL_FLAVOR}-${FEDORA_MAJOR_VERSION} /rpms /tmp/akmods-rpms

COPY *.sh /tmp/

RUN mkdir -p /var/lib/alternatives && \
    IMAGE_FLAVOR=nvidia /tmp/image-info.sh && \
    /tmp/nvidia-install.sh && \
    mv /var/lib/alternatives /staged-alternatives && \
    rm -rf /tmp/* /var/* && \
    ostree container commit && \
    mkdir -p /var/lib && mv /staged-alternatives /var/lib/alternatives && \
    mkdir -p /tmp /var/tmp && \
    chmod -R 1777 /tmp /var/tmp
