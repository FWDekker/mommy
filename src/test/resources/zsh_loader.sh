#!/usr/bin/env zsh
# Code taken from https://stackoverflow.com/a/69164362/


# Define our test function.
comptest() {
    # Gather all matching completions in this array.
    # -U discards duplicates.
    typeset -aU completions=()

    # Override the builtin compadd command.
    compadd() {
        # Gather all matching completions for this call in $reply.
        # Note that this call overwrites the specified array.
        # Therefore we cannot use $completions directly.
        builtin compadd -O reply "$@"

        completions+=("$reply[@]") # Collect them.
        builtin compadd "$@"       # Run the actual command.
    }

    # Bind a custom widget to TAB.
    bindkey "^I" complete-word
    zle -C {,,}complete-word
    complete-word() {
        # Make the completion system believe we're on a normal
        # command line, not in vared.
        unset 'compstate[vared]'

        _main_complete "$@" # Generate completions.

        # Print out our completions.
        # Use of ^B and ^C as delimiters here is arbitrary.
        # Just use something that won't normally be printed.
        print -n $'\C-B'
        print -nlr -- "$completions[@]" # Print one per line.
        print -n $'\C-C'
        exit
    }

    vared -c tmp
}

compget() {
    zmodload zsh/zpty # Load the pseudo terminal module.
    zpty {,}comptest  # Create a new pty and run our function in it.

    # Simulate a command being typed, ending with TAB to get completions.
    zpty -w comptest "$1"$'\t'

    # Read up to the first delimiter. Discard all of this.
    zpty -r comptest REPLY $'*\C-B'

    zpty -r comptest REPLY $'*\C-C' # Read up to the second delimiter.

    # Print out the results.
    print -r -- "$REPLY" | col # Trim off the escape characters, just in case.

    zpty -d comptest # Delete the pty
}
