#!/bin/bash

file="$1"
repo="$2"

if [ -z "$repo" ]; then
	repo="$PWD"/repository
fi

if [ ! -d "$repo" ]; then
	1>&2 echo "repo: repository folder \"$repo\" does not exist"
	exit 1
fi

# Permission checks:
# repository: x, data: x, data/$file: r, backup: wx

if [ ! -x "$repo" ]; then
	1>&2 echo "repo: Cannot access \"$repo\" as the necessary permissions are not available"
	exit 1
fi

if [ ! -x "$repo"/data ]; then
	1>&2 echo "repo: Cannot access data in \"$repo\" as the necessary permissions are not available"
	exit 1
fi

if [ ! -e "$repo"/data/"$file" ]; then
	1>&2 echo "repo: Cannot back up \"$file\" as it deos not exist"
	exit 1
fi

if [ ! -r "$repo"/data/"$file" ]; then
	1>&2 echo "repo: Cannot access \"$file\" in \"$repo\" as the necessary permissions are not available (Cannot copy file)"
	exit 1
fi

if [ ! -w "$repo"/backup/ ] || [ ! -x "$repo"/backup/ ]; then
	1>&2 echo "repo: Cannot backup \"$file\" in \"$repo\ as the necessary permissions are not available (Cannot create backup file)"
	exit 1
fi

backup_file="$repo"/backup/"$file"."$(date +%Y-%m-%dT%H:%M:%S)"

# The system time can be changed fairly easily, so it's not sufficient to disambiguate between files with identical names. This snippet appends a unique suffix in case of name conflict
renamed_file="$backup_file"
suffix=2
while [ -e "$renamed_file" ]; do
	renamed_file="$backup_file($suffix)"
	((++suffix))
done

cp "$repo"/data/"$file" "$renamed_file"
