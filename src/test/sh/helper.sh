## Config
: "${MOMMY_EXEC:=../../main/sh/mommy}"
export MOMMY_EXEC

: "${MOMMY_CONFIG_FILE:=./config}"
export MOMMY_CONFIG_FILE


## Constants
export n="
"


## Functions
# Writes `$1` to the config file, setting `MOMMY_COLOR` and `MOMMY_SUFFIX` to the empty string if not set in `$1`.
set_config() {
    echo "MOMMY_COLOR='';MOMMY_SUFFIX='';$1" > "$MOMMY_CONFIG_FILE"
}
export set_config
