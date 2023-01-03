#!/bin/sh

FILES="$(git ls-files docs)"

for f in $FILES; do
    file_modified_date=$(sed -n "/.*last_modified_date:.*/ p" "$f")
    echo "Modified date in file: $file_modified_date"
    str="$(git log -1 --pretty=format:"%cd" --date=format:'%Y-%m-%d %H:%M:%S' "$f")"
    echo "Modified date in git log: $str"
    if echo "$file_modified_date" | grep -q "$str"; then
      echo "File has not been modified: $f"
    else
      datetime_now=$(date +'%Y-%m-%d %H:%M:%S')
      printf "%s modified since last pull request: %s" "$f" "$str \n"
      sed -i "s/.*last_modified_date:.*/last_modified_date: $datetime_now/" "$f"
    fi
done


