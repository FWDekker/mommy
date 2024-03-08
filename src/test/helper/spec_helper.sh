#!/bin/sh
## Configuration
# "1" to run against installed files, "0" to run against files in `src/`
: "${MOMMY_SYSTEM:=0}"
export MOMMY_SYSTEM

# Path to mommy executable to test
if [ "$MOMMY_SYSTEM" = "1" ]; then
    : "${MOMMY_EXEC:=mommy}"
else
    : "${MOMMY_EXEC:=../../main/sh/mommy}"
fi
export MOMMY_EXEC

# Path to directory for temporary files
: "${MOMMY_TMP_DIR:=/tmp/mommy-test/}"
export MOMMY_TMP_DIR


## Constants and helpers
export n="
"

strip_opt() { printf "%s\n" "$1" | sed -E "s/(^-+|[= ])//g"; }


## Hooks
spec_helper_configure() {
    rm -rf "$MOMMY_TMP_DIR"

    before_each "mommy_before_each"
    after_each "mommy_after_each"
}

mommy_before_each() {
    mkdir -p "$MOMMY_TMP_DIR" "$MOMMY_TMP_DIR/global1/" "$MOMMY_TMP_DIR/global2/"
}

mommy_after_each() {
    rm -rf "$MOMMY_TMP_DIR"
}
