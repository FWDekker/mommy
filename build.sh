#!/usr/bin/env bash
set -e

# Load configuration
version=$(cat version)
manual_date=$(git log -1 --pretty="format:%cs" src/main/resources/mommy.1)

# Clean up
rm -rf build/
rm -rf dist/

# Prepare build
mkdir build/
cp src/main/sh/mommy src/main/resources/mommy.1 build/
sed -i".bak" "s/%%VERSION_NUMBER%%/$version/g;s/%%MANUAL_DATE%%/$manual_date/g" build/*
gzip build/mommy.1

# Build packages
mkdir dist/
for target in "$@"; do
    echo "# Build $target"
    fpm -t "$target" -p "dist/mommy-$version.$target" --version "$version"

    if [ "$target" = "pkgin" ]; then
        # fpm writes to wrong location for NetBSD
        mv "mommy-$version-1.tgz" "dist/mommy-$version.$target"
    elif [ "$target" = "tar" ]; then
        # Compress tar
        gzip dist/*.tar
    fi
done
