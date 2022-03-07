#!/bin/sh

release_ctl eval --mfa "Elixir.Api.ReleaseTasks.seed/1" --argv -- "$@"