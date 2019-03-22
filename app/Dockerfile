FROM node:10.15-alpine as react

COPY ./ui /ui
WORKDIR /ui

RUN npm i yarn && yarn && yarn build

FROM elixir:1.8.0

RUN mix local.hex --force
RUN mix local.rebar --force

COPY . /example
WORKDIR /example

COPY --from=react /ui/build/static ./priv/static
COPY --from=react /ui/build/asset-manifest.json ./priv/static/asset-manifest.json

RUN apt-get update
RUN apt-get install make gcc libc-dev

RUN mix deps.get && mix deps.compile && mix compile

RUN chmod +x entrypoint.sh

EXPOSE 4000
