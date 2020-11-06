#!/bin/bash

repo="$1"

if [ -z "$repo" ]; then
	repo="$PWD"/repository
fi

if [ ! -x "$repo" ]; then
	1>&2 echo "repo: Cannot access the repository folder"
	exit 1
fi

if [ ! -d "$repo" ]; then
	1>$2 echo "repo: repository directory not found"
	exit 1
fi

if [ ! -w "$repo"/events.log ]; then
	1>&2 echo "repo: Cannot write to event log"
	exit 1
fi

echo $(date)": repo was archived" >> "$repo"/events.log
if [ "$repo" == "$PWD/repository" ]; then
	pushd "$PWD/"
	zip -r repository.zip "repository"
	popd
else
	zip -r repository.zip "$repo"
fi
