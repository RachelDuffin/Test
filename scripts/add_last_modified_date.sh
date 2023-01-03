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
    file_modified_date=$(sed -n "/.*last_modified_date:.*/ p" $f)
    echo "Modified date in file: $file_modified_date"
    str="$(git log -1 --pretty=format:"%cd" --date=format:'%Y-%m-%d %H:%M:%S' $f)"
    echo "Modified date in git log: $str"
    if [[ "$file_modified_date" =~ .*"$str".* ]]; then
      echo "File has not been modified: $f"
    else
      printf "%-${MAXLEN}s %s\n File modified since last pull request:" "$f" "$str"
      sed -i "s/.*last_modified_date:.*/last_modified_date: $str/" "$f"
    fi
done


