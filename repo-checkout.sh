#!/bin/bash

if [ ! -d "$PWD"/repository ]; then
	1>&2 echo "repo: repository folder not found"
	exit 1
fi

file=$1
if [ -z file ]; then
	1>&2 echo "repo: Invalid file"
	exit 1
fi

checked_out="$PWD"/repository/checked_out/"$file"

if [ -e "$checked_out" ]; then
	echo "repo: Cannot check out \"$file\": it is already checked out"
	exit 1
fi

touch "$checked_out"
if [ $? -ne 0 ]; then
	1>&2 echo "repo: Couldn't set \"$file\" as checked out. File won't be checked out."
	exit 1
fi

cp "$checked_out" "$PWD"/"$file"
if [ $? -ne 0 ]; then
	1>&2 echo "repo: Couldn't check out \"$file\""
	rm "$checked_out"
	if [$? -ne 0 ]; then
		1>&2 echo "Couldn't cleanup checkout info. \"$file\" will still be considered checked out"
	fi
	exit 1
fi

echo "$(date): file \"$file\" has been checked out" >> events.log

exit 0
