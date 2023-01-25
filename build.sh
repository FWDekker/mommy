#!/bin/bash
set -e

# Load configuration
version=$(cat version)

# Clean up
rm -rf build/
rm -rf dist/

# Prepare build
cp -r src/ build/
find build/ -type f -exec sed -i "s/%%VERSION_NUMBER%%/$version/g" {} \;

# Build packages
mkdir dist/

for target in apk deb rpm sh tar; do
    echo "# Build $target"
    fpm -t $target -p dist/mommy-$version.$target --version $version
done
