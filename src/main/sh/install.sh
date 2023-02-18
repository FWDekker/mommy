#!/bin/sh
set -e
cd -P -- "$(dirname -- "$0")"

# Defaults
sh_path_default="/usr/local/bin/mommy"
doc_path_default="/usr/local/share/man/man1/mommy.1.gz"

# Help
if [ "$1" = "-h" ] || [ "$1" = "--help" ]; then
    echo "installs mommy~"
    echo ""
    echo "by default, copies the shell script to '$sh_path_default' and the manual page to '$doc_path_default'. \
to change these paths, specify them as arguments to this script. \
for example, the default settings correspond to running './install.sh \"$sh_path_default\" \"$doc_path_default\"'.
setting an argument to an empty string means the default value is used~"
    echo ""
    echo "additionally, if you set the third argument to '-y', the installer does not ask for confirmation."
    exit 0
fi

# Read config
[ -z "$1" ] && sh_path="$sh_path_default" || sh_path="$1"
[ -z "$2" ] && doc_path="$doc_path_default" || doc_path="$2"

# Confirmation
if [ "$3" = "-y" ]; then
    echo "installing script to '$sh_path' and docs to '$doc_path'~"
else
    printf "%s" "install script to '$sh_path' and docs to '$doc_path'? (y/n) "
    read -r confirm
    if [ ! "$confirm" = "y" ] && [ ! "$confirm" = "Y" ]; then
        echo "kbye~"
        exit 1
    fi
fi

# Install
[ ! -d "$(dirname "$sh_path")" ] && mkdir -p "$(dirname "$sh_path")"
[ ! -d "$(dirname "$doc_path")" ] && mkdir -p "$(dirname "$doc_path")"

cp "./mommy" "$sh_path"
cp "./mommy.1.gz" "$doc_path"

# Done
echo "mommy installed successfully~"
exit 0
