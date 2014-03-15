#! /bin/sh

# Append any prefix from PKG_CONFIG_PATH to ACLOCAL_PATH
OLDIFS=IFS
IFS=':'
for dir in $PKG_CONFIG_PATH; do
    acdir="$dir/../../share/aclocal"
    [ -x "$acdir" ] && ACLOCAL_PATH="${ACLOCAL_PATH}:$acdir"
done
IFS=OLDIFS
export ACLOCAL_PATH

autoreconf -fi && ./configure "$@"
