FROM billyteves/alpine:latest

MAINTAINER Billy Ray Teves <billyteves@gmail.com>

ENV GOPATH	/go
ENV PATH 	$GOPATH/bin:/usr/local/go/bin:$PATH

ADD ./run-ssh /usr/local/bin/run-ssh

RUN apk add --no-cache --virtual --update \

    # Install important apks 

    git \
    make \
    bzr \
    build-base \
    musl-dev \
    musl-utils \
    tar \
    sudo \
    go \

    # Add musl libs
   
    && curl --create-dirs -sSLo /tmp/musl-1.1.15.tar.gz http://www.musl-libc.org/releases/musl-1.1.15.tar.gz \
    && cd /tmp
    && tar -xvf musl-1.1.15.tar.gz 
    && cd musl-1.1.15 \
    && ./configure \
    && make && sudo make install \
    && cd .. \
    && rm musl-1.1.15.tar.gz \
    && rm -Rf musl-1.1.15 \
    && rm -Rf musl.1.1.15 \
    && rm -Rf musl.1.1.15

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

RUN curl https://glide.sh/get | sh

WORKDIR /go/src/app

