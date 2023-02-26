#!/bin/sh
set -e
cd -P -- "$(dirname -- "$0")"

# Load configuration
version="$(head -n 1 ./version)"
date="$(tail -n 1 ./version)"

# Clean
rm -rf build/ dist/

# Prepare
mkdir build/
cp src/main/sh/mommy src/main/resources/mommy.1 build/
sed -i".bak" "s/%%VERSION_NUMBER%%/$version/g;s/%%VERSION_DATE%%/$date/g" build/*
gzip build/mommy.1

# Build
mkdir dist/
for target in "$@"; do
    echo "# Build $target"

    # Select targets
    case "$target" in
    brew_install)
        target_exe="build/mommy=${PREFIX:?Prefix not specified}/bin/mommy"
        target_man="build/mommy.1.gz=$PREFIX/share/man/man1/mommy.1.gz"
        ;;
    netbsd)
        target_exe="build/mommy=/usr/pkg/bin/mommy"
        target_man="build/mommy.1.gz=/usr/pkg/man/man1/mommy.1.gz"
        ;;
    osxpkg)
        target_exe="build/mommy=/usr/local/bin/mommy"
        target_man="build/mommy.1.gz=/usr/local/share/man/man1/mommy.1.gz"  # `/usr/local/man` is not on macOS manpath
        ;;
    *)
        target_exe="build/mommy=/usr/local/bin/mommy"
        target_man="build/mommy.1.gz=/usr/local/man/man1/mommy.1.gz"
        ;;
    esac

    # Pre-process
    case "$target" in
    brew_install)
        # Do nothing
        ;;
    netbsd|openbsd)
        # Extract properties
        comment="$(<"./.fpm" grep -- "--description")"
        comment="$(echo "${comment#* }" | tr -d "\"")"

        maintainer="$(<"./.fpm" grep -- "--maintainer")"
        maintainer="$(echo "${maintainer#* }" | tr -d "\"")"

        # Prepare tmp directory
        rm -rf /tmp/mommy
        mkdir -p /tmp/mommy

        # Copy input files
        mkdir -p "/tmp/mommy/$(dirname "${target_exe#*=}")" "/tmp/mommy/$(dirname "${target_man#*=}")"
        cp "./${target_exe%%=*}" "/tmp/mommy/${target_exe#*=}"
        cp "./${target_man%%=*}" "/tmp/mommy/${target_man#*=}"

        # Create control files
        cd /tmp/mommy

        ## Comment
        echo "$comment" >> ./+COMMENT

        ## Description
        {
            echo "$comment"
            echo ""
            echo "Maintainer: $maintainer"
        } >> ./+DESC

        ## Pack file
        {
            echo "./${target_exe#*=}"
            echo "./${target_man#*=}"
        } >> ./+CONTENTS

        # Build info
        if [ "$target" = "netbsd" ]; then
            {
                echo "MACHINE_ARCH=$(uname -p)"
                echo "OPSYS=$(uname)"
                echo "OS_VERSION=$(uname -r)"
                echo "PKGTOOLS_VERSION=$(pkg_create -V)"
            } >> ./+BUILD_INFO
        fi

        cd -
        ;;
    *)
        # Do nothing
        ;;
    esac

    # Process
    case "$target" in
    brew_install)
        mkdir -p "$(dirname "${target_exe#*=}")" "$(dirname "${target_man#*=}")"
        cp "./${target_exe%%=*}" "${target_exe#*=}"
        cp "./${target_man%%=*}" "${target_man#*=}"
        ;;
    netbsd)
        cd /tmp/mommy
        pkg_create \
            -B ./+BUILD_INFO \
            -c ./+COMMENT \
            -d ./+DESC \
            -f ./+CONTENTS \
            -I / \
            -p . \
            "./mommy-$version+netbsd.tgz"
        cd -
        mv /tmp/mommy/mommy*.tgz ./dist/
        ;;
    openbsd)
        cd /tmp/mommy
        pkg_create \
            -d ./+DESC \
            -D COMMENT="$comment" \
            -D FULLPKGPATH="mommy-$version+netbsd" \
            -f ./+CONTENTS \
            -B /tmp/mommy \
            -p / \
            "./mommy-$version+openbsd.tgz"
        cd -
        mv /tmp/mommy/mommy*.tgz ./dist/
        ;;
    *)
        fpm -t "$target" -p "./dist/mommy-$version.$target" --version "$version" "$target_exe" "$target_man"
        ;;
    esac

    # Post-process
    case "$target" in
    brew_install)
        # Do nothing
        ;;
    netbsd|openbsd)
        # Clean up
        rm -rf /tmp/mommy
        ;;
    osxpkg)
        # `installer` program requires `pkg` extension
        mv ./dist/*.osxpkg "./dist/mommy-$version+osx.pkg"
        ;;
    esac
done
