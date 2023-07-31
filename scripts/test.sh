#!/bin/bash

set -e
set -u

if [[ -n "${CI}" ]]; then
    set -x
fi

function usage() {
    echo -n \
        "Usage: $(basename "$0")
Test container images built from templates.
"
}

if [[ "${BASH_SOURCE[0]}" == "$0" ]]; then
    if [[ "${1:-}" == "--help" ]]; then
        usage
    else
        docker \
            run --rm "${REPOSITORY}/terraform:${TERRAFORM_VERSION}" --version

        docker \
            run --rm --entrypoint aws "${REPOSITORY}/terraform:${TERRAFORM_VERSION}" --version
    fi
fi
