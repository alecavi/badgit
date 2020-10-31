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
# repository: x, data: wx, checked_out: wx, $file_in_repo: rw, events.log: w

if [ ! -x "$repo" ]; then
	1>&2 echo "repo: Cannot access repository folder as the necessary permissions are not available"
	exit 1
fi

if [ ! -w "$repo"/data ] || [ ! -x "$repo"/data ]; then
	1>&2 echo "repo: Cannot access repository data as the necessary permissions are not available"
	exit 1
fi

if [ ! -w "$checked_out" ] || [ ! -x "$checked_out" ]; then
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

if [ -e "$checked_out"/"$file" ]; then
	1>&2 echo "repo: Cannot edit \"$file\" as it is checked out"
	exit 1
fi

touch "$checked_out"/"$file"
"${EDITOR:-vi}" "$file_in_repo"
echo "$(date): Edited \"$file\"" >> "$repo"/events.log

echo "$(date)" >> timepassed.dbg


log_err() {
	1>&2 echo "\"$file\" has been edited, but it will still be considered checked out"

	if [ -w "$repo"/events.log ]; then
		echo "$(date): Could not check \"$file\" back in after editing it" >> "$repo"/events.log
	else
		1>&2 echo "Events log was not updated as it could not be accessed"
	fi
}

if [ ! -x "$repo" ]; then
	1>&2 echo "repo: Cannot access repository folder as the necessary permissions are no longer  available"
	log_err
	exit 1
fi

if [ ! -w "$checked_out" ] || [ ! -x "$checked_out" ]; then
	1>&2 echo "repo: Cannot access checkout information as the necessary permissions are no longer available"
	log_err
	exit 1
fi

rm "$checked_out"/"$file"
