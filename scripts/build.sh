#!/bin/bash

set -e
set -u

if [[ -n "${CI}" ]]; then
    set -x
fi

function usage() {
    echo -n \
        "Usage: $(basename "$0")
Build container images from templates.
"
}

if [[ "${BASH_SOURCE[0]}" == "$0" ]]; then
    if [[ "${1:-}" == "--help" ]]; then
        usage
    else

        sed -e "s/%%TERRAFORM_VERSION%%/${TERRAFORM_VERSION}/" \
            "Dockerfile.template" >Dockerfile

        docker build -t "${ECR_REGISTRY}/${ECR_REPOSITORY}:${TERRAFORM_VERSION}" .

        ./scripts/test.sh

        docker images | grep "${ECR_REGISTRY}/${ECR_REPOSITORY}"
    fi
fi
