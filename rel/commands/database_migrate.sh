#!/bin/sh

release_ctl eval --mfa "Elixir.Api.ReleaseTasks.migrate/1" --argv -- "$@"
