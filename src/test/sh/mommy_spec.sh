n="
"

# Settings
[ -z "$MOMMY_EXEC" ] && export MOMMY_EXEC="../../main/sh/mommy"
[ -z "$MOMMY_CONFIG_FILE" ] && export MOMMY_CONFIG_FILE="./config"

# Writes `$1` to the config file, setting `MOMMY_COLOR` and `MOMMY_SUFFIX` to the empty string if not set in `$1`.
set_config() {
    echo "MOMMY_COLOR='';MOMMY_SUFFIX='';$1" > "$MOMMY_CONFIG_FILE"
}


# Tests
Describe "mommy"
    clean_config() { rm -f "$MOMMY_CONFIG_FILE"; }
    BeforeEach "clean_config"
    AfterEach "clean_config"

    Describe "command-line options"
        It "gives an error for unknown short options"
            When run "$MOMMY_EXEC" -d
            The error should equal "Illegal option -d"
            The status should be failure
        End

        It "gives an error for unknown long options"
            When run "$MOMMY_EXEC" --doesnotexist
            The error should equal "Illegal option --doesnotexist"
            The status should be failure
        End

        Describe "-h/--help: help information"
            It "outputs help information using -h"
                When run "$MOMMY_EXEC" -h
                The word 1 of output should equal "mommy(1)"
                The status should be success
            End

            It "outputs help information using --help"
                When run "$MOMMY_EXEC" --help
                The word 1 of output should equal "mommy(1)"
                The status should be success
            End

            It "outputs help information even when -h is not the first option"
                When run "$MOMMY_EXEC" -s 432 -h
                The word 1 of output should equal "mommy(1)"
                The status should be success
            End

            It "outputs help information even when --help is not the first option"
                When run "$MOMMY_EXEC" -s 221 --help
                The word 1 of output should equal "mommy(1)"
                The status should be success
            End
        End

        Describe "-v/--help: version information"
            It "outputs version information using -v"
                When run "$MOMMY_EXEC" -v
                The word 1 of output should equal "mommy"
                The word 2 of output should match pattern "v%%VERSION_NUMBER%%|v[0-9a-z\.\+]*"
                The status should be success
            End

            It "outputs version information using --version"
                When run "$MOMMY_EXEC" --version
                The word 1 of output should equal "mommy"
                The word 2 of output should match pattern "v%%VERSION_NUMBER%%|v[0-9a-z\.\+]*"
                The status should be success
            End

            It "outputs version information even when --v is not the first option"
                When run "$MOMMY_EXEC" -s 138 --v
                The word 1 of output should equal "mommy"
                The word 2 of output should match pattern "v%%VERSION_NUMBER%%|v[0-9a-z\.\+]*"
                The status should be success
            End

            It "outputs version information even when --version is not the first option"
                When run "$MOMMY_EXEC" -s 911 --version
                The word 1 of output should equal "mommy"
                The word 2 of output should match pattern "v%%VERSION_NUMBER%%|v[0-9a-z\.\+]*"
                The status should be success
            End
        End

        Describe "-1: output to stdout"
            It "outputs to stderr by default"
                set_config "MOMMY_COMPLIMENTS='desk copper'"

                When run "$MOMMY_EXEC" -c "$MOMMY_CONFIG_FILE" true
                The output should equal ""
                The error should equal "desk copper"
                The status should be success
            End

            It "outputs to stdout if -1 is given"
                set_config "MOMMY_COMPLIMENTS='gate friendly'"

                When run "$MOMMY_EXEC" -1 -c "$MOMMY_CONFIG_FILE" true
                The output should equal "gate friendly"
                The error should equal ""
                The status should be success
            End
        End

        Describe "-c: custom configuration file"
            It "ignores an invalid path"
                When run "$MOMMY_EXEC" -c "./does_not_exist" true
                The error should not equal ""
                The status should be success
            End

            It "uses the configuration from the given file"
                set_config "MOMMY_COMPLIMENTS='apply news'"

                When run "$MOMMY_EXEC" -c "$MOMMY_CONFIG_FILE" true
                The error should equal "apply news"
                The status should be success
            End
        End

        Describe "vararg: command"
            It "writes a compliment to stderr if the command returns 0 status"
                set_config "MOMMY_COMPLIMENTS='purpose wall'"

                When run "$MOMMY_EXEC" -c "$MOMMY_CONFIG_FILE" true
                The error should equal "purpose wall"
                The status should be success
            End

            It "writes an encouragement to stderr if the command returns non-0 status"
                set_config "MOMMY_ENCOURAGEMENTS='razor woolen'"

                When run "$MOMMY_EXEC" -c "$MOMMY_CONFIG_FILE" false
                The error should equal "razor woolen"
                The status should be failure
            End

            It "returns the non-0 status of the command"
                When run "$MOMMY_EXEC" exit 4
                The error should not equal ""
                The status should equal 4
            End

            It "passes all arguments to the command"
                set_config "MOMMY_COMPLIMENTS='disagree mean'"

                When run "$MOMMY_EXEC" -c "$MOMMY_CONFIG_FILE" echo a b c
                The output should equal "a b c"
                The error should equal "disagree mean"
                The status should be success
            End
        End

        Describe "-e: eval"
            It "writes a compliment to stderr if the evaluated command returns 0 status"
                set_config "MOMMY_COMPLIMENTS='bold accord'"

                When run "$MOMMY_EXEC" -c "$MOMMY_CONFIG_FILE" -e "true"
                The error should equal "bold accord"
                The status should be success
            End

            It "writes an encouragement to stderr if the evaluated command returns non-0 status"
                set_config "MOMMY_ENCOURAGEMENTS='head log'"

                When run "$MOMMY_EXEC" -c "$MOMMY_CONFIG_FILE" -e "false"
                The error should equal "head log"
                The status should be failure
            End

            It "returns the non-0 status of the evaluated command"
                When run "$MOMMY_EXEC" -e "exit 4"
                The error should not equal ""
                The status should equal 4
            End

            It "passes all arguments to the command"
                set_config "MOMMY_COMPLIMENTS='desire bread'"

                When run "$MOMMY_EXEC" -c "$MOMMY_CONFIG_FILE" -e "echo a b c"
                The output should equal "a b c"
                The error should equal "desire bread"
                The status should be success
            End

            It "considers the command a success if all parts succeed"
                set_config "MOMMY_COMPLIMENTS='milk literary'"

                When run "$MOMMY_EXEC" -c "$MOMMY_CONFIG_FILE" -e "echo 'a/b/c' | cut -d '/' -f 1"
                The output should be present
                The error should equal "milk literary"
                The status should be success
            End

            It "considers the command a failure if any part fails"
                set_config "MOMMY_ENCOURAGEMENTS='bear cupboard'"

                When run "$MOMMY_EXEC" -c "$MOMMY_CONFIG_FILE" -e "echo 'a/b/c' | cut -d '/' -f 0"
                The error should be present
                The status should be failure
            End
        End

        Describe "-s: status"
            It "writes a compliment to stderr if the status is 0"
                set_config "MOMMY_COMPLIMENTS='station top'"

                When run "$MOMMY_EXEC" -c "$MOMMY_CONFIG_FILE" -s 0
                The error should equal "station top"
                The status should be success
            End

            It "writes an encouragement to stderr if the status is non-0"
                set_config "MOMMY_ENCOURAGEMENTS='mend journey'"

                When run "$MOMMY_EXEC" -c "$MOMMY_CONFIG_FILE" -s 1
                The error should equal "mend journey"
                The status should be failure
            End

            It "returns the given non-0 status"
                When run "$MOMMY_EXEC" -s 167
                The error should not equal ""
                The status should equal 167
            End
        End
    End

    Describe "configuration"
        Describe "templates"
            Describe "selection sources"
                It "chooses from 'MOMMY_COMPLIMENTS'"
                    set_config "MOMMY_COMPLIMENTS='spill drown'"

                    When run "$MOMMY_EXEC" -c "$MOMMY_CONFIG_FILE" true
                    The error should equal "spill drown"
                    The status should be success
                End

                It "chooses from 'MOMMY_COMPLIMENTS_EXTRA'"
                    set_config "MOMMY_COMPLIMENTS='';MOMMY_COMPLIMENTS_EXTRA='bill lump'"

                    When run "$MOMMY_EXEC" -c "$MOMMY_CONFIG_FILE" true
                    The error should equal "bill lump"
                    The status should be success
                End

                It "outputs nothing if no compliments are set"
                    set_config "MOMMY_COMPLIMENTS='';MOMMY_COMPLIMENTS_EXTRA=''"

                    When run "$MOMMY_EXEC" -c "$MOMMY_CONFIG_FILE" true
                    The error should equal ""
                    The status should be success
                End
            End

            Describe "separators"
                It "inserts a separator between 'MOMMY_COMPLIMENTS' and 'MOMMY_COMPLIMENTS_EXTRA'"
                    set_config "MOMMY_COMPLIMENTS='curse';MOMMY_COMPLIMENTS_EXTRA='dear'"

                    When run "$MOMMY_EXEC" -c "$MOMMY_CONFIG_FILE" true
                    The error should not equal "curse dear"
                    The status should be success
                End

                It "uses / as a separator"
                    set_config "MOMMY_COMPLIMENTS='boy/only'"

                    When run "$MOMMY_EXEC" -c "$MOMMY_CONFIG_FILE" true
                    The error should not equal "boy/only"
                    The status should be success
                End

                It "uses a newline as a separator"
                    set_config "MOMMY_COMPLIMENTS='salt${n}staff'"

                    When run "$MOMMY_EXEC" -c "$MOMMY_CONFIG_FILE" true
                    The error should not equal "salt${n}staff"
                    The status should be success
                End

                It "removes entries containing only whitespace"
                    # Probability of ~1/30 to pass even if code is buggy

                    set_config "MOMMY_COMPLIMENTS='  /  /wage rot/  /  /  /  /  /  /  /  /  /  /  /  /  /  /  /  /  /  /  /  /  /  /  /  /  /  /  '"

                    When run "$MOMMY_EXEC" -c "$MOMMY_CONFIG_FILE" true
                    The error should equal "wage rot"
                    The status should be success
                End
            End

            Describe "comments"
                It "ignores lines starting with '#'"
                    set_config "MOMMY_COMPLIMENTS='weaken${n}#egg'"

                    When run "$MOMMY_EXEC" -c "$MOMMY_CONFIG_FILE" true
                    The error should equal "weaken"
                    The status should be success
                End

                It "does not ignore lines starting with ' #'"
                    set_config "MOMMY_COMPLIMENTS=' #seat'"

                    When run "$MOMMY_EXEC" -c "$MOMMY_CONFIG_FILE" true
                    The error should equal " #seat"
                    The status should be success
                End

                It "does not ignore lines with a '#' not at the start"
                    set_config "MOMMY_COMPLIMENTS='lo#ud'"

                    When run "$MOMMY_EXEC" -c "$MOMMY_CONFIG_FILE" true
                    The error should equal "lo#ud"
                    The status should be success
                End

                It "ignores the '/' in a comment line"
                    set_config "MOMMY_COMPLIMENTS='figure${n}#penny/some'"

                    When run "$MOMMY_EXEC" -c "$MOMMY_CONFIG_FILE" true
                    The error should equal "figure"
                    The status should be success
                End
            End

            Describe "whitespace in entries"
                It "retains leading whitespace in an entry"
                    set_config "MOMMY_COMPLIMENTS=' rake fix'"

                    When run "$MOMMY_EXEC" -c "$MOMMY_CONFIG_FILE" true
                    The error should equal " rake fix"
                    The status should be success
                End

                It "retains trailing whitespace in an entry"
                    set_config "MOMMY_COMPLIMENTS='read wealth '"

                    When run "$MOMMY_EXEC" -c "$MOMMY_CONFIG_FILE" true
                    The error should equal "read wealth "
                    The status should be success
                End
            End

            Describe "toggling"
                It "outputs nothing if a command succeeds but compliments are disabled"
                    set_config "MOMMY_COMPLIMENTS_ENABLED='0'"

                    When run "$MOMMY_EXEC" -c "$MOMMY_CONFIG_FILE" true
                    The error should equal ""
                    The status should be success
                End

                It "outputs nothing if a command fails but encouragements are disabled"
                    set_config "MOMMY_ENCOURAGEMENTS_ENABLED='0'"

                    When run "$MOMMY_EXEC" -c "$MOMMY_CONFIG_FILE" false
                    The error should equal ""
                    The status should be failure
                End
            End
        End

        Describe "template variables"
            It "replaces %%SWEETIE%%"
                set_config "MOMMY_COMPLIMENTS='>%%SWEETIE%%<';MOMMY_SWEETIE='attempt'"

                When run "$MOMMY_EXEC" -c "$MOMMY_CONFIG_FILE" true
                The error should equal ">attempt<"
                The status should be success
            End

            It "replaces %%CAREGIVER%%"
                set_config "MOMMY_COMPLIMENTS='>%%CAREGIVER%%<';MOMMY_CAREGIVER='help'"

                When run "$MOMMY_EXEC" -c "$MOMMY_CONFIG_FILE" true
                The error should equal ">help<"
                The status should be success
            End

            It "appends the suffix"
                set_config "MOMMY_COMPLIMENTS='>';MOMMY_SUFFIX='respect'"

                When run "$MOMMY_EXEC" -c "$MOMMY_CONFIG_FILE" true
                The error should equal ">respect"
                The status should be success
            End

            It "chooses a random word for a variable"
                # Runs mommy several times and checks if output is different at least once.
                # Probability of 1/(26^4)=1/456976 to fail even if code is correct.

                caregiver="a/b/c/d/e/f/g/h/j/k/l/m/n/o/p/q/r/s/t/u/v/w/x/y/z"
                set_config "MOMMY_COMPLIMENTS='>%%CAREGIVER%%<';MOMMY_CAREGIVER='$caregiver'"

                output1=$("$MOMMY_EXEC" -c "$MOMMY_CONFIG_FILE" true 2>&1)
                output2=$("$MOMMY_EXEC" -c "$MOMMY_CONFIG_FILE" true 2>&1)
                output3=$("$MOMMY_EXEC" -c "$MOMMY_CONFIG_FILE" true 2>&1)
                output4=$("$MOMMY_EXEC" -c "$MOMMY_CONFIG_FILE" true 2>&1)
                output5=$("$MOMMY_EXEC" -c "$MOMMY_CONFIG_FILE" true 2>&1)

                [ "$output1" != "$output2" ] || [ "$output1" != "$output3" ] \
                                             || [ "$output1" != "$output4" ] \
                                             || [ "$output1" != "$output5" ]
                is_different="$?"

                When call test "$is_different" -eq 0
                The status should be success
            End

            It "chooses the empty string if a variable is not set"
                set_config "MOMMY_COMPLIMENTS='>%%SWEETIE%%|%%THEIR%%<';MOMMY_SWEETIE='';MOMMY_PRONOUNS=''"

                When run "$MOMMY_EXEC" -c "$MOMMY_CONFIG_FILE" true
                The error should equal ">|<"
                The status should be success
            End

            Describe "pronouns"
                It "replaces %%THEY%%"
                    set_config "MOMMY_COMPLIMENTS='>%%THEY%%<';MOMMY_PRONOUNS='front lean weekend'"

                    When run "$MOMMY_EXEC" -c "$MOMMY_CONFIG_FILE" true
                    The error should equal ">front<"
                    The status should be success
                End

                It "replaces %%THEM%%"
                    set_config "MOMMY_COMPLIMENTS='>%%THEM%%<';MOMMY_PRONOUNS='paint heighten well'"

                    When run "$MOMMY_EXEC" -c "$MOMMY_CONFIG_FILE" true
                    The error should equal ">heighten<"
                    The status should be success
                End

                It "replaces %%THEIR%%"
                    set_config "MOMMY_COMPLIMENTS='>%%THEIR%%<';MOMMY_PRONOUNS='sink satisfy razor'"

                    When run "$MOMMY_EXEC" -c "$MOMMY_CONFIG_FILE" true
                    The error should equal ">razor<"
                    The status should be success
                End

                It "chooses a consistent set of pronouns"
                    set_config "MOMMY_COMPLIMENTS='>%%THEY%%.%%THEM%%.%%THEIR%%<';MOMMY_PRONOUNS='a b c/d e f'"

                    When run "$MOMMY_EXEC" -c "$MOMMY_CONFIG_FILE" true
                    The error should match pattern ">a.b.c<|>d.e.f<"
                    The status should be success
                End
            End
        End

        Describe "capitalization"
            It "changes the first character to lowercase if configured to 0"
                set_config "MOMMY_COMPLIMENTS='Alive station';MOMMY_CAPITALIZE='0'"

                When run "$MOMMY_EXEC" -c "$MOMMY_CONFIG_FILE" true
                The error should equal "alive station"
                The status should be success
            End

            It "changes the first character to uppercase if configured to 1"
                set_config "MOMMY_COMPLIMENTS='inquiry speech';MOMMY_CAPITALIZE='1'"

                When run "$MOMMY_EXEC" -c "$MOMMY_CONFIG_FILE" true
                The error should equal "Inquiry speech"
                The status should be success
            End

            It "uses the template's original capitalization if configured to the empty string"
                set_config "MOMMY_COMPLIMENTS='Medicine frighten';MOMMY_CAPITALIZE="

                When run "$MOMMY_EXEC" -c "$MOMMY_CONFIG_FILE" true
                The error should equal "Medicine frighten"
                The status should be success
            End

            It "uses the template's original capitalization if configured to anything else"
                set_config "MOMMY_COMPLIMENTS='Belong shore';MOMMY_CAPITALIZE='2'"

                When run "$MOMMY_EXEC" -c "$MOMMY_CONFIG_FILE" true
                The error should equal "Belong shore"
                The status should be success
            End
        End

        Describe "forbidden words"
            It "does not output a compliment containing the single forbidden word"
                set_config "MOMMY_COMPLIMENTS='mother search/fierce along';MOMMY_FORBIDDEN_WORDS='search'"

                When run "$MOMMY_EXEC" -c "$MOMMY_CONFIG_FILE" true
                The error should equal "fierce along"
                The status should be success
            End

            It "does not output a compliment containing at least one of the forbidden words"
                set_config "MOMMY_COMPLIMENTS='after boundary/failure school/instant delay';MOMMY_FORBIDDEN_WORDS='instant/boundary'"

                When run "$MOMMY_EXEC" -c "$MOMMY_CONFIG_FILE" true
                The error should equal "failure school"
                The status should be success
            End

            It "does not output compliments containing a forbidden phrase"
                set_config "MOMMY_COMPLIMENTS='member rid letter/rid wish over growth/member letter improve';MOMMY_FORBIDDEN_WORDS='member letter/wish over'"

                When run "$MOMMY_EXEC" -c "$MOMMY_CONFIG_FILE" true
                The error should equal "member rid letter"
                The status should be success
            End
        End

        Describe "ignore specific exit codes"
            It "by default, outputs something"
                When run "$MOMMY_EXEC" -c "$MOMMY_CONFIG_FILE" exit 0
                The error should not equal ""
                The status should be success
            End

            It "by default, outputs nothing if the exit code is 130"
                When run "$MOMMY_EXEC" -c "$MOMMY_CONFIG_FILE" exit 130
                The error should equal ""
                The status should equal 130
            End

            It "outputs something if no exit code is suppressed"
                set_config "MOMMY_IGNORED_STATUSES=''"

                When run "$MOMMY_EXEC" -c "$MOMMY_CONFIG_FILE" exit 130
                The error should not equal ""
                The status should equal 130
            End

            It "output nothing if the exit code is the configured value"
                set_config "MOMMY_IGNORED_STATUSES='32'"

                When run "$MOMMY_EXEC" -c "$MOMMY_CONFIG_FILE" exit 32
                The error should equal ""
                The status should equal 32
            End

            It "does not output anything if the exit code is one of the configured values"
                set_config "MOMMY_IGNORED_STATUSES='32/84/89'"

                When run "$MOMMY_EXEC" -c "$MOMMY_CONFIG_FILE" exit 84
                The error should equal ""
                The status should equal 84
            End
        End
    End
End
