#!/bin/sh
## Configuration
# Make
: "${MOMMY_MAKE:=make}"  # Path to GNU make to invoke

# Man
: "${MOMMY_MAN_SKIP:=0}"  # "1" to run man-related tests, "0" to skip them

# Fish
: "${MOMMY_FISH_SKIP:=0}"  # "1" to run fish-related tests, "0" to skip them
: "${MOMMY_FISH_EXEC:=fish}"  # Path to fish to invoke

# Zsh
: "${MOMMY_ZSH_SKIP:=0}"  # "1" to run zsh-related tests, "0" to skip them
: "${MOMMY_ZSH_EXEC:=zsh}"  # Path to zsh to invoke
: "${MOMMY_ZSH_PREAMBLE_FILE:=$MOMMY_TMP_DIR/zsh_preamble.sh}"  # Path to temporary zsh preamble file


## Run tests
Describe "integration of mommy with other programs"
    Describe "uninstalling"
        is_empty() {
            test "$(find "$1/" -type f | wc -l)" -eq 0
        }

        It "uninstalls all files that are installed"
            "$MOMMY_MAKE" -C ../../../ prefix="$MOMMY_TMP_DIR/" install >/dev/null
            "$MOMMY_MAKE" -C ../../../ prefix="$MOMMY_TMP_DIR/" uninstall >/dev/null

            Assert is_empty "$MOMMY_TMP_DIR/"
        End
    End

    Describe "-h/--help: help information"
        man_is_skipped_or_not_installed() { test "$MOMMY_MAN_SKIP" = "1" || ! test -x "$(command -v man)"; }
        Skip if "man is skipped or not installed" man_is_skipped_or_not_installed

        man_before_each() {
            unset MANPATH  # Required on Windows
            if [ "$MOMMY_SYSTEM" != "1" ]; then
                MANPATH="$(readlink -f "$(pwd)/../../main/man/")"
                export MANPATH
            fi
        }
        BeforeEach "man_before_each"


        Parameters:value "-h" "--help"

        It "outputs help information using $1"
            When run "$MOMMY_EXEC" "$1"
            The word 1 of output should equal "mommy(1)"
            The status should be success
        End

        It "outputs help information even when $1 is not the first option"
            When run "$MOMMY_EXEC" -s 432 "$1"
            The word 1 of output should equal "mommy(1)"
            The status should be success
        End

        It "outputs a link to github if the manual page could not be found when using $1"
            export MANPATH="/invalid-path"

            When run "$MOMMY_EXEC" "$1"
            The output should equal ""
            The error should include "github.com"
            The status should be failure
        End
    End

    Describe "fish shell autocompletion"
        fish_is_skipped_or_not_installed() { test "$MOMMY_FISH_SKIP" = "1" || ! test -x "$(command -v "$MOMMY_FISH_EXEC")"; }
        Skip if "fish is skipped or not installed" fish_is_skipped_or_not_installed

        fish_before_each() {
            if [ "$MOMMY_SYSTEM" != "1" ]; then
                fish_preamble="
                    fish_add_path --path --prepend '$(pwd)/../../main/sh/'  # Fish requires executable to be on path
                    set fish_complete_path '$(pwd)/../../main/completions/fish/' \$fish_complete_path
                "
            fi
        }
        BeforeEach "fish_before_each"

        fish_complete() {
            "$MOMMY_FISH_EXEC" -c "$fish_preamble; complete -C '$1'"
        }


        It "outputs an option if the argument starts with -"
            When run fish_complete "mommy -"
            The output should include "-1"
        End

        It "outputs files if the previous option was -c"
            When run fish_complete "mommy -c "
            The output should include "integration_spec.sh"
        End
    End

    Describe "zsh shell autocompletion"
        zsh_is_skipped_or_not_installed() { test "$MOMMY_ZSH_SKIP" = "1" || ! test -x "$(command -v "$MOMMY_ZSH_EXEC")"; }
        Skip if "zsh is skipped or not installed" zsh_is_skipped_or_not_installed

        zsh_before_each() {
            echo "source '$(pwd)/../resources/zsh_loader.zsh'" > "$MOMMY_ZSH_PREAMBLE_FILE"
            if [ "$MOMMY_SYSTEM" != "1" ]; then
                echo "FPATH='$(pwd)/../../main/completions/zsh/:'\"\$FPATH\"" >> "$MOMMY_ZSH_PREAMBLE_FILE"
            fi
            echo "autoload -U compinit; compinit -u" >> "$MOMMY_ZSH_PREAMBLE_FILE"
        }
        BeforeEach "zsh_before_each"

        zsh_complete() {
            # `script` emulates an interactive terminal during GitHub actions
            if script -q -c true /dev/null 1>/dev/null 2>/dev/null; then
                # Linux
                script -q -c "$MOMMY_ZSH_EXEC -i -u -c \"source '$MOMMY_ZSH_PREAMBLE_FILE'; compget '$1'\"" /dev/null
            else
                # *BSD
                script -q /dev/null "$MOMMY_ZSH_EXEC" -i -u -c "source '$MOMMY_ZSH_PREAMBLE_FILE'; compget '$1'"
            fi
        }


        It "outputs an option if the argument starts with -"
            When run zsh_complete "mommy -"
            The output should include "-1"
        End

        It "outputs files if the previous option was -c"
            When run zsh_complete "mommy -c "
            The output should include "integration_spec.sh"
        End
    End
End
