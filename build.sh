#!/bin/bash
set -e

version=$(cat version)

rm -rf dist/
mkdir dist/

for target in apk deb rpm sh tar; do
    echo "# Build $target"
    fpm -t $target -p dist/mommy-$version.$target --version $version
done
