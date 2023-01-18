ARG FEDORA_MAJOR_VERSION=37

FROM ghcr.io/ublue-os/base:${FEDORA_MAJOR_VERSION}
# See https://pagure.io/releng/issue/11047 for final location

RUN rpm-ostree install kmod gcc kernel-devel vulkan-loader binutils && \
    ostree container commit

RUN ln -fs /usr/bin/ld.bfd /usr/bin/ld

ADD build-nvidia.sh /build-nvidia.sh
RUN chmod +755 /build-nvidia.sh
RUN /build-nvidia.sh  

RUN ostree container commit
