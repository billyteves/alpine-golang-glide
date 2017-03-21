FROM billyteves/alpine:3.5.0

MAINTAINER Billy Ray Teves <billyteves@gmail.com>

ENV GOLANG_VERSION      1.7.5
ENV GOLANG_SRC_URL      https://golang.org/dl/go$GOLANG_VERSION.src.tar.gz
ENV GOLANG_SRC_SHA256   4e834513a2079f8cbbd357502cccaac9507fd00a1efe672375798858ff291815
ENV GOPATH              /go
ENV PATH                $GOPATH/bin:/usr/local/go/bin:$PATH

# ssh for glide
COPY ./run-ssh /usr/local/bin/run-ssh

# Copy all the patch files
# ./patch-files/no-pic.patch https://golang.org/issue/14851
# ./patch-files/17847.patch https://golang.org/issue/17847
COPY ./patch-files /

RUN set -ex \
    && apk add --no-cache ca-certificates \
    && apk update --no-cache \
    && apk upgrade --no-cache \
    && apk add --no-cache --virtual --update .build-deps \

    # Install important apks

    git \
    make \
    gcc \
    musl-dev \

    # Compile Golang 1.7.5 and cleanup

    && export GOROOT_BOOTSTRAP="$(go env GOROOT)" \
    && curl -L "$GOLANG_SRC_URL" > golang.tar.gz \
    && echo "$GOLANG_SRC_SHA256  golang.tar.gz" | sha256sum -c - \
    && tar -C /usr/local -xzf golang.tar.gz \
    && rm golang.tar.gz \
    && cd /usr/local/go/src \
    && patch -p2 -i /no-pic.patch \
    && patch -p2 -i /17847.patch \
    && ./make.bash \
    && rm -rf /*.patch \
    && apk del .build-deps \

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
