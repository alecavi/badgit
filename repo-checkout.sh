#!/bin/bash

commentLogs () {
	read -p "Enter name of user that made the change: " user
	read -p "Enter a comment for the logs: " comment
	if [[ ! -z $comment ]]; then
		echo "Comment from \"user\": \"$comment\"" >> "$repo"/events.log
	fi
}

file="$1"
repo="$2"

if [ -z "$repo" ]; then
	repo="$PWD"/repository
fi

checked_out="$repo"/checked_out

if [ ! -d "$repo" ]; then
	1>&2 echo "repo: repository folder not found"
	exit 1
fi

# Permission checks:
# repository:x, checked_out:wx, data:x, PWD:wx,  data/$file:r. event.log:w

if [ ! -x "$repo" ]; then
	1>&2 echo "repo: Cannot access repository contents"
	exit 1
fi

if [ ! -w "$checked_out" ] || [ ! -x "$checked_out" ]; then
	1>&2 echo "repo: Cannot check out \"$file\" as permission to access information about which files are checked out is missing"
	exit 1
fi

if [ ! -x "$repo"/data ]; then
	1>&2 echo "repo: Cannot check out \"$file\" as permission to access repository data is missing"
	exit 1
fi

if [ ! -e "$repo"/data/"$file" ]; then
	1>&2 echo "repo: Cannot check out \"$file\" as it doesn't exist"
	exit 1
fi

if [ ! -r "$repo"/data/"$file" ]; then
	1>&2 echo "repo: Cannot check out \"$file\" as permission to copy the file is missing"
	exit 1
fi

if [ ! -w "$PWD" ] || [ ! -x "$PWD" ]; then
	1>&2 echo "repo: Cannot check out \"$file\" as the necessary permissions are not available in the output folder"
	exit 1
fi

if [ ! -w "$repo"/events.log ]; then
	1>&2 echo "repo: Cannot check out \"$file\" as permission to write to the event log is missing"
	exit 1
fi

# Sanity checks:

if [ -e "$PWD"/"$file" ]; then
	1>&2 echo "repo: cannot checkout \"$file\" as a file with the same name already exists"
	exit 1
fi

if [ -e "$checked_out"/"$file" ]; then
	1>&2 echo "repo: Cannot check out \"$file\" as it is already checked out"
	exit 1
fi

touch "$checked_out"/"$file"
cp -a "$repo"/data/"$file" "$PWD"/"$file"
commentLogs
echo "$(date): $USER checked out \"$file\"" >> "$repo"/events.log
