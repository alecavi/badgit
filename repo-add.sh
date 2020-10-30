#!/bin/bash

file="$1"

if [ ! -e "$file" ]; then
	1>&2 echo "repo: Invalid file \"$file\""
	exit 1
fi

repo="$PWD"/repository

# Permission checks:
# repository:x, data:wx, PWD:wx, events.log:w, PWD/$file (only if $file is a folder):w

if [ ! -d "$repo" ]; then
	1>&2 echo "repo: Missing repository in $PWD/repository"
	exit 1
fi

if [ ! -w "$repo" ] || [ ! -x "$repo" ]; then # Moving a file requires write and execute permissions on the "from" and "to" folders
	1>&2 echo "repo: Missing permissions to move into repository"
	exit 1
fi

if [ ! -w "$PWD" ] || [ ! -x "$PWD" ]; then
	1>&2 echo "repo: Missing permissions to move from folder"
	exit 1
fi

if [ -d "$PWD"/"$file" ]; then
	if [ ! -w "$PWD"/"$file" ]; then # Moving a folder requires write permissions, to modify the .. link inside it.
		echo "repo: Missing permissions to move selected folder"
		exit 1
	fi
fi

if [ ! -w "$repo"/events.log ]; then
	1>&2 echo "repo: Missing permissions to update events log. File won't be added"
	exit 1
fi

mv "$file" "$repo"/data/"$file"
echo "$(date): Added \"$file\"" >> "$repo"/events.log
