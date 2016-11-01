FROM golang:1.6.3-alpine

MAINTAINER Billy Ray Teves <billyteves@gmail.com>

ADD ./run-ssh /usr/local/bin/run-ssh

RUN apk --update add --no-cache \
    curl \
    git \
    bash \
    bzr \
    openssh \
    openssl \
    make \
    && rm -rf /var/cache/apk/* \
    && rm -rf /var/lib/apt/lists/* \
    && chmod +x /usr/local/bin/run-ssh

WORKDIR /go/src/app

RUN curl https://glide.sh/get | sh

