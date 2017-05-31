FROM bitwalker/alpine-erlang:19.2.1b

ENV HOME=/opt/app/ TERM=xterm

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

# install static deps
COPY package.json ./
RUN npm install

COPY . .

# build static
RUN ./node_modules/brunch/bin/brunch b -p && \
mix phoenix.digest && \
rm -rf node_modules

RUN mix release --env=prod --verbose

# second stage
FROM bitwalker/alpine-erlang:19.2.1b

RUN apk update && \
    apk --no-cache --update add libgcc libstdc++ && \
    rm -rf /var/cache/apk/*

EXPOSE 4000
ENV PORT=4000 MIX_ENV=prod REPLACE_OS_VARS=true SHELL=/bin/sh

ADD artikl.tar.gz ./

COPY --from=0 /opt/app/artikl.tar.gz .
RUN chown -R default ./releases

USER default

ENTRYPOINT ["/opt/app/bin/artikl"]
CMD ["foreground"]
