# AWS CLI v2 in Docker image
[Relevant AWS docs](https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2-docker.html)

## Credentials

Below commands use credentials stored locally in ~/.aws

This folder is mounted to the docker container, so the credentials are accessible from there

## Configure

### One profile (not recommended)

`docker run --rm -it -v ~/.aws:/root/.aws amazon/aws-cli configure`

### Named profiles

`docker run --rm -it -v ~/.aws:/root/.aws amazon/aws-cli configure --profile PROFILE_NAME`

Note: change PROFILE_NAME to name of your profile

## Use

`alias aws='docker run --rm -it -v ~/.aws:/root/.aws -v $(pwd):/aws amazon/aws-cli --profile PROFILE_NAME'`

Note:

The alias will disappear after reboot.

To make it permanent, add it to ~/.bash_aliases
