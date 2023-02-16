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
cp src/main/sh/install.sh src/main/sh/mommy src/main/resources/mommy.1 build/
sed -i".bak" "s/%%VERSION_NUMBER%%/$version/g;s/%%MANUAL_DATE%%/$manual_date/g" build/*
gzip build/mommy.1

# Build packages
mkdir dist/
for target in "$@"; do
    echo "# Build $target"

    if [ "$target" = "raw" ]; then
        cp build/mommy "dist/mommy-$version.sh"
    elif [ "$target" = "installer" ]; then
        cd build/
        tar -czf "../dist/mommy-$version.any-system.tar.gz" "install.sh" "mommy" "mommy.1.gz"
        cd ../
    else
        fpm -t "$target" -p "dist/mommy-$version.$target" --version "$version"
    fi
done
