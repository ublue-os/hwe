# nvidia

A layer to build Nvidia drivers for consumption by other images.

Note: This project is a work-in-progress.

## Setup

1) Rebase onto the image

Any system running `rpm-ostree` should be able to rebase onto [one of the images built in this project](https://github.com/ublue-os/nvidia/actions?query=workflow%3Abuild-ublue+is%3Asuccess):

```
$ TAG="pr-1"
$ rpm-ostree rebase ghcr.io/ublue-os/nvidia:${TAG}
```

2) Set kargs after rebasing

Setting kargs for disable nouveau and enabling nvidia early at boot is [currently not supported within container builds](https://github.com/coreos/rpm-ostree/issues/3738). They must be set after rebasing:

```
$ rpm-ostree kargs \
    --append=rd.driver.blacklist=nouveau \
    --append=modprobe.blacklist=nouveau \
    --append=nvidia-drm.modeset=1
```
