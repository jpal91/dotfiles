# Dockerfile to test environment setup correctly

FROM ubuntu:jammy

ENV DOCKER_TEST="true"
WORKDIR /.dotfiles

RUN \
  apt update -y && apt upgrade -y; 

RUN \
  apt install -y musl-dev; \
  apt install -y curl \
  gcc \
  git \
  build-essential

CMD ["/bin/bash"]

# docker run -it --rm -v ~/.dotfiles/:/.dotfiles/ fresh
