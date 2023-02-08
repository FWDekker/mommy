# mommy
mommy's here to support you~ ❤️

```shell
$ mommy npm test

[bunch of failing tests here]

mommy knows her little girl can do better~
```

## installation
download the [latest release](https://github.com/FWDekker/mommy/releases/latest) for your platform and install as usual~

for example, on Debian-like systems (including Ubuntu), run
```shell
sudo apt install ./mommy-0.0.4.deb
```
and then run `mommy [your command]`~

to uninstall, just do `sudo apt remove mommy`~

## usage
put `mommy` before any command you want to run and mommy displays a compliment if it succeeds and an encouraging message
if it fails~

alternatively, use `mommy -e` to evaluate the string as a command, as in `mommy -e "npm test"`~

alternatively, use `mommy -s` to directly use an exit code, as in `mommy -s 0`~

```shell
$ mommy true
good girl~
```

```shell
$ mommy false
mommy knows her little girl can do better~
```

```shell
$ mommy -e "command1 | command2 | command 3 | command 4"
[if any command fails]
mommy knows her little girl can do better~
```

```shell
$ mommy -e "command1 | command2 | command 3 | command 4"
[if all commands succeed]
good girl~
```

```shell
$ mommy -s 0
good girl~
```

```shell
$ mommy -s 1
mommy knows her little girl can do better~
```

## configuration
mommy will carefully read the following variables from `~/.config/mommy/mommy.conf` (override using
`mommy -c ./my_config`)
to give you the bestest messages~ ❤
* `MOMMY_CAREGIVER` is how mommy calls themselves~
* `MOMMY_THEIR` is what mommy uses for themselves~
* `MOMMY_SWEETIE` is what mommy calls you~
* `MOMMY_SUFFIX` is how mommy will end all their messages~
* `MOMMY_CAPITALIZE` is `0` if mommy should start her sentences in lowercase, `1` for uppercase, and anything else to
  change nothing~
* `MOMMY_COMPLIMENTS` is the compliment mommy should give you if you did a good job~
* `MOMMY_COMPLIMENTS_EXTRA` is where you can add your own compliments without removing the default ones~
* `MOMMY_COMPLIMENTS_ENABLED` is `1` if and only if mommy should give you compliments~
* `MOMMY_ENCOURAGEMENTS` is the encouragement mommy should give you if you need help~
* `MOMMY_ENCOURAGEMENTS_EXTRA` is where you can add your own encouragements without removing the default ones~
* `MOMMY_ENCOURAGEMENTS_ENABLED` is `1` if and only if mommy should give you encouragements~
* `MOMMY_FORBIDDEN_WORDS` are words that mommy will never use in compliments and encouragements~

all these options take a `/`-separated list, and mommy will select the one they feel like using whenever they talk
to you~
also, inside variables, lines starting with \fI#\fP are ignored so you can comment and categorize your config~

in custom compliments and encouragements, you can ask mommy to use variables `%%PET_NAME%%`, `%%THEIR%%`, and
`%%ROLE%%`~

for example, if the config file looks like
```shell script
MOMMY_CAREGIVER="daddy"
MOMMY_THEIR="his/their"
MOMMY_SWEETIE="boy/pet/baby"
MOMMY_SUFFIX="~/ :3/"
MOMMY_COMPLIMENTS_EXTRA="great job, little %%SWEETIE%%/%%CAREGIVER%% is proud of you"
MOMMY_ENCOURAGEMENTS_EXTRA="
# encouragements~
/%%CAREGIVER%% is here for you
/%%CAREGIVER%% will always love you
/%%CAREGIVER%% is here if you want a hug
"
```
then mommy might compliment you with any of
* daddy loves his little baby~
* great job, little baby :3
* daddy is proud of you

and so on~

### renaming mommy
if you don't want a mommy but for example a daddy, run the following:
```shell
sudo ln -s /usr/bin/mommy /usr/bin/daddy
sudo ln -s /usr/share/man/man1/mommy.1 /usr/share/man/man1/daddy.1
```

if you update mommy, then your daddy will also be updated, but if you uninstall mommy, you should manually uninstall 
your daddy by running
```shell
sudo rm /usr/bin/daddy
sudo rm /usr/share/man/man1/daddy.1
```

## development
to build your own mommy, first install the requirements~
on Debian-like machines you can run
```shell
sudo gem install fpm
sudo apt install build-essential squashfs-tools rpm gzip
```
after that, just run `./build.sh` (though obviously you should run `mommy ./build.sh`), and outputs appear in `dist/`~

for a new release, make sure to update the version number in `./version` and `./README.md`~

to run tests, install [shellspec](https://github.com/shellspec/shellspec) and run `./test.sh`
(make that `mommy ./test.sh`)~

## acknowledgements
mommy was very much inspired by [cargo-mommy](https://github.com/Gankra/cargo-mommy)~
