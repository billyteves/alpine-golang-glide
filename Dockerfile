FROM golang:1.6.3-alpine

MAINTAINER Billy Ray Teves <billyteves@gmail.com>

RUN apk --update add --no-cache curl \
    rm -rf /var/cache/apk/*

WORKDIR /go/src/app

RUN curl https://glide.sh/get | sh
