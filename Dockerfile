FROM donatello/meikyu:ghc-8.2.2

RUN apk update --no-progress && apk upgrade --no-progress
RUN apk add --no-progress yarn util-linux make xz gmp-dev g++ wget
RUN addgroup stack && adduser -D -G stack -h /home/stack stack

ENV PATH /home/stack/.local/bin:$PATH

RUN stack --system-ghc --resolver lts-11.8 install \
                     QuickCheck \
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
                     fast-logger \
                     file-embed \
                     filepath \
                     hashable \
                     http-conduit \
                     http-types \
                     ip \
                     jose \
                     memory \
                     microlens \
                     minio-hs \
                     monad-logger \
                     monad-loops \
                     monad-time \
                     mtl \
                     mustache \
                     network-info \
                     optparse-applicative \
                     protolude \
                     random \
                     retry \
                     scotty \
                     securemem \
                     stm \
                     stm-chans \
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
