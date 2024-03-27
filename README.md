# HWE

[![build-38](https://github.com/ublue-os/hwe/actions/workflows/build-38.yml/badge.svg)](https://github.com/ublue-os/hwe/actions/workflows/build-38.yml) [![build-39](https://github.com/ublue-os/hwe/actions/workflows/build-39.yml/badge.svg)](https://github.com/ublue-os/hwe/actions/workflows/build-39.yml)

The purpose of these images is to provide [community Fedora images](https://github.com/ublue-os/main) with hardware enablement (ASUS and Surface) and Nvidia. This approach can lead to greater reliability as failures can be caught at the build level instead of the client machine. This also allows for individual sets of images for each series of Nvidia drivers, allowing users to remain current with their OS but on an older, known working driver. Performance regression with a recent driver update? Reboot into a known-working driver after one command. That's the goal!

# Documentation

- [Main website and documentation](https://universal-blue.org)
- [Documentation for these images](https://universal-blue.org/images/)
- [Installation](https://universal-blue.org/installation/) - follow this for clean installation
- [Rebase instructions](https://universal-blue.org/images/) - follow this if you want to switch to another image.
