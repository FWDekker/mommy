#!/bin/sh
set -e
cd -P -- "$(dirname -- "$0")"

# Specify shell with `-shell sh` to work around https://github.com/shellspec/shellspec/issues/291 in OpenBSD
shellspec --shell sh --no-warning-as-failure src/test/sh/mommy_spec.sh
