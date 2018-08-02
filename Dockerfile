FROM donatello/meikyu:ghc-8.2.2

RUN apk update --no-progress && apk upgrade --no-progress
RUN apk add --no-progress yarn util-linux make xz gmp-dev g++ wget libpq \
                          postgresql-dev postgresql-libs openldap-dev
RUN addgroup stack && adduser -D -G stack -h /home/stack stack

ENV PATH /home/stack/.local/bin:$PATH

RUN stack --system-ghc --resolver lts-11.13 install \
        aeson-casing \
        base16-bytestring \
        clock \
        errors \
        file-embed \
        formatting \
        http-conduit \
        http-reverse-proxy \
        jose \
        lens \
        load-env \
        microlens \
        modern-uri \
        monad-loops \
        monad-time \
        optparse-applicative \
        persistent-postgresql \
        persistent-template \
        postgresql-simple-url \
        protolude \
        random \
        safe-exceptions \
        scotty \
        servant \
        stm-chans \
        syb \
        text-conversions \
        text-format \
        th-orphans \
        unliftio \
        unordered-containers \
        utf8-string \
        uuid \
        wai-app-static
