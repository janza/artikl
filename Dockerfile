FROM bitwalker/alpine-erlang:19.2.1b

ENV HOME=/opt/app/

# Install Elixir and basic build dependencies
RUN \
        echo "@edge http://nl.alpinelinux.org/alpine/edge/community" >> /etc/apk/repositories && \
        apk update && \
        apk --no-cache --update add \
        git make g++ \
        nodejs python \
        elixir@edge=1.4.2-r0 && \
        rm -rf /var/cache/apk/*

# Install Hex+Rebar
RUN mix local.hex --force && \
mix local.rebar --force

WORKDIR /opt/app

ENV MIX_ENV=prod

# Cache elixir deps
RUN mkdir config
COPY config/* config/
COPY mix.exs mix.lock ./
RUN mix do deps.get, deps.compile

COPY . .

# install static deps
RUN cd assets && npm install && cd -

# build static
RUN cd assets && \
./node_modules/brunch/bin/brunch b -p && \
rm -rf node_modules && \
cd - && \
mix phoenix.digest

RUN mix release --env=prod --verbose

# second stage
FROM bitwalker/alpine-erlang:19.2.1b

RUN apk update && \
    apk --no-cache --update add libgcc libstdc++ && \
    rm -rf /var/cache/apk/*

EXPOSE 4000
ENV PORT=4000 MIX_ENV=prod REPLACE_OS_VARS=true SHELL=/bin/sh

COPY --from=0 /opt/app/_build/prod/rel/artikl/releases/0.0.3/artikl.tar.gz .
RUN tar xvf artikl.tar.gz && rm artikl.tar.gz && chown -R default ./releases

USER default

ENTRYPOINT ["/opt/app/bin/artikl"]
CMD ["foreground"]
