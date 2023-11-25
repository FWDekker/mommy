this directory contains files used by external build servers~

## obs
obs is for [openbuildservice](https://build.opensuse.org/package/show/home:fwdekker:mommy/mommy), which works by looking
at the `_service` file (stored in the build server's own repo), which itself states that obs should download this repo,
extract the `pkg/obs/` directory, and then run [`obs-build`](https://github.com/openSUSE/obs-build).
there are two entry points:
* `mommy.dsc` for deb-based outputs, in total using the following files:
  * `debian.changelog` is the changelog,
  * `debian.compat` describes the
    [debhelper compatibility level](https://www.debian.org/doc/manuals/maint-guide/dother.en.html#compat),
  * `debian.control` describes the build logic,
  * `debian.rules` is a sort of makefile for
    [debhelper](https://manpages.debian.org/testing/debhelper/debhelper.7.en.html),
  * and `mommy.dsc` contains build-independent metadata; and
* `mommy.spec` for rpm-based outputs~

the whole architecture here was heavily inspired (which means: basically copied) from
[mpz](https://build.opensuse.org/package/show/home:oleg_antonyan/mpz)~

## rpkg
rpkg is for [copr](https://copr.fedorainfracloud.org/coprs/fwdekker/mommy/), which works by downloading this repo,
`cd`ing into `pkg/rpkg`, and then running [rpkg](https://pagure.io/rpkg-util)~
