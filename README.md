# mommy
mommy's here to support you~ ❤️

## Installation
Download the [latest release](https://github.com/FWDekker/mommy/releases/latest) for your platform and install as usual~

For example, on Debian-like systems (including Ubuntu), run
```shell
sudo apt install ./mommy-0.0.2.deb
```

## Usage
Run any command you want, but prepend it with `mommy`~

```shell
$> mommy npm test

> little-girls-tests@1.4.13 test
> mocha -r ts-node/register -r jsdom-global/register src/**/*.spec.ts



  my tests :3
    1) maths


  0 passing (8ms)
  1 failing

  1) my tests :3
       maths:

      AssertionError: expected 7 to equal 6
      + expected - actual

      -7
      +6
      
      at Context.<anonymous> (src/test/Path.spec.ts:10:26)
      at processImmediate (node:internal/timers:471:21)




mommy knows her little girl can do better~ ❤

```

## Configuration
Mommy will carefully read `~/.config/mommy/config.sh` to give you the bestest messages~ ❤

* `MOMMY_LITTLE` is what mommy calls you~ (default: "girl")
* `MOMMY_PRONOUNS` is what mommy uses for themselves~ (default: "her")
* `MOMMY_ROLES` is what mommy's role will be~ (default: "mommy")

All these options can take a `/`-separated list, and mommy will select the one she feels like using whenever she talks to you~

For example, if the file `~/.config/mommy/config.sh` looks like
```shell
MOMMY_LITTLE=boy/pet/baby
MOMMY_PRONOUNS=his/their
MOMMY_ROLES=daddy
```
then mommy might say any of
* `daddy loves his little baby~ ❤`
* `daddy loves their little pet~ ❤`
* `daddy loves their little boy~ ❤`

## Development
All you need to build your own mommy is `build-essential`, `rpm`, and `squashfs-tools`, and then you just run `build.sh`~

## Acknowledgements
Mommy was very much inspired by [cargo-mommy](https://github.com/Gankra/cargo-mommy)~
