# Extracts the non-option commands from `$argv` and writes to stdout.
# For example, given `mommy -c ./config.sh apt update -f`, writes `apt update -f`.
function extract_command
    set -e argv[1]

    set -l is_option_argument 0
    for arg in $argv
        if test $is_option_argument -eq 1
            set -e argv[1]
            set is_option_argument 0
            continue
        end

        switch $arg
            case '-c' '-e' '-s'
                set -e argv[1]
                set is_option_argument 1
            case '-*'
                set -e argv[1]
            case '*'
                echo $argv
                return 0
        end
    end

    return 0
end

# Extract the args, excluding the arg that the user is currently writing
function get_args
    set -l tokens (commandline -opc)

    extract_command $tokens
end

# Extract the args, including the arg that the user is currently writing
function get_args_with_token
    set -l tokens (commandline -opc) (commandline -ct)

    extract_command $tokens
end


# Set common elements
set -l opt_help    "-o h -l help"
set -l opt_version "-o v -l version"


# Add completions
complete -c mommy -f

complete -c mommy -o h -l help \
    -d "Show manual" \
    -n "__fish_is_first_arg"
complete -c mommy -o v -l version \
    -d "Show version" \
    -n "__fish_is_first_arg"

complete -c mommy -o 1 \
    -d "Write to stdout" \
    -n "not __fish_seen_argument $opt_help $opt_version" \
    -n "test -z (get_args)"
complete -c mommy -o c \
    -rF \
    -d "Configuration file" \
    -n "not __fish_seen_argument $opt_help $opt_version"\
    -n "test -z (get_args)"

complete -c mommy -o e \
    -r \
    -d "Evaluate string" \
    -n "not __fish_seen_argument $opt_help $opt_version -o s" \
    -n "test -z (get_args)"
complete -c mommy -o s \
    -rf \
    -d "Exit code" \
    -a "(echo 0\tSuccess\n1\tError)" \
    -n "not __fish_seen_argument $opt_help $opt_version -o e" \
    -n "test -z (get_args)"

complete -c mommy \
    # `complete -C` requires one argument, so must be wrapped in quotes. Fish <3.4.0 cannot do `$(...)`, so workaround
    # is to assign to temporary variable.
    -k -a "(set -l command (get_args_with_token); complete -C \"\$command\")" \
    -n "test -n (get_args_with_token); or not __fish_seen_argument $opt_help $opt_version -o e -o s"
