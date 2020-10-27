#!/bin/bash

if [ ! -d "$PWD"/repository ]; then
	1>$2 echo "repo: repository directory not found"
	exit 1
fi

file=$1
if [ -z "$file" ]; then
	1>&2 echo "repo: invalid file"
	exit 1
fi

checked_out="$PWD"/repository/checked_out/"$file"
if [ ! -e "$checked_out" ]; then
	1>&2 echo "repo: Cannot check in \"$file\" as it was never checked out"
	exit 1
fi

mv -f "$PWD"/"$file" "$PWD"/repository/data/"$file"
if [ $? -ne 0 ]; then
	1>&2 echo "repo: Couldn't check \"$file\" in: internal error"
	exit 1
fi

rm "$checked_out"
if [ $? -ne 0 ]; then
	1>&2 echo "repo: Couldn't mark \"$file\" as checked in. The file in the repository has been updated, but will still be considered checked out"
	exit 1
fi

echo "$(date): file \"$file\" has been checked in"

exit 0
