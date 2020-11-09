#!/bin/bash

commentLogs () {
	read -p "Enter a comment for the logs: " comment
	if [[ ! -z $comment ]]; then
		echo "$(date): Comment from \"$USER\": \"$comment\"" >> "$repo"/events.log
	fi
}

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

commentLogs
echo $(date)": repo was archived" >> "$repo"/events.log
if [ "$repo" == "$PWD/repository" ]; then
	pushd "$PWD/"
	zip -r repository.zip "repository"
	popd
else
	zip -r repository.zip "$repo"
fi
