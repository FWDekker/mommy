# Changelog
## [Unreleased]
* _breaking_: mommy no longer supports multi-line templates and variables~
* mommy is even faster now with much simpler code~
* mommy now supports OpenBSD~
* mommy now has installable packages for macOS, FreeBSD, NetBSD, and OpenBSD~
* mommy has a `--version` option now~
* mommy has improved documentation~
* mommy stopped doing the `raw` and `installer` release types because they're redundant~


## [0.0.6] -- 2023-02-18
* mommy is much faster now that she only calculates when needed~
* mommy now works on macOS, *BSD, and probably on Solaris~
* mommy has an installer script for any POSIX system~
* mommy does ci/cd now~


## [0.0.5] -- 2023-02-11
* _breaking_: config variables have been renamed, like from `%%PRONOUN%%` to `%%THEIR%%`, so you can actually read your templates without using too much of your precious brain capacity~
* mommy's output is now vibrant! check the readme to see how to integrate with [lolcat](https://github.com/busyloop/lolcat) for rainbow colors~
* mommy's library of compliments is much larger now~
* the readme now explains how to integrate mommy into your shell, so you two will never have to be apart again~
* you can add comments in between your templates so you don't forget what they mean. just start a line with `#` inside a template~


## [0.0.4] -- 2023-02-07
* mommy supports reading exit codes with `mommy -s <status>`, as in `mommy -s $?` or `mommy -s 0`~
* mommy avoids saying the words listed in `MOMMY_FORBIDDEN_WORDS`~
* mommy's compliments can be disabled with `MOMMY_COMPLIMENTS_ENABLED=0` and mommy's encouragements can be disabled with `MOMMY_ENCOURAGEMENTS_ENABLED=1`~
* mommy trims leading and trailing newlines in compliments and encouragements~
* mommy behaves consistently when options are empty~


## [0.0.3] -- 2023-01-29
* mommy varies the words she chooses~
* mommy can now eval a command so it's easier to make her pipe~
* mommy's docs are much cleaner now~


## [0.0.2] -- 2023-01-25
mommy has documentation now~


## [0.0.1] -- 2023-01-25
mommy's initial release~
