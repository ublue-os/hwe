#!/usr/bin/env bash

set -oeux pipefail

readonly LANG="en_US.UTF-8"
readonly CERT_DIR=certs
readonly IMAGE="quay.io/fedora/fedora-coreos"
readonly TAG="stable"

mkdir -p "${PWD}/${CERT_DIR}"
rm -rf "${PWD}/${CERT_DIR}/*.prod"

# Bootstrap keys with a pre-existing image to avoid touching '/etc' or
# installing additional packages on host
podman run \
    --env="LANG=${LANG}" \
    --volume="${PWD}/${CERT_DIR}:/tmp/${CERT_DIR}" \
    --workdir="/tmp/${CERT_DIR}" \
    --entrypoint=/bin/sh \
    "${IMAGE}:${TAG}" -c \
    "rpm-ostree install langpacks-en akmods && \
     kmodgenca --auto && \
     cp /etc/pki/akmods/private/private_key.priv private_key.priv.prod && \
     cp /etc/pki/akmods/certs/public_key.der public_key.der.prod"

cp certs/public_key.der.prod certs/public_key.der