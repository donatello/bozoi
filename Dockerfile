FROM alpine:3.8

RUN apk update --no-progress && apk upgrade --no-progress
RUN apk add --no-progress \
    g++ \
    git \
    ghc \
    gmp-dev \
    libpq \
    make \
    openldap-dev \
    postgresql-dev \
    postgresql-libs \
    util-linux \
    wget \
    wget \
    xz \
    yarn \
    zlib-dev

RUN wget -q 'https://github.com/nh2/stack/releases/download/v1.6.5/stack-1.7.1-x86_64-unofficial-fully-static-musl' \
    -O /usr/local/bin/stack && \
    chmod +x /usr/local/bin/stack

RUN addgroup stack && adduser -D -G stack -h /home/stack stack

USER stack

ENV PATH /home/stack/.local/bin:$PATH

RUN stack --system-ghc --resolver lts-12.0 install \
        aeson \
        attoparsec \
        base \
        base16-bytestring \
        bytestring \
        errors \
        exceptions \
        file-embed \
        http-client \
        http-conduit \
        http-reverse-proxy \
        http-types \
        jose \
        lens \
        load-env \
        microlens \
        monad-time \
        optparse-applicative \
        postgresql-simple-url \
        protolude \
        random \
        scotty \
        text \
        text-conversions \
        unliftio \
        unordered-containers \
        uuid \
        wai \
        wai-app-static \
        wai-extra \
        warp
