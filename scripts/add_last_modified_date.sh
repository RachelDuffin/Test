#!/bin/sh

FILES="$(git ls-files docs)"
MAXLEN=0
IFS="$(printf "\n\b")"
for f in $FILES; do
    if [ ${#f} -gt $MAXLEN ]; then
        MAXLEN=${#f}
    fi
done
for f in $FILES; do
    str="$(git log -1 --pretty=format:"%cd" --date=format:'%Y-%m-%d %H:%M:%S' $f)"
    sed -i "s/.*last_modified_date:.*/last_modified_date: $str/" "$f"
    printf "%-${MAXLEN}s %s\n" "$f" "$str"
done


