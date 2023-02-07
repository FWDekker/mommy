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

# Build packages
mkdir dist/

echo "# Build sh"
fpm -t sh -p "dist/mommy-$version.installer.sh" --version "$version"

for target in apk deb rpm tar; do
    echo "# Build $target"
    fpm -t "$target" -p "dist/mommy-$version.$target" --version "$version"
done
