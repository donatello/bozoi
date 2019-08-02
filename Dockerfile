FROM ubuntu:18.04

ARG GHC_VERSION=8.6.5
ARG LTS_SLUG=lts-13.29
ARG STACK_VERSION=1.9.3
ARG DEBIAN_FRONTEND=noninteractive

# Set encoding to UTF-8 and PATH to find GHC and cabal/stack-installed binaries.
ENV LANG=C.UTF-8 \
    LC_ALL=C.UTF-8 \
    PATH=/root/.cabal/bin:/root/.local/bin:/opt/ghc/$GHC_VERSION/bin:$PATH
ENV DEBIAN_FRONTEND=noninteractive

# Install dependency packages
RUN apt update && apt install -y --no-install-recommends \
        build-essential \
        cpanminus \
        curl \
        git \
        gpg-agent \
        jq \
        less \
        libdbd-pg-perl \
        libgmp-dev \
        libpq-dev \
        nano \
        netbase \
        npm \
        perl \
        postgresql-client \
        software-properties-common \
        tzdata \
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

# Install sqitch
RUN cpanm --quiet --notest App::Sqitch && \
        cpanm --quiet --notest IO::Pager && \
        ls -sf /usr/share/zoneinfo/Etc/UTC /etc/localtime && \
        dpkg-reconfigure -f noninteractive tzdata

# Install Stack
RUN wget -qO- https://github.com/commercialhaskell/stack/releases/download/v${STACK_VERSION}/stack-${STACK_VERSION}-linux-x86_64-static.tar.gz | \
    tar xz --wildcards --strip-components=1 -C /usr/local/bin '*/stack'

# Install elm
RUN npm install -g elm

# Install project dependencies
RUN stack install --resolver $LTS_SLUG --system-ghc \
        JuicyPixels \
        JuicyPixels-extra \
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
        hspec \
        jose \
        load-env \
        microlens \
        modern-uri \
        monad-logger \
        monad-loops \
        optparse-applicative \
        postgresql-simple \
        postgresql-simple-url \
        protolude \
        raw-strings-qq \
        req \
        resource-pool \
        retry \
        safe-exceptions \
        scotty \
        servant \
        stache \
        stm-chans \
        text \
        text-conversions \
        text-format \
        timerep \
        unliftio \
        unordered-containers \
        utf8-string \
        uuid \
        wai-app-static \
        wai-cors \
        wreq

# Install extra deps not in stackage snapshot
RUN stack install --resolver $LTS_SLUG --system-ghc \
        sendgrid-v3-0.1.2.0 \
        gogol-core-0.4.0 \
        gogol-0.4.0 \
        gogol-pubsub-0.4.0 \
        gogol-storage-0.4.0


ENV PATH=$PATH:/app SQITCH_EDITOR=nano SQITCH_PAGER=less LC_ALL=C.UTF-8 LANG=C.UTF-8

EXPOSE 3000 9000 9001 9002 9003 9004
