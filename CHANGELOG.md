# Changelog
## [1.2.3] -- 2023-03-14
### added
* 🎩 mommy is now available for fedora, red hat, and other rpm-based systems via [copr](https://copr.fedorainfracloud.org/)~ ([#39](https://github.com/FWDekker/mommy/issues/39))
* 🪟 mommy is now tested on msys2 for windows~ ([#54](https://github.com/FWDekker/mommy/issues/54))
* 💥 mommy's makefile now has an `uninstall` option~

### changed
* ✍️ mommy rewrote the installation instructions~ ([#51](https://github.com/FWDekker/mommy/issues/51))
* 🐙 mommy links to github if `man` doesn't work~ ([#55](https://github.com/FWDekker/mommy/issues/55)) 

### fixed
* ✏️ mommy fixed some minor errors in the readme~
* ♻️ mommy hopefully fixed automatic synchronous releases for homebrew and aur~


## [1.2.2] -- 2023-03-09
### added
* 🐟 mommy has shell completions for fish and zsh~  
  they are enabled by default on most machines. if you installed mommy with brew, check the [brew documentation on how to enable shell completions](https://docs.brew.sh/Shell-Completion)~ ([#43](https://github.com/FWDekker/mommy/issues/43)) ([#48](https://github.com/FWDekker/mommy/pull/48))

### changed
* 🤖 mommy no longer talks like a robot when unknown options are used~
  ([#47](https://github.com/FWDekker/mommy/pull/47))
* ⚗️ mommy's build system has been revamped~
  ([#38](https://github.com/FWDekker/mommy/issues/38)) ([#42](https://github.com/FWDekker/mommy/issues/42))
* ⭐ mommy has a bunch more emoji in her readme~
  ([#40](https://github.com/FWDekker/mommy/issues/40))

### fixed
* 📁 mommy installs herself into `/usr/bin` instead of `/usr/local/bin` on linux, to comply with the standards of various operating systems~
* 💪 mommy better tolerates missing optional dependencies when installing from aur~


## [1.2.1] -- 2023-02-26
* mommy supports homebrew now~
* mommy supports arch linux aur now~


## [1.2.0] -- 2023-02-24
* mommy can output to stdout without redirection by giving her the `-1` option~
* mommy ignores exit code `130` by default, but you can change this by setting `MOMMY_IGNORED_STATUSES`~
* mommy supports prefixes for her messages, and explains how to use them to get colors in zsh~
* mommy improved her readme a bit~


## [1.1.0] -- 2023-02-24
* _breaking_: mommy supports different pronoun forms.  
  instead of `MOMMY_THEIR="her"` and using variable `%%THEIR%%`, you should now write `MOMMY_PRONOUN="she her her"` and use variables `%%THEY%%`, `%%THEM%%`, and `%%THEIR`~


## [1.0.0] -- 2023-02-23
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
