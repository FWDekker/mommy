. ./helper.sh

# Configuration
: "${MOMMY_ZSH_EXEC:=zsh}"
: "${MOMMY_ZSH_SOURCE:=1}"

# Make autocompletion available
preamble="source '$(pwd)/../resources/zsh_loader.sh'"
if [ "$MOMMY_ZSH_SOURCE" = "1" ]; then
    preamble="$preamble; FPATH=\"$(pwd)/../../main/zsh/:\$FPATH\""
fi
preamble="$preamble; autoload -U compinit; compinit"


Describe "zsh shell autocompletion"
    zsh_installed() { ! test -x "$(command -v "$MOMMY_ZSH_EXEC")"; }
    Skip if "zsh not installed" zsh_installed

    It "outputs something"
        When run "$MOMMY_ZSH_EXEC" -c "$preamble; compget 'mommy -'"
        The line 1 of output should equal "-h"
    End
End
