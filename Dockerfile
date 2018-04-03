FROM donatello/meikyu:ghc-8.2.2

RUN apk update --no-progress && apk upgrade --no-progress
RUN apk add --no-progress yarn util-linux make xz gmp-dev g++

RUN stack --resolver lts-10.10 install \
    aeson \
    async \
    attoparsec \
    base \
    base64-bytestring \
    bytestring \
    case-insensitive \
    cassava \
    conduit \
    conduit-extra \
    cryptohash \
    cryptonite \
    data-default \
    directory \
    errors \
    exceptions \
    filepath \
    hashable \
    http-conduit \
    http-types \
    ip \
    jose \
    memory \
    microlens \
    minio-hs \
    monad-loops \
    monad-time \
    mtl \
    network-info \
    optparse-applicative \
    protolude \
    QuickCheck \
    scotty \
    securemem \
    stm \
    stm-chans \
    store \
    sysinfo \
    tasty \
    tasty-hspec \
    tasty-hunit \
    tasty-quickcheck \
    text \
    text-conversions \
    text-format \
    time \
    typed-process \
    unliftio \
    unliftio-core \
    unordered-containers \
    uuid \
    vector \
    wai \
    wai-app-static \
    wai-extra \
    wai-websockets \
    warp \
    warp-tls \
    websockets \
    yaml
