FROM ubuntu:18.04

ARG GHC_VERSION=8.2.2
ARG LTS_SLUG=lts-11.22
ARG STACK_VERSION=1.9.1
ARG DEBIAN_FRONTEND=noninteractive

# Set encoding to UTF-8 and PATH to find GHC and cabal/stack-installed binaries.
ENV LANG=C.UTF-8 \
    LC_ALL=C.UTF-8 \
    PATH=/root/.cabal/bin:/root/.local/bin:/opt/ghc/$GHC_VERSION/bin:$PATH

# Install dependency packages
RUN apt update && apt install -y \
    build-essential \
    curl \
    git \
    libgmp-dev \
    libpq-dev \
    npm \
    software-properties-common \
    wget \
    zlib1g-dev

# Install ghc
RUN add-apt-repository -y ppa:hvr/ghc && \
    apt update && \
    apt install -y ghc-$GHC_VERSION

# Install yarn
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list
RUN apt update && apt install -y yarn

# Install Stack
RUN wget -qO- https://github.com/commercialhaskell/stack/releases/download/v1.9.1/stack-${STACK_VERSION}-linux-x86_64-static.tar.gz | \
    tar xz --wildcards --strip-components=1 -C /usr/local/bin '*/stack'

# Install project dependencies
RUN stack install --resolver $LTS_SLUG --system-ghc \
        aeson \
        aeson-casing \
        data-default \
        file-embed \
        formatting \
        gitrev \
        http-api-data \
        http-conduit \
        http-media \
        http-reverse-proxy \
        jose \
        load-env \
        microlens \
        modern-uri \
        monad-logger \
        monad-loops \
        mustache \
        optparse-applicative \
        postgresql-simple \
        postgresql-simple-url \
        protolude \
        raw-strings-qq \
        resource-pool \
        safe-exceptions \
        scotty \
        servant \
        stm-chans \
        text \
        text-conversions \
        text-format \
        unliftio \
        unordered-containers \
        utf8-string \
        uuid \
        wai-app-static \
        wreq

EXPOSE 3000 9000 9001 9002 9003 9004
