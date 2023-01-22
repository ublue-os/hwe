ARG FEDORA_MAJOR_VERSION='37'

FROM ghcr.io/ublue-os/base:${FEDORA_MAJOR_VERSION} AS builder
# See https://pagure.io/releng/issue/11047 for final location

ARG NVIDIA_VERSION='525.78.01'

RUN rpm-ostree install kmod gcc kernel-devel vulkan-loader binutils libglvnd-devel && \
    ostree container commit

RUN ln -fs /usr/bin/ld.bfd /usr/bin/ld
RUN mkdir -p /var/log
ADD build-nvidia.sh /build-nvidia.sh
RUN chmod +755 /build-nvidia.sh
RUN /build-nvidia.sh

RUN find /usr/{bin,lib,lib64,share} /etc/{systemd,vulkan,OpenCL} ! -type d -newerat "$(cat /.builddate)" \
    -exec install -D {} /build/{} \;

FROM ghcr.io/ublue-os/base:${FEDORA_MAJOR_VERSION}

COPY --from=builder /build /
RUN ostree container commit
