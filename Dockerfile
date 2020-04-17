FROM ubuntu:18.04

ARG GHC_VERSION=8.8.3
ARG LTS_SLUG=lts-15.8
ARG STACK_VERSION=2.1.3
ARG DEBIAN_FRONTEND=noninteractive
ARG NODE_VERSION=node_12.x
ARG HLINT_VERSION=2.2.11

# Set encoding to UTF-8 and PATH to find GHC and cabal/stack-installed binaries.
ENV LANG=C.UTF-8 \
    LC_ALL=C.UTF-8 \
    PATH=/root/.cabal/bin:/root/.local/bin:/opt/ghc/$GHC_VERSION/bin:$PATH
ENV DEBIAN_FRONTEND=noninteractive

# Install dependency packages
RUN apt update && apt install -y --no-install-recommends \
        apt-utils \
        build-essential \
        cpanminus \
        curl \
        git \
        gpg-agent \
        jq \
        less \
        libdbd-pg-perl \
        libgmp-dev \
        nano \
        netbase \
        perl \
        software-properties-common \
        tzdata \
        wget \
        zlib1g-dev

# Add postgresql repos for latest libpq and postgresql client
RUN curl https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add - && \
    sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt $(lsb_release -cs)-pgdg main" > /etc/apt/sources.list.d/pgdg.list' && \
    apt update && apt install -y libpq-dev postgresql-client

# Install Node and Yarn
RUN curl -sSL https://deb.nodesource.com/gpgkey/nodesource.gpg.key | apt-key add - && \
    echo "deb https://deb.nodesource.com/$NODE_VERSION $(lsb_release -s -c) main" | tee /etc/apt/sources.list.d/nodesource.list && \
    echo "deb-src https://deb.nodesource.com/$NODE_VERSION $(lsb_release -s -c) main" | tee -a /etc/apt/sources.list.d/nodesource.list && \
    curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && \
    echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list && \
    apt update && \
    apt install -y nodejs yarn

# Install ghc
RUN add-apt-repository -y ppa:hvr/ghc && \
    apt update && \
    apt install -y ghc-$GHC_VERSION

# Install sqitch
RUN cpanm --quiet --notest App::Sqitch && \
        cpanm --quiet --notest IO::Pager && \
        ls -sf /usr/share/zoneinfo/Etc/UTC /etc/localtime && \
        dpkg-reconfigure -f noninteractive tzdata

# Install Stack
RUN wget -qO- https://github.com/commercialhaskell/stack/releases/download/v${STACK_VERSION}/stack-${STACK_VERSION}-linux-x86_64-static.tar.gz | \
    tar xz --wildcards --strip-components=1 -C /usr/local/bin '*/stack'

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
        hspec-wai \
        jose \
        load-env \
        microlens \
        modern-uri \
        monad-logger \
        monad-loops \
        optparse-applicative \
        path-io \
        postgresql-simple \
        postgresql-simple-url \
        protolude \
        quickcheck-instances \
        raw-strings-qq \
        regex-tdfa \
        relude \
        req \
        resource-pool \
        retry \
        safe-exceptions \
        scotty \
        servant \
        stache \
        stm-chans \
        stripe-concepts \
        stripe-signature \
        tasty \
        tasty-hunit \
        tasty-quickcheck \
        text \
        text-conversions \
        timerep \
        unliftio \
        unordered-containers \
        utf8-string \
        uuid \
        wai-app-static \
        wai-cors \
        wreq \
        yaml

# Install extra deps/tools not in stackage snapshot
RUN stack install --resolver $LTS_SLUG --system-ghc \
        gogol-core-0.5.0 \
        gogol-0.5.0 \
        gogol-pubsub-0.5.0 \
        gogol-storage-0.5.0 \
        base-noprelude-4.13.0.0 \
        webby-0.4.0

# Install a dev tool
RUN stack install --resolver $LTS_SLUG --system-ghc \
        ghcid

# Install hlint from binary
RUN wget -O - https://github.com/ndmitchell/hlint/releases/download/v${HLINT_VERSION}/hlint-${HLINT_VERSION}-x86_64-linux.tar.gz | tar -C /opt/ -xz

ENV PATH=$PATH:/app:/opt/hlint-${HLINT_VERSION} SQITCH_EDITOR=nano SQITCH_PAGER=less LC_ALL=C.UTF-8 LANG=C.UTF-8

EXPOSE 3000 9000 9001 9002 9003 9004
