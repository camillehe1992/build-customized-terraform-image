FROM alpine:3.14

ARG TERRAFORM_VERSION=1.3.4
ARG TFSEC_VERSION=0.59.0

ARG AWS_PROVIDER_VERSION=5.0.0
ARG ARCHIVE_PROVIDER_VERSION=2.3.0
ARG NULL_PROVIDER_VERSION=3.2.1
ARG LOCAL_PROVIDER_VERSION=2.4.0

ENV TF_PLUGIN_CACHE_DIR=${HOME}.terraform.d/plugin-cache

RUN apk add --no-cache --virtual .sig-check gnupg
RUN wget -O /usr/bin/tfsec https://github.com/aquasecurity/tfsec/releases/download/v${TFSEC_VERSION}/tfsec-linux-amd64 && chmod +x /usr/bin/tfsec
RUN wget https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip
RUN wget https://keybase.io/hashicorp/pgp_keys.asc
RUN gpg --import pgp_keys.asc
RUN gpg --fingerprint --list-signatures "HashiCorp Security" | grep -q "C874 011F 0AB4 0511 0D02  1055 3436 5D94 72D7 468F" || exit 1
RUN gpg --fingerprint --list-signatures "HashiCorp Security" | grep -q "34365D9472D7468F" || exit 1
RUN wget https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_SHA256SUMS
RUN wget https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_SHA256SUMS.sig
RUN gpg --verify terraform_${TERRAFORM_VERSION}_SHA256SUMS.sig terraform_${TERRAFORM_VERSION}_SHA256SUMS || exit 1
RUN sha256sum -c terraform_${TERRAFORM_VERSION}_SHA256SUMS 2>&1 | grep -q "terraform_${TERRAFORM_VERSION}_linux_amd64.zip: OK" || exit 1
RUN unzip terraform_${TERRAFORM_VERSION}_linux_amd64.zip -d /bin
RUN apk del .sig-check

# Install terraform providers
RUN mkdir -p ${TF_PLUGIN_CACHE_DIR}

# terraform-provider-aws
RUN wget https://releases.hashicorp.com/terraform-provider-aws/${AWS_PROVIDER_VERSION}/terraform-provider-aws_${AWS_PROVIDER_VERSION}_linux_amd64.zip
RUN mkdir -p ${TF_PLUGIN_CACHE_DIR}/registry.terraform.io/hashicorp/aws/${AWS_PROVIDER_VERSION}/linux_amd64
RUN unzip -o terraform-provider-aws_${AWS_PROVIDER_VERSION}_linux_amd64.zip -d ${TF_PLUGIN_CACHE_DIR}/registry.terraform.io/hashicorp/aws/${AWS_PROVIDER_VERSION}/linux_amd64

# terraform-provider-archive
RUN wget https://releases.hashicorp.com/terraform-provider-archive/${ARCHIVE_PROVIDER_VERSION}/terraform-provider-archive_${ARCHIVE_PROVIDER_VERSION}_linux_amd64.zip
RUN mkdir -p ${TF_PLUGIN_CACHE_DIR}/registry.terraform.io/hashicorp/archive/${ARCHIVE_PROVIDER_VERSION}/linux_amd64
RUN unzip -o terraform-provider-archive_${ARCHIVE_PROVIDER_VERSION}_linux_amd64.zip -d ${TF_PLUGIN_CACHE_DIR}/registry.terraform.io/hashicorp/archive/${ARCHIVE_PROVIDER_VERSION}/linux_amd64

# terraform-provider-null
RUN wget https://releases.hashicorp.com/terraform-provider-null/${NULL_PROVIDER_VERSION}/terraform-provider-null_${NULL_PROVIDER_VERSION}_linux_amd64.zip
RUN mkdir -p ${TF_PLUGIN_CACHE_DIR}/registry.terraform.io/hashicorp/null/${NULL_PROVIDER_VERSION}/linux_amd64
RUN unzip -o terraform-provider-null_${NULL_PROVIDER_VERSION}_linux_amd64.zip -d ${TF_PLUGIN_CACHE_DIR}/registry.terraform.io/hashicorp/null/${NULL_PROVIDER_VERSION}/linux_amd64

# terraform-provider-local
RUN wget https://releases.hashicorp.com/terraform-provider-local/${LOCAL_PROVIDER_VERSION}/terraform-provider-local_${LOCAL_PROVIDER_VERSION}_linux_amd64.zip
RUN mkdir -p ${TF_PLUGIN_CACHE_DIR}/registry.terraform.io/hashicorp/local/${LOCAL_PROVIDER_VERSION}/linux_amd64
RUN unzip -o terraform-provider-local_${LOCAL_PROVIDER_VERSION}_linux_amd64.zip -d ${TF_PLUGIN_CACHE_DIR}/registry.terraform.io/hashicorp/local/${LOCAL_PROVIDER_VERSION}/linux_amd64

RUN rm terraform*

# Install other tools
RUN apk add --no-cache \
    bash \
    jq \
    make \
    python3 \
    py-pip \
    zip \
    curl
RUN pip install awscli

ENTRYPOINT ["/bin/terraform"]

# ENTRYPOINT ["/bin/sh"]
