default:
    @just --list

set-kargs:
    rpm-ostree kargs \
        --append=rd.driver.blacklist=nouveau \
        --append=modprobe.blacklist=nouveau \
        --append=nvidia-drm.modeset=1

enroll-secure-boot-key:
    sudo mokutil --import /etc/pki/akmods/certs/akmods-nvidia.der

test-cuda:
    podman run \
        --user 1000:1000 \
        --security-opt=no-new-privileges \
        --cap-drop=ALL \
        --security-opt label=type:nvidia_container_t  \
        docker.io/mirrorgooglecontainers/cuda-vector-add:v0.1

setup-firefox-flatpak-vaapi:
    flatpak override \
        --user \
        --filesystem=host-os \
        --env=LIBVA_DRIVER_NAME=nvidia \
        --env=LIBVA_DRIVERS_PATH=/run/host/usr/lib64/dri \
        --env=LIBVA_MESSAGING_LEVEL=1 \
        --env=MOZ_DISABLE_RDD_SANDBOX=1 \
        --env=NVD_BACKEND=direct \
        org.mozilla.firefox
