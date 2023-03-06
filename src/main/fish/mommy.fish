# Extracts the non-option commands from `$argv` and writes to stdout.
# For example, given `mommy -c ./config.sh apt update -f`, writes `apt update -f`.
function extract_command
    set -e argv[1]

    set -f is_option_argument 0
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
set opt_help    "-o h -l help"
set opt_version "-o v -l version"
set opt_config  "-o c -l config"
set opt_eval    "-o e -l eval"
set opt_status  "-o s -l status"


# Add completions
complete -c mommy -f

complete -c mommy -o h -l help          -d "Show manual"                                                               -n "__fish_is_first_arg"
complete -c mommy -o v -l version       -d "Show version"                                                              -n "__fish_is_first_arg"

complete -c mommy -o 1                  -d "Write to stdout"                                                           -n "not __fish_seen_argument $opt_help $opt_version" -n "test -z (get_args)"
complete -c mommy -o c -l config  -r -F -d "Configuration file"                                                        -n "not __fish_seen_argument $opt_help $opt_version" -n "test -z (get_args)"

complete -c mommy -o e -l eval    -r    -d "Evaluate string"       -a "(__fish_complete_command)"                      -n "not __fish_seen_argument $opt_help $opt_version $opt_status" -n "test -z (get_args)"
complete -c mommy -o s -l status  -r -f -d "Exit code"             -a "(echo '0       Success'; echo '1       Error')" -n "not __fish_seen_argument $opt_help $opt_version $opt_eval" -n "test -z (get_args)"

complete -c mommy                                               -k -a "(complete -C '(get_args_with_token)')"          -n "test -n (get_args_with_token); or not __fish_seen_argument $opt_help $opt_version $opt_eval $opt_status"
