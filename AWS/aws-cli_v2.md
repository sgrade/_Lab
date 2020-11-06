# AWS CLI v2 in Docker image
[AWS CLI version 2 Docker](https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2-docker.html)

## credentials

In below commands the credentials stored locally in ~/.aws

and mounted to the docker container, so they are accessible from there

## Configure

### One profile (not recommended)

`docker run --rm -it -v ~/.aws:/root/.aws amazon/aws-cli configure`

### Named profiles

`docker run --rm -it -v ~/.aws:/root/.aws amazon/aws-cli configure --profile PROFILE_NAME`

Note: change PROFILE_NAME to name of your profile

## Use

`alias aws='docker run --rm -it -v ~/.aws:/root/.aws -v $(pwd):/aws amazon/aws-cli --profile PROFILE_NAME'`
