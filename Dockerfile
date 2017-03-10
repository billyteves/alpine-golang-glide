FROM billyteves/alpine:3.4.0

MAINTAINER Billy Ray Teves <billyteves@gmail.com>

ENV GOPATH	/go
ENV PATH 	$GOPATH/bin:/usr/local/go/bin:$PATH

ADD ./run-ssh /usr/local/bin/run-ssh

RUN apk update --no-cache \
    && apk upgrade --no-cache \
    && apk add --no-cache --virtual --update \

    # Install important apks 

    git \
    make \
    bzr \
    build-base \
    musl-dev \
    musl-utils \
    go \
    
    # Added Edge to Install Glide

    && mkdir -p /etc/apk \
    && echo "http://alpine.gliderlabs.com/alpine/v3.5/community" >> /etc/apk/repositories \
    && apk add --no-cache --virtual --update \
    glide \

    # Cleanup
    
    && rm -rf /var/cache/apk/* \
    && rm -rf /var/lib/apt/lists/* \
    && rm -rf /tmp/* \
    && chmod +x /usr/local/bin/run-ssh \

    # Make directories

    && mkdir -p $GOPATH/bin \
    && mkdir -p $GOPATH/src \

    # CHMOD

    && chmod -R 777 $GOPATH 

WORKDIR /go/src/app

