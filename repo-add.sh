#!/bin/bash

file="$1"
repo="$2"

if [ ! -e "$file" ]; then
	1>&2 echo "repo: \"$file\" does not exist"
	exit 1
fi

filepath=$(realpath "$file")
filedir=$(dirname "$filepath")

if [ -z "$repo" ]; then
	repo="$PWD"/repository
fi

if [ ! -d "$repo" ]; then
	1>&2 echo "repo: Missing repository in $PWD/repository"
	exit 1
fi

# Permission checks:
# repository:x, data:wx, $filedir:wx, events.log:w, $filepath (only if $filepath is a folder):w

if [ ! -x "$repo" ]; then
	1>&2 echo "repo: Missing permissions to move into repository"
	exit 1
fi

if [ ! -x "$repo"/data ] || [ ! -w "$repo"/data ]; then
	1>&2 echo "repo: MIssing permissions to update repository data"
	exit 1
fi

if [ ! -w "$filedir" ] || [ ! -x "$filedir" ]; then
	1>&2 echo "repo: Missing permissions to move from \"$filedir\""
	exit 1
fi

if [ -d "$filepath" ]; then
	if [ ! -w "$filepath" ]; then # Moving a folder requires write permissions, to modify the .. link inside it.
		echo "repo: Missing permissions to move selected folder"
		exit 1
	fi
fi

if [ ! -w "$repo"/events.log ]; then
	1>&2 echo "repo: Missing permissions to update events log. File won't be added"
	exit 1
fi

mv "$filepath" "$repo"/data/"$file"
echo "$(date): $USER added \"$file\"" >> "$repo"/events.log
