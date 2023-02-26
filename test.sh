#!/bin/sh
set -e
cd -P -- "$(dirname -- "$0")"

shellspec src/test/sh/mommy_spec.sh
