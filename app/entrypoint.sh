#!/bin/bash

mix run transform.exs
mix phx.digest
mix ecto.create
mix ecto.migrate
mix phx.server
