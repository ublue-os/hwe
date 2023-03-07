# nvidia

[![build-ublue](https://github.com/ublue-os/nvidia/actions/workflows/build.yml/badge.svg)](https://github.com/ublue-os/nvidia/actions/workflows/build.yml)

The purpose of these images is to provide builds of vanilla Fedora with Nvidia drivers built-in. This approach can lead to greater reliability as failures can be caught at the build level instead of the client machine. This also lets us generate individual sets of images for each series of Nvidia drivers, allowing users to remain current with their OS but on an older, known working driver. Performance regression with a recent driver update? Reboot into a known-working driver after one command. That's the goal!

These images are based on the experimental ostree native container images hosted at [quay.io](https://quay.io/organization/fedora-ostree-desktops) ([repo](https://gitlab.com/fedora/ostree/ci-test)).

Note: This project is a work-in-progress. You should at a minimum be familiar with the [Fedora documentation](https://docs.fedoraproject.org/en-US/fedora-silverblue/) on how to administer an ostree system. This is currently for people who want to help figure this out, so there may be explosions and gnashing of teeth. 

## Setup

1. Rebase onto the image

   Any system running `rpm-ostree` should be able to rebase onto one of the images built in this project:

   Note: The image previously titled "nvidia" will not be updated anymore. If you wish to retain the same functionality, switch to "silverblue-nvidia".

    [Silverblue (GNOME):](https://github.com/ublue-os/nvidia/pkgs/container/silverblue-nvidia)
    ```
    rpm-ostree rebase ostree-unverified-registry:ghcr.io/ublue-os/silverblue-nvidia:latest
    ```

    [Kinoite (KDE):](https://github.com/ublue-os/nvidia/pkgs/container/kinoite-nvidia)
    ```
    rpm-ostree rebase ostree-unverified-registry:ghcr.io/ublue-os/kinoite-nvidia:latest
    ```
    
    [LXQt:](https://github.com/ublue-os/nvidia/pkgs/container/lxqt-nvidia)
    ```
    rpm-ostree rebase ostree-unverified-registry:ghcr.io/ublue-os/lxqt-nvidia:latest
    ```
    [MATE:](https://github.com/ublue-os/nvidia/pkgs/container/mate-nvidia)
    ```
    rpm-ostree rebase ostree-unverified-registry:ghcr.io/ublue-os/mate-nvidia:latest
    ```

    [Vauxite (XFCE, unofficial):](https://github.com/ublue-os/nvidia/pkgs/container/vauxite-nvidia)
    ```
    rpm-ostree rebase ostree-unverified-registry:ghcr.io/ublue-os/vauxite-nvidia:latest
    ```

    [Sericea (Sway, unofficial as of Fedora 38):](https://github.com/ublue-os/nvidia/pkgs/container/sericea-nvidia)

    Note: [The Sway session has some custom configuration options set to improve stability on Nvidia GPUs](https://github.com/ublue-os/nvidia/blob/main/files/etc/sway/environment)

    ```
    rpm-ostree rebase ostree-unverified-registry:ghcr.io/ublue-os/sericea-nvidia:38
    ```

    [Base (no DE preinstalled):](https://github.com/ublue-os/nvidia/pkgs/container/base-nvidia)
    ```
    rpm-ostree rebase ostree-unverified-registry:ghcr.io/ublue-os/base-nvidia:latest
    ```

   And then reboot.

   Note: The Fedora release and Nvidia version can be set with the image tag as well:

   |     | 525xx series                          | 520xx series  | 470xx series (Kepler 2012-2014 support) |
   |-----|---------------------------------------|---------------|-----------------------------------------|
   | F37 | :latest / :37 / :37-525 / :37-current | :37-520       | :37-470                                 |
   | F38 | :38 / :38-525 / :38-current           |               |                                         |

2. Set kargs after rebasing

   Setting kargs to disable nouveau and enabling nvidia early at boot is [currently not supported within container builds](https://github.com/coreos/rpm-ostree/issues/3738). They must be set after rebasing:

```
rpm-ostree kargs \
    --append=rd.driver.blacklist=nouveau \
    --append=modprobe.blacklist=nouveau \
    --append=nvidia-drm.modeset=1
```
   And then reboot one more time!

3. Enable Secure Boot support

    [Secure Boot](https://rpmfusion.org/Howto/Secure%20Boot) support for the nvidia kernel modules can be enabled by enrolling the signing key:

```
sudo mokutil --import /etc/pki/akmods/certs/akmods-nvidia.der
```

Alternatively, the key can be enrolled from within this repo:

```
sudo mokutil --import ./certs/public_key.der
```

## Rolling back and rebasing

   Generally you can [perform a rollback](https://docs.fedoraproject.org/en-US/fedora-silverblue/updates-upgrades-rollbacks/#rolling-back) with the following:

       rpm-ostree rollback

   To rebase onto a specific date, use a date tag:

       rpm-ostree rebase ostree-unverified-registry:ghcr.io/ublue-os/silverblue-nvidia:20230128

   Or to rebase onto a specific release, driver, and date:

       rpm-ostree rebase ostree-unverified-registry:ghcr.io/ublue-os/silverblue-nvidia:37-525-20230128

   [More options for image tags can be found on the container catalog.](https://github.com/ublue-os/nvidia/pkgs/container/silverblue-nvidia/versions)

 ## Verification

These images are signed with sisgstore's [cosign](https://docs.sigstore.dev/cosign/overview/). You can verify the signature by downloading the `cosign.pub` key from this repo and running the following command:

    cosign verify --key cosign.pub ghcr.io/ublue-os/base
    
If you're forking this repo you should [read the docs](https://docs.github.com/en/actions/security-guides/encrypted-secrets) on keeping secrets in github. You need to [generate a new keypair](https://docs.sigstore.dev/cosign/overview/) with cosign. The public key can be in your public repo (your users need it to check the signatures), and you can paste the private key in Settings -> Secrets -> Actions with the name SIGNING_SECRET.

## Building locally

1. Build container

A container build can be invoked by simply running:

```
$ podman build \
    --file Containerfile \
    --tag build-test:latest
```

Or to specify the version of Fedora and/or Nvidia driver:

```
$ podman build \
    --build-arg IMAGE_NAME=silverblue \
    --build-arg FEDORA_MAJOR_VERSION=37 \
    --build-arg NVIDIA_MAJOR_VERSION=525 \
    --file Containerfile \
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
    org.mozilla.firefox
```

## Acknowledgements

Thanks to Alex Diaz for advice, and who got this working first, check out this repo:

- https://github.com/akdev1l/ostree-images
