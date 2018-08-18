FROM alpine:3.8

MAINTAINER Billy Ray Teves <billyteves@gmail.com>

ENV GOLANG_VERSION      1.10.3
ENV GOLANG_SRC_URL      https://golang.org/dl/go$GOLANG_VERSION.src.tar.gz
ENV GOLANG_SRC_SHA256   567b1cc66c9704d1c019c50bef946272e911ec6baf244310f87f4e678be155f2
ENV GOPATH              /go
ENV PATH                $GOPATH/bin:/usr/local/go/bin:$PATH

# ssh for glide
COPY ./run-ssh /usr/local/bin/run-ssh
RUN set -ex \
    && apk add --no-cache ca-certificates \
    && apk update --no-cache \
    && apk upgrade --no-cache \
    && apk add --no-cache --virtual .build-deps \
    # Install important apks for building go
    make \
    gcc \
    musl-dev \
    go \
    curl \
    bash \
    # Compile Golang and cleanup
    && export GOROOT_BOOTSTRAP="$(go env GOROOT)" \
    && curl -L "$GOLANG_SRC_URL" > golang.tar.gz \
    && echo "$GOLANG_SRC_SHA256  golang.tar.gz" | sha256sum -c - \
    && tar -C /usr/local -xzf golang.tar.gz \
    && rm golang.tar.gz \
    && cd /usr/local/go/src \
    && ./make.bash \
    && apk del .build-deps \
    # Install needed apks
    && apk add --no-cache --virtual --update \
    git \
    make \
    glide \
    tzdata \
    # Make directories
    && mkdir -p $GOPATH/bin \
    && mkdir -p $GOPATH/src \
    # CHMOD
    && chmod -R 777 $GOPATH \
    && chmod +x /usr/local/bin/run-ssh \
    # Cleanup
    && rm -rf /var/cache/apk/* \
    && rm -rf /var/lib/apt/lists/* \
    && rm -rf /tmp/*
WORKDIR /go/src/app
