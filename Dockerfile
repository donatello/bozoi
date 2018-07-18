FROM donatello/meikyu:ghc-8.2.2

RUN apk update --no-progress && apk upgrade --no-progress
RUN apk add --no-progress yarn util-linux make xz gmp-dev g++ wget libpq \
                          postgresql-dev postgresql-libs openldap-dev

RUN addgroup stack && adduser -D -G stack -h /home/stack stack


RUN stack --system-ghc --allow-different-user --resolver lts-11.17 install \
        aeson \
        attoparsec \
        attoparsec-iso8601 \
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
        postgresql-simple \
        postgresql-simple-url \
        protolude \
        random \
        scotty \
        servant \
        string-conversions \
        text \
        text-conversions \
        text-format \
        th-lift-instances \
        unliftio \
        unordered-containers \
        uri-bytestring \
        utf8-string \
        uuid \
        wai \
        wai-app-static \
        wai-extra \
        warp

USER root

COPY global-register-ghc.sh /global-register-ghc.sh
RUN /global-register-ghc.sh
