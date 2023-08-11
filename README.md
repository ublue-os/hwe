# Nvidia

[![build-ublue](https://github.com/ublue-os/nvidia/actions/workflows/build.yml/badge.svg)](https://github.com/ublue-os/nvidia/actions/workflows/build.yml)

The purpose of these images is to provide [community Fedora images](https://github.com/ublue-os/main) with Nvidia drivers built-in. This approach can lead to greater reliability as failures can be caught at the build level instead of the client machine. This also allows for individual sets of images for each series of Nvidia drivers, allowing users to remain current with their OS but on an older, known working driver. Performance regression with a recent driver update? Reboot into a known-working driver after one command. That's the goal!

These images are based on the experimental ostree native container images hosted at [quay.io](https://quay.io/organization/fedora-ostree-desktops) ([repo](https://gitlab.com/fedora/ostree/ci-test)).

Note: This project is a work-in-progress. You should at a minimum be familiar with the [Fedora documentation](https://docs.fedoraproject.org/en-US/fedora-silverblue/) on how to administer an ostree system.

## Core image features:

- Multiple Nvidia driver streams (525xx, 520xx, and 470xx)
- CUDA support
- [Container runtime support](https://github.com/ublue-os/nvidia#using-nvidia-gpus-in-containers)
- Secure boot
- [Hardware-accelerated video playback](https://github.com/ublue-os/nvidia#video-playback)
- Selinux support
- [Multiple Fedora flavors and releases](https://github.com/ublue-os/nvidia#setup)
- Post-install setup with [`just`](https://github.com/ublue-os/config/blob/main/build/ublue-os-just/nvidia.just)
- Multi-GPU support with [`supergfxctl`](https://gitlab.com/asus-linux/supergfxctl) ([optional Gnome Shell extension](https://extensions.gnome.org/extension/5344/supergfxctl-gex/))

## Setup

### 0. Prepare to rebase

1. `rpm-ostree reset` will remove all your layered packages and prepare for rebasing. 
2. Rebase to an *unsigned* Universal Blue image, this will ensure that you have the proper keys and policies on your machine:

        rpm-ostree rebase ostree-unverified-registry:ghcr.io/ublue-os/silverblue-main

### 1. Rebase onto the image

Any system running `rpm-ostree` should be able to rebase onto one of the images built in this project:

Note: The image previously titled "nvidia" will not be updated anymore. If you wish to retain the same functionality, switch to "silverblue-nvidia".

[Silverblue (GNOME):](https://github.com/ublue-os/nvidia/pkgs/container/silverblue-nvidia)

    rpm-ostree rebase ostree-image-signed:docker://ghcr.io/ublue-os/silverblue-nvidia:latest


[Kinoite (KDE):](https://github.com/ublue-os/nvidia/pkgs/container/kinoite-nvidia)

    rpm-ostree rebase ostree-image-signed:docker://ghcr.io/ublue-os/kinoite-nvidia:latest
    
[LXQt (unofficial):](https://github.com/ublue-os/nvidia/pkgs/container/lxqt-nvidia)

    rpm-ostree rebase ostree-image-signed:docker://ghcr.io/ublue-os/lxqt-nvidia:latest

[MATE (unofficial):](https://github.com/ublue-os/nvidia/pkgs/container/mate-nvidia)

    rpm-ostree rebase ostree-image-signed:docker://ghcr.io/ublue-os/mate-nvidia:latest

[Vauxite (XFCE, unofficial):](https://github.com/ublue-os/nvidia/pkgs/container/vauxite-nvidia)

    rpm-ostree rebase ostree-image-signed:docker://ghcr.io/ublue-os/vauxite-nvidia:latest

[Sericea (Sway, unofficial as of Fedora 38):](https://github.com/ublue-os/nvidia/pkgs/container/sericea-nvidia)

Note: [The Sway session has some custom configuration options set to improve stability on Nvidia GPUs](https://github.com/ublue-os/nvidia/blob/main/files/etc/sway/environment)

    rpm-ostree rebase ostree-image-signed:docker://ghcr.io/ublue-os/sericea-nvidia:38

[Base (no DE preinstalled):](https://github.com/ublue-os/nvidia/pkgs/container/base-nvidia)

    rpm-ostree rebase ostree-image-signed:docker://ghcr.io/ublue-os/base-nvidia:latest

And then reboot.

### 2. Set kargs after rebasing

Setting kargs to disable nouveau and enabling nvidia early at boot is [currently not supported within container builds](https://github.com/coreos/rpm-ostree/issues/3738). They must be set after rebasing:

```
rpm-ostree kargs \
    --append=rd.driver.blacklist=nouveau \
    --append=modprobe.blacklist=nouveau \
    --append=nvidia-drm.modeset=1
```
And then reboot one more time!

### 3. Enable Secure Boot support
**IMPORTANT NOTE:** On June 17, 00:00 UTC, we changed the key used to sign nvidia kernel modules. If your nvidia kernel modules are not loading, you need to import the new key.

[Secure Boot](https://rpmfusion.org/Howto/Secure%20Boot) support for the nvidia kernel modules can be enabled by enrolling the signing key:

```
sudo mokutil --import /etc/pki/akmods/certs/akmods-ublue.der
```

Alternatively, the key can be enrolled from within this repo:

```
sudo mokutil --import ./certs/public_key.der
```

## Rolling back and rebasing

Generally you can [perform a rollback](https://docs.fedoraproject.org/en-US/fedora-silverblue/updates-upgrades-rollbacks/#rolling-back) with the following:

    rpm-ostree rollback

To rebase onto a specific date, use a date tag:

    rpm-ostree rebase ostree-image-signed:docker://ghcr.io/ublue-os/silverblue-nvidia:20230720

Or to rebase onto a specific release, driver, and date:

    rpm-ostree rebase ostree-image-signed:docker://ghcr.io/ublue-os/silverblue-nvidia:38-535-20230720
    
[More options for image tags can be found on the container catalog.](https://github.com/ublue-os/nvidia/pkgs/container/silverblue-nvidia/versions)
   
## Support

Note: The Fedora release and Nvidia version can be set with the image tag as well:

   |     | 535xx series (latest, best supported) | 530xx series (deprecated) | 470xx series (Kepler 2012-2014 support) |
   |-----|---------------------------------------|---------------------------|-----------------------------------------|
   | F37 | :37 / :37-535 / :37-current |                           | :37-470                                 |
   | F38 | :latest / :38 / :38-535 / :38-current           | :38-530                   | :38-470                                 |

It is *strongly encouraged* for you to subscribe to [the Nvidia driver announcements](https://github.com/orgs/ublue-os/discussions/categories/nvidia-driver-announcements?discussions_q=is%3Aopen+category%3A%22Nvidia+Driver+Announcements%22) section of the forums to keep up with the latest changes and news. 

- Drivers are provided by Nvidia and packaged by RPMFusion, therefore we cannot make any guarantees on support outside of the support these two organizations provide.
- Due to the nature of third party kernel modules, support for older versions is best effort.
- TLDR, we do the best we can but sometimes need to drop support depending on what's going with Nvidia, RPMFusion, Fedora, and the Linux kernel. 

## Verification

These images are signed with sigstore's [cosign](https://docs.sigstore.dev/cosign/overview/). You can verify the signature by downloading the `cosign.pub` key from this repo and running the following command:

    cosign verify --key cosign.pub ghcr.io/ublue-os/silverblue-nvidia
    
If you're forking this repo you should [read the docs](https://docs.github.com/en/actions/security-guides/encrypted-secrets) on keeping secrets in github. You need to [generate a new keypair](https://docs.sigstore.dev/cosign/overview/) with cosign. The public key can be in your public repo (your users need it to check the signatures), and you can paste the private key in Settings -> Secrets -> Actions with the name SIGNING_SECRET.

## Building locally

1. Build container

A container build can be invoked by simply running:

```
$ podman build \
    --file build.Containerfile \
    --tag build-test:latest
$ podman build \
    --file install.Containerfile \
    --tag install-test:latest
```

Or to specify the version of Fedora and/or Nvidia driver:

```
$ podman build \
    --build-arg IMAGE_NAME=silverblue \
    --build-arg FEDORA_MAJOR_VERSION=37 \
    --build-arg NVIDIA_MAJOR_VERSION=525 \
    --file build.Containerfile \
    --tag build-test:37-525

$ podman build \
    --build-arg IMAGE_NAME=silverblue \
    --build-arg FEDORA_MAJOR_VERSION=37 \
    --build-arg NVIDIA_MAJOR_VERSION=525 \
    --build-arg AKMODS_CACHE=build-test \
    --build-arg AKMODS_VERSION=37 \
    --file install.Containerfile \
    --tag build-test:latest
```

2. Generate signing keys

If you are forking this repo, then you should add a private key to the repository secrets:

```
$ ./generate-akmod-key
$ gh secret set AKMOD_PRIVKEY < certs/private_key.priv.prod
$ cp certs/public_key.der.prod certs/public_key.der
```

## Using Nvidia GPUs in containers

[There is support for enabling Nvidia GPUs in containers](https://www.redhat.com/en/blog/how-use-gpus-containers-bare-metal-rhel-8). This can can be verified by running the following:

```
$ podman run \
    --user 1000:1000 \
    --security-opt=no-new-privileges \
    --cap-drop=ALL \
    --security-opt label=type:nvidia_container_t  \
    docker.io/mirrorgooglecontainers/cuda-vector-add:v0.1
```

## Video playback

Additional runtime packages are added for enabling hardware-accelerated video playback. This can the enabled in Firefox (RPM or flatpak) by setting the following options to `true` in `about:config`:

* `gfx.webrender.all`
* `media.ffmpeg.vaapi.enabled`
* `widget.dmabuf.force-enabled`


Extensive host access and reduced sandboxing is needed for Firefox flatpak to use `/usr/lib64/dri/nvidia_drv_video.so`:

```
$ flatpak override \
    --user \
    --filesystem=host-os \
    --env=LIBVA_DRIVER_NAME=nvidia \
    --env=LIBVA_DRIVERS_PATH=/run/host/usr/lib64/dri \
    --env=LIBVA_MESSAGING_LEVEL=1 \
    --env=MOZ_DISABLE_RDD_SANDBOX=1 \
    --env=NVD_BACKEND=direct \
    --env=MOZ_ENABLE_WAYLAND=1 \
    org.mozilla.firefox
```

## Acknowledgements

Thanks to Alex Diaz for advice, and who got this working first, check out this repo:

- https://github.com/akdev1l/ostree-images

## [![Repography logo](https://images.repography.com/logo.svg)](https://repography.com) / Recent activity [![Time period](https://images.repography.com/35181738/ublue-os/nvidia/recent-activity/1c8ovnGsRhmILlhMg4JBeas3ii7RQ8RN5ETspwa_MKs/XClgd0l5PqadFLWZmE8aQN6H4DKSp1budGqJbeT1NN0_badge.svg)](https://repography.com)
[![Timeline graph](https://images.repography.com/35181738/ublue-os/nvidia/recent-activity/1c8ovnGsRhmILlhMg4JBeas3ii7RQ8RN5ETspwa_MKs/XClgd0l5PqadFLWZmE8aQN6H4DKSp1budGqJbeT1NN0_timeline.svg)](https://github.com/ublue-os/nvidia/commits)
[![Issue status graph](https://images.repography.com/35181738/ublue-os/nvidia/recent-activity/1c8ovnGsRhmILlhMg4JBeas3ii7RQ8RN5ETspwa_MKs/XClgd0l5PqadFLWZmE8aQN6H4DKSp1budGqJbeT1NN0_issues.svg)](https://github.com/ublue-os/nvidia/issues)
[![Pull request status graph](https://images.repography.com/35181738/ublue-os/nvidia/recent-activity/1c8ovnGsRhmILlhMg4JBeas3ii7RQ8RN5ETspwa_MKs/XClgd0l5PqadFLWZmE8aQN6H4DKSp1budGqJbeT1NN0_prs.svg)](https://github.com/ublue-os/nvidia/pulls)
[![Trending topics](https://images.repography.com/35181738/ublue-os/nvidia/recent-activity/1c8ovnGsRhmILlhMg4JBeas3ii7RQ8RN5ETspwa_MKs/XClgd0l5PqadFLWZmE8aQN6H4DKSp1budGqJbeT1NN0_words.svg)](https://github.com/ublue-os/nvidia/commits)
[![Top contributors](https://images.repography.com/35181738/ublue-os/nvidia/recent-activity/1c8ovnGsRhmILlhMg4JBeas3ii7RQ8RN5ETspwa_MKs/XClgd0l5PqadFLWZmE8aQN6H4DKSp1budGqJbeT1NN0_users.svg)](https://github.com/ublue-os/nvidia/graphs/contributors)
[![Activity map](https://images.repography.com/35181738/ublue-os/nvidia/recent-activity/1c8ovnGsRhmILlhMg4JBeas3ii7RQ8RN5ETspwa_MKs/XClgd0l5PqadFLWZmE8aQN6H4DKSp1budGqJbeT1NN0_map.svg)](https://github.com/ublue-os/nvidia/commits)

