This repo contains a templated `Dockerfile` for image variants designed to run deployments using the AWS CLI and `terraform`.
## Usage

### Template Variables

- `TERRAFORM_VERSION` - Terraform version

## Build and Test Image
```bash
CI=1 REPOSITORY=756143471679.dkr.ecr.cn-north-1.amazonaws.com.cn TERRAFORM_VERSION=1.3.4 ./scripts/build.sh
```

## Publish Image to ECR
```bash
# You should have a repository named terraform created in ECR

export AWS_PROFILE=756143471679_UserFull

CI=1 REPOSITORY=756143471679.dkr.ecr.cn-north-1.amazonaws.com.cn TERRAFORM_VERSION=1.3.4 ./scripts/publish.sh
```

### Reference
- https://github.com/azavea/docker-terraform
- https://spacelift.io/blog/terraform-in-ci-cd
