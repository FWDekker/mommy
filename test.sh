#!/bin/sh
set -e
cd -P -- "$(dirname -- "$0")"

shellspec --no-warning-as-failure src/test/sh/mommy_spec.sh
