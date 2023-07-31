#!/bin/bash

set -e
set -u

if [[ -n "${CI}" ]]; then
    set -x
fi

function usage() {
    echo -n \
        "Usage: $(basename "$0")
Publish container images built from templates.
"
}

if [[ "${BASH_SOURCE[0]}" == "$0" ]]; then
    if [[ "${1:-}" == "--help" ]]; then
        usage
    else
        aws ecr get-login-password \
            --region ${AWS_REGION} |
            docker login --username AWS --password-stdin ${ECR_REGISTRY}

        docker push "${ECR_REGISTRY}/${ECR_REPOSITORY}:${TERRAFORM_VERSION}"
    fi
fi
