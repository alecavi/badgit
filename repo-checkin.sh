#!/bin/bash

commentLogs () {
	read -p "Enter a comment for the logs: " comment
	if [[ ! -z $comment ]]; then
		echo "$(date): Comment from \"$USER\": \"$comment\"" >> "$repo"/events.log
	fi
}

file="$1"
repo="$2"

if [ ! -e "$file" ]; then
	1>&2 echo "repo: cannot checkin \"$file\" as it doesn't exist"
	exit 1
fi

if [ -z "$repo" ]; then
	repo="$PWD"/repository
fi

if [ ! -d "$repo" ]; then
	1>&2 echo "repo: repository directory not found"
	exit 1
fi

# Permission checks:
# repository:x, data:wx, checked_out:wx, event.log:w

if [ ! -x "$repo" ]; then
	1>&2 echo "repo: Cannot access the repository folder"
	exit 1
fi

if [ ! -w "$repo"/data ] || [ ! -x "$repo"/data ]; then
	1>&2 echo "repo: Cannot access repository data"
	exit 1
fi

if [ ! -w "$repo"/checked_out ] || [ ! -x "$repo"/checked_out ]; then
	1>&2 echo "repo: Cannot access checkout info"
	exit 1
fi

if [ ! -w "$repo"/events.log ]; then
	1>&2 echo "repo: Cannot write to event log"
	exit 1
fi

if [ ! -e "$repo"/checked_out/"$file" ]; then
	1>&2 echo "repo: Cannot check in \"$file\" as it was never checked out"
	exit 1
fi


rm -r "$repo"/data/"$file"
mv "$PWD"/"$file" "$repo"/data/"$file"
rm "$repo"/checked_out/"$file"
commentLogs
echo $(date)": $USER checked in \"$file\"" >> "$repo"/events.log
