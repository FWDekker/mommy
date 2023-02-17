#!/bin/sh
set -e
cd -P -- "$(dirname -- "$0")"

# Load configuration
version="$(cat version)"
manual_date="$(git log -1 --pretty="format:%cs" src/main/resources/mommy.1)"

# Clean
rm -rf build/ dist/

# Prepare
mkdir build/
cp src/main/sh/install.sh src/main/sh/mommy src/main/resources/mommy.1 build/
sed -i".bak" "s/%%VERSION_NUMBER%%/$version/g;s/%%MANUAL_DATE%%/$manual_date/g" build/*
gzip build/mommy.1

# Build
mkdir dist/
for target in "$@"; do
    echo "# Build $target"

    case "$target" in
    raw)
        cp build/mommy "dist/mommy-$version.sh"
        ;;
    installer)
        # To extract from project root directory into `./installer/`, run:
        #   tar -xvzf dist/mommy-*.any-system.tar.gz --one-top-level=installer

        cd build/
        tar -czf "../dist/mommy-$version.any-system.tar.gz" "install.sh" "mommy" "mommy.1.gz"
        cd -
        ;;
    *)
        fpm -t "$target" -p "dist/mommy-$version.$target" --version "$version"
        ;;
    esac
done
