#!/bin/bash
set -e

# Load configuration
version=$(cat version)

# Clean up
rm -rf build/
rm -rf dist/

# Prepare build
mkdir build/
cp src/main/sh/mommy src/main/resources/mommy.1 build/
find build/ -type f -exec sed -i "s/%%VERSION_NUMBER%%/$version/g" {} \;
gzip build/mommy.1

# Build packages
mkdir dist/

for target in apk deb rpm tar; do
    echo "# Build $target"
    fpm -t "$target" -p "dist/mommy-$version.$target" --version "$version"
done
