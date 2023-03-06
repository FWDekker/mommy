. ./helper.sh

# Configuration
: "${MOMMY_FISH_EXEC:=fish}"
: "${MOMMY_FISH_SOURCE:=1}"

# Make autocompletion available
if [ "$MOMMY_FISH_SOURCE" = "1" ]; then
    preamble="$preamble; source '$(pwd)/../../main/fish/mommy.fish'; "
fi


Describe "fish shell autocompletion"
    fish_installed() { ! test -x "$(command -v "$MOMMY_FISH_EXEC")"; }
    Skip if "fish not installed" fish_installed

    It "outputs something"
        When run "$MOMMY_FISH_EXEC" -c "$preamble; complete -C 'mommy -'"
        The line 1 of output should start with "-"
    End
End
