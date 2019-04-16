#!/bin/bash

str=`date -Ins | md5sum`
name=${str:0:10}

mix run transform.exs
mix phx.digest
mix ecto.create
mix ecto.migrate
mix run priv/repo/seeds.exs

elixir --sname $name --cookie monster -S mix phx.server
