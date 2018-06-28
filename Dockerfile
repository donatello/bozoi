FROM donatello/meikyu:ghc-8.2.2

RUN apk update --no-progress && apk upgrade --no-progress
RUN apk add --no-progress yarn util-linux make xz gmp-dev g++ wget
RUN addgroup stack && adduser -D -G stack -h /home/stack stack

ENV PATH /home/stack/.local/bin:$PATH

RUN stack --system-ghc --resolver lts-11.13 install \
        aeson \
        attoparsec \
        base \
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
        protolude \
        random \
        scotty \
        text \
        text-format \
        unliftio \
        unordered-containers \
        uuid \
        wai \
        wai-app-static \
        wai-extra \
        warp
