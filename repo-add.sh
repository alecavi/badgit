#!/bin/bash

file=$1

if [ -z "$file" ]; then
	1>&2 echo "repo: Invalid argument: \"from\""
	exit 1
fi

if [ ! -d "$PWD"/repository ]; then
	1>&2 echo "repo: Missing repository in $PWD/repository"
	exit 1
fi

repo="$PWD"/repository

handle_err() {
	if [ $? -ne 0 ]; then
		1>&2 echo "repo: Couldn't add file: internal error"
		exit 1
	fi
}

mv "$file" "$repo"/data/"$file"
handle_err
echo "$(date): Added \"$file\"" >> "$repo"/events.log
