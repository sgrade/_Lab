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

Note: change PROFILE_NAME to the name of your profile

## Use

### Alias
Below alias allows using simple 'aws' instead of the long string with default profile.

`alias aws='docker run --rm -it -v ~/.aws:/root/.aws -v $(pwd):/aws amazon/aws-cli'`

Same with named profile.

`alias aws='docker run --rm -it -v ~/.aws:/root/.aws -v $(pwd):/aws -e AWS_PROFILE amazon/aws-cli'`

Note: The alias will disappear after reboot.
To make it permanent, add it to:
- bash: ~/.bash_aliases [how-to](https://bash.cyberciti.biz/guide/~/.bash_aliases)
- zsh: ~/.zshrc

### Profile

"By default, the SDK checks the AWS_PROFILE environment variable to determine which profile to use. If no AWS_PROFILE variable is set, the SDK uses the default profile."
[Source](https://docs.aws.amazon.com/sdk-for-go/v1/developer-guide/configuring-sdk.html)

`export AWS_PROFILE=PROFILE_NAME`

Note: change PROFILE_NAME to the name of your profile

### Test if your setup works

`aws ec2 describe-instances`

