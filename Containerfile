ARG BASE_IMAGE='quay.io/fedora-ostree-desktops/base'
ARG FEDORA_MAJOR_VERSION='37'

FROM ${BASE_IMAGE}:${FEDORA_MAJOR_VERSION} AS builder
# See https://pagure.io/releng/issue/11047 for final location

ARG NVIDIA_VERSION='525.78.01'

RUN rpm-ostree install kmod gcc vulkan-loader binutils libglvnd-devel \
    kernel-devel-$(rpm -q kernel-core '--queryformat=%{VERSION}-%{RELEASE}.%{ARCH}') && \
    ostree container commit

RUN ln -fs /usr/bin/ld.bfd /usr/bin/ld
RUN mkdir -p /var/log

ADD build-nvidia.sh /build-nvidia.sh
RUN chmod +755 /build-nvidia.sh

RUN /build-nvidia.sh

FROM ${BASE_IMAGE}:${FEDORA_MAJOR_VERSION}

COPY --from=builder /build /
RUN ostree container commit
