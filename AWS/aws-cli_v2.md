
Mount local folder, so "configure" can store credentials in there

docker run --rm -it -v ~/.aws:/root/.aws amazon/aws-cli configure

alias aws='docker run --rm -it -v ~/.aws:/root/.aws -v $(pwd):/aws amazon/aws-cli'
