#!/usr/bin/env bash
set -e

# Find sed
if [ -x "$(command -v gsed)" ]; then
    my_sed="gsed"
else
    my_sed="sed"
fi

# Load configuration
version=$(cat version)
manual_date=$(git log -1 --pretty="format:%cs" src/main/resources/mommy.1)

# Clean up
rm -rf build/
rm -rf dist/

# Prepare build
mkdir build/
cp src/main/sh/mommy src/main/resources/mommy.1 build/
"$my_sed" -i".bak" "s/%%VERSION_NUMBER%%/$version/g;s/%%MANUAL_DATE%%/$manual_date/g" build/*
gzip build/mommy.1

# Build packages
mkdir dist/

for target in "$@"; do
    echo "# Build $target"

    # Pre
    if [ "$target" = "p5p" ]; then
        # Solaris does not support pre-release labels in version number
        version="${version%%-*}"
    fi

    # Process
    if [ "$target" = "p5p" ]; then
        # Mommy does not (yet) support manual pages on Solaris
        fpm -t "$target" -p "dist/mommy-$version.$target" --version "$version" \
            build/mommy=/usr/bin/mommy
    else
        fpm -t "$target" -p "dist/mommy-$version.$target" --version "$version" \
            build/mommy=/usr/bin/mommy \
            build/mommy.1.gz=/usr/share/man/man1/mommy.1.gz
    fi

    # Post
    if [ "$target" = "pkgin" ]; then
        # fpm writes to wrong location
        mv "mommy-$version-1.tgz" "dist/mommy-$version.$target"
    elif [ "$target" = "tar" ]; then
        # Compress
        gzip dist/*.tar
    fi
done
