. ./helper.sh


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
