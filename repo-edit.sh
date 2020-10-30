#!/bin/bash

file="$1"
repo="$PWD"/repository

if [ ! -d "$repo" ]; then
	1>&2 echo "repo: repository folder not found"
	exit 1
fi

file_in_repo="$repo"/data/"$file"
checked_out="$repo"/checked_out/

# Permission checks:
# repository: x, data: wx, checked_out: x, $file_in_repo: rw, events.log: w

if [ ! -x "$repo" ]; then
	1>&2 echo "repo: Cannot access repository folder as the necessary permissions are not available"
	exit 1
fi

if [ ! -w "$repo"/data ] || [ ! -x "$repo"/data ]; then
	1>&2 echo "repo: Cannot access repository data as the necessary permissions are not available"
	exit 1
fi

if [ ! -x "$checked_out" ]; then
	1>&2 echo "repo: Cannot access checkout information as the necessary permissions are not available"
	exit 1
fi

if [ ! -e "$file_in_repo" ]; then 
	1>&2 echo "repo: Cannot edit \"$file\" as it doesn't exist in the repository"
	exit 1
fi

if [ ! -r "$file_in_repo" ] || [ ! -w "$file_in_repo" ]; then
	1>&2 echo "repo: Cannot edit \"$file\" as the necessary permissions are not available"
	exit 1
fi

if [ ! -w "$repo"/events.log ]; then
	1>&2 echo "repo: Cannot update events log as the necessary permisisons are not available"
	exit 1
fi

if [ -e "$checked_out"/file ]; then
	1>&2 echo "repo: cannot open \"$file\" as it's checked out"
	exit 1
fi

"${EDITOR:-vi}" "$file_in_repo"
echo "$(date): Edited \"$file\"" >> "$repo"/events.log
