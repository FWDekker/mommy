# mommy
mommy's here to support you~ ❤️

mommy is fully customizable, integrates with any shell, works on any unix system, and most importantly, loves you very
much~

![mommy demo](.github/demo.gif)


## installation
mommy works on any unix system.
mommy is tested on ubuntu, debian, macos, freebsd, netbsd, and openbsd~

[download the latest release](https://github.com/FWDekker/mommy/releases/latest) for your platform and install as usual:
* on debian/ubuntu/etc, run `sudo apt install ./mommy-*.deb`,
* on red hat/fedora/etc, run `sudo dnf install ./mommy-*.rpm`,
* on archlinux, run `sudo pacman -U ./mommy-*.pacman`,
* on alpine linux, run `sudo apk add --allow-untrusted ./mommy-*.apk`,
* on macos, run `sudo installer -pkg ./mommy*+osx.pkg -target /`,
* on freebsd, run `pkg add ./mommy-*.freebsd`,
* on netbsd, run `pkg_add ./mommy-*+netbsd.tgz`,
* on openbsd, run `pkg_add -D unsigned ./mommy-*+openbsd.tgz`,
* on other unix systems, download and extract the source code `.zip`, and copy `./src/main/sh/mommy` into the
  appropriate directory
  (usually `/usr/local/bin/`)
  (and optionally also copy `./src/main/resources/mommy.1` into `/usr/local/man/man1/`)

after installation, you can [configure mommy](#configuration) and [integrate mommy with your shell](#shell-integration)~

to update mommy, just repeat the installation process~

![mommy integrated with the fish shell](.github/sample1.png)


## usage
mommy integrates with your normal command-line usage and compliments you if the command succeeds and encourages you if
it fails~

```shell
$ mommy [-c config] [command] ...
# e.g. `mommy npm test`

$ mommy [-c config] -e eval
# e.g. `mommy -e "ls -l | wc -l"`

$ mommy [-c config] -s status
# e.g. `mommy -s $?`
```


## configuration
mommy's behavior can be configured by defining variables in `~/.config/mommy/config.sh`.
or specify a different config file with `mommy -c ./my_config.sh [other options]`~

### config file format
mommy executes the config file as a shell script and keeps the environment variables.
so, to change the value of `MOMMY_PRONOUN`, add the following line to your config file:
```shell
MOMMY_PRONOUN="their"
```
make sure you do not put spaces around the `=`~

### available settings
| variable                       | description                                                                                                                                                                                                                                                                                                                                                  | list? | default      |
|--------------------------------|--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|-------|--------------|
| `MOMMY_CAREGIVER`              | what mommy calls herself                                                                                                                                                                                                                                                                                                                                     | yes   | `mommy`      |
| `MOMMY_THEIR`                  | mommy's pronoun for herself                                                                                                                                                                                                                                                                                                                                  | yes   | `her`        |
| `MOMMY_SWEETIE`                | what mommy calls you                                                                                                                                                                                                                                                                                                                                         | yes   | `girl`       |
| `MOMMY_SUFFIX`                 | what mommy puts at the end of each sentence                                                                                                                                                                                                                                                                                                                  | yes   | `~`          |
| `MOMMY_CAPITALIZE`             | `0` to start sentences in lowercase, `1` for uppercase, anything else to change nothing                                                                                                                                                                                                                                                                      | no    | `0`          |
| `MOMMY_COLOR`                  | color of mommy's text. you can use any [xterm color code](https://upload.wikimedia.org/wikipedia/commons/1/15/Xterm_256color_chart.svg), or write `lolcat` to use [lolcat](https://github.com/busyloop/lolcat) (install separately). specify multiple colors separated by `/` to randomly select one. set to empty string for your terminal's default color. | yes   | `005`        |
| `MOMMY_COMPLIMENTS`            | default compliment templates                                                                                                                                                                                                                                                                                                                                 | yes   | &lt;various> |
| `MOMMY_COMPLIMENTS_EXTRA`      | additional compliment templates you can specify                                                                                                                                                                                                                                                                                                              | yes   | &lt;empty>   |
| `MOMMY_COMPLIMENTS_ENABLED`    | `1` to enable compliments, anything else to disable                                                                                                                                                                                                                                                                                                          | no    | `1`          |
| `MOMMY_ENCOURAGEMENTS`         | default encouragement templates                                                                                                                                                                                                                                                                                                                              | yes   | &lt;various> |
| `MOMMY_ENCOURAGEMENTS_EXTRA`   | additional encouragement templates you can specify                                                                                                                                                                                                                                                                                                           | yes   | &lt;empty>   |
| `MOMMY_ENCOURAGEMENTS_ENABLED` | `1` to enable encouragements, anything else to disable                                                                                                                                                                                                                                                                                                       | no    | `1`          |
| `MOMMY_FORBIDDEN_WORDS`        | mommy will not use templates that contain forbidden / trigger words                                                                                                                                                                                                                                                                                          | yes   | &lt;empty>   |

### lists
some of these settings support lists.
mommy chooses a random element from each list each time she is called by you.
(except for `MOMMY_FORBIDDEN_WORDS`, where all elements of the list are always forbidden.)
in a list, elements are separated by a newline or by a `/`.
elements that contain whitespace only, and elements that start with a `#` are ignored~

* for example, if you set
  ```shell
  MOMMY_SWEETIE="girl/kitten"
  ```
  then mommy will sometimes call you `girl`, and sometimes `kitten`~
* if you set
  ```shell
  MOMMY_PRONOUN="their
  faer/#her/its"
  ```
  then mommy will use pronouns `their`, `faer`, and `its`, but not `her`~
* if you set
  ```shell
  MOMMY_FORBIDDEN_WORDS="cat/dog"
  ```
  then mommy will never use templates that contain `cat`, and will never use templates that contain `dog`~

### custom templates
if you change `MOMMY_COMPLIMENTS` in your config file, then you lose the default compliments that mommy knows.
if you want both the default and your own compliments, add your own compliments to `MOMMY_COMPLIMENTS_EXTRA`.
similarly so for encouragements~

### template variables
inside compliments and encouragements, you can put placeholders that contain the random values that mommy chose.
for example, if you add the compliment `%%CAREGIVER%% loves you`, and `MOMMY_CAREGIVER=your mommy`, then mommy outputs
`your mommy loves you`~

| variable        | description                 |
|-----------------|-----------------------------|
| `%%CAREGIVER%%` | what mommy calls herself    |
| `%%THEIR%%`     | mommy's pronoun for herself |
| `%%SWEETIE%%`   | what mommy calls you        |

### renaming the mommy executable
if you want to write `daddy npm test` instead of `mommy npm test`, you can just create a symlink.
mommy is installed in slightly different locations on different systems, but you can easily find where mommy is
installed with `whereis mommy`:
```shell
$ whereis mommy
mommy: /usr/local/bin/mommy /usr/local/man/man1/mommy.1.gz
```
the exact format may differ depending on your system, but in this case you can see that the program is installed in
`/usr/local/bin/mommy` and the manual page in `/usr/local/man/man1/mommy.1.gz`.
if `whereis mommy` doesn't work, mommy is not on your path, but you can still find her with `find / -name mommy`~

anyway, after finding mommy, you can just symlink using the following commands:
(if `whereis` gave different paths than seen above, you should adapt these commands accordingly)
```shell
sudo ln -fs /usr/local/bin/mommy /usr/local/bin/daddy
sudo ln -fs /usr/local/man/man1/mommy.1.gz /usr/local/man/man1/daddy.1.gz
```

## shell integration
instead of calling mommy for each command, you can also fully integrate mommy with your shell to get mommy's output each
time you run any command.
here are some examples on how you can do that in various shells.
recall that you can add `MOMMY_COMPLIMENTS_ENABLED=0` to your mommy config file to disable compliments while keeping
encouragements~

### bash
in bash you can set
[`PROMPT_COMMAND`](https://www.gnu.org/savannah-checkouts/gnu/bash/manual/bash.html#index-PROMPT_005fCOMMAND) to run
mommy after each command.
just add the following line to `~/.bashrc`:
```shell
PROMPT_COMMAND="mommy -s \$? 2>&1; $PROMPT_COMMAND"
```

### fish
in fish you can have mommy output a message on the right side of your prompt by creating
`~/.config/fish/functions/fish_right_prompt.fish` with the following contents:
```shell
function fish_right_prompt
    mommy -s $status 2>&1
end
```
if you have an [oh my fish](https://github.com/oh-my-fish/oh-my-fish) theme installed, check the docs of your theme to
see if there's an easy way to extend the theme's right prompt.
if not, you can either overwrite it with the above code, or copy-paste the theme's code into your own config file and
then add mommy yourself~

### zsh
in zsh you can put mommy's output after each command by adding the following line to `~/.zshrc`:
```shell
precmd() { mommy -s $status 2>&1 }
```

to put mommy's output on the right side, add the following to `~/.zshrc`:
```shell
set -o PROMPT_SUBST
RPS1="\$(mommy -s \$? 2>&1)"
```

### other shells
as a generic method, in any POSIX shell (including `sh`, `ash`, `dash`, `bash`) you can change the prompt itself to
contain a message from mommy by setting the `$PS1` variable:
```shell
export PS1="\$(mommy -s \$? 2>&1)$PS1"
```
to improve the spacing, set `MOMMY_SUFFIX="~ "` in mommy's config file.
add the above line to the config file for your shell.
some shells (`dash`, `pdksh`) do not have a default (non-login) config file, so to enable that you should add the
following to `~/.profile`:
```shell
export ENV="$HOME/.shrc"
```
after that, add the line that defines `PS1` to `~/.shrc`.
log out and back in, and mommy will appear in your shell~


## development
to build your own mommy, first install the requirements.
on debian-like systems, run
```shell
sudo apt install rubygems libarchive-tools rpm zstd
sudo gem install fpm
```

after that, just run `./build.sh deb` (or better: `mommy ./build.sh deb`), and outputs appear in `dist/`.
replace `deb` with [one or more supported output types](https://fpm.readthedocs.io/en/v1.15.1/packaging-types.html).
except don't use `pkgin`, but use `openbsd` for openbsd, and use `netbsd` for netbsd~

before a new release, make sure to update the version number in `./version` and to update the `./CHANGELOG.md`~

to run tests, install [shellspec](https://github.com/shellspec/shellspec) and run `./test.sh`.
by default, tests are run against `./src/main/sh/mommy`.
to change that, set the `MOMMY_EXEC` environment variable before running tests, as in
`MOMMY_EXEC=/usr/local/bin/mommy ./test.sh`~


## acknowledgements
mommy was very much inspired by [cargo-mommy](https://github.com/Gankra/cargo-mommy)~
