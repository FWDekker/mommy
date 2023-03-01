# Extract the args, removing `$0` and opts (i.e. `mommy -c . apt update` -> `apt update`)
function extract_args
    argparse -i "h/help" "v/version" "c/config=" "e/eval=" "s/status=" -- $argv
    echo $argv
end

function get_args
    set -l tokens (commandline -opc)
    set -e tokens[1]

    extract_args $tokens
end

function get_args_with_token
    set -l tokens (commandline -opc) (commandline -ct)
    set -e tokens[1]

    extract_args $tokens
end

function get_current_command
end


# Set common elements
set opt_help    "-o h -l help"
set opt_version "-o v -l version"
set opt_config  "-o c -l config"
set opt_eval    "-o e -l eval"
set opt_status  "-o s -l status"


# Add completions
complete -c mommy -f

complete -c mommy -o h -l help          -d "Show manual"                                                               -n "__fish_is_first_arg" -n "test -z (get_args)"
complete -c mommy -o v -l version       -d "Show version"                                                              -n "__fish_is_first_arg" -n "test -z (get_args)"

complete -c mommy -o 1                  -d "Write to stdout"                                                           -n "not __fish_seen_argument $opt_help $opt_version" -n "test -z (get_args)"
complete -c mommy -o c -l config  -r -F -d "Configuration file"                                                        -n "not __fish_seen_argument $opt_help $opt_version" -n "test -z (get_args)"

complete -c mommy -o e -l eval    -r    -d "Evaluate string"       -a "(__fish_complete_command)"                      -n "not __fish_seen_argument $opt_help $opt_version $opt_status" -n "test -z (get_args)"
complete -c mommy -o s -l status  -r -f -d "Exit code"             -a "(echo '0       Success'; echo '1       Error')" -n "not __fish_seen_argument $opt_help $opt_version $opt_eval" -n "test -z (get_args)"

complete -c mommy                                               -k -a "(complete -C (get_args_with_token))"            -n "test -n (get_args_with_token); or not __fish_seen_argument $opt_help $opt_version $opt_eval $opt_status"
