#!/bin/bash

subcommand="$1"
file="$2"
repo="$3"

create () {
	# Permission checks:
	#  data/$file: r, backup: w

	if [ ! -e "$repo"/data/"$file" ]; then
		1>&2 echo "repo: Cannot back up \"$file\" as it deos not exist"
		exit 1
	fi

	if [ ! -e "$repo"/data/"$file" ]; then
		1>&2 echo "repo: Cannot access \"$file\" in \"$repo\" as it does not exist"
		exit 1
	fi

	if [ ! -r "$repo"/data/"$file" ]; then
		1>&2 echo "repo: Cannot access \"$file\" in \"$repo\" as the necessary permissions are not available (Cannot copy file)"
		exit 1
	fi

	if [ ! -w "$repo"/backup/ ]; then
		1>&2 echo "repo: Cannot backup \"$file\" in \"$repo\ as the necessary permissions are not available (Cannot create backup file)"
		exit 1
	fi

	backup_file="$repo"/backup/"$file"."$(date +%Y-%m-%dT%H:%M:%S)"

	cp -R "$repo"/data/"$file" "$backup_file"
	echo "$(date): $USER created backup of \"$file\" called \"$backup_file\"" >> "$repo"/events.log
}

restore () {	
	# Permission checks:
	# data: w, backup: r, backup/$file.<DATETIME>: r

	if [ ! -w "$repo"/data ]; then
		1>&2 echo "repo: Cannot access data in \"$repo\" as the necessary permissions are not available"
		exit 1
	fi

	if [ ! -r "$repo"/backup/ ]; then
		1>&2 echo "repo: Cannot restore \"file\" as the necessary permissions are not available"
		exit 1
	fi

	latest_backup=$(ls -t "$repo"/backup | grep "$file" | head -n 1)

	if [ -z "$latest_backup" ]; then
		1>&2 echo "repo: No backup of \"$file\" exists"
		exit 1
	fi

	if [ ! -r "$repo"/backup/"$latest_backup" ]; then
		1>&2 echo "repo: Cannot access backup of \"$file\" as the necessary permissions are not available"
		exit 1
	fi

	cp -fR "$repo"/backup/"$latest_backup" "$repo"/data/"$file"
	echo "$(date): $USER restored \"$file\" from latest backup" >> "$repo"/events.log
}

delete () {
	# Permission checks:
	# backup: rw

	if [ ! -r "$repo"/backup ] || [ ! -w "$repo"/backup ]; then
		1>&2 echo "repo: Cannot access backup of \"$file\" as the necessary permissions are not available"
		exit 1
	fi

	latest_backup=$(ls -t "$repo"/backup | grep "$file" | head -n 1)

	if [ -z "$latest_backup" ] || [ ! -e "$repo"/backup/"$latest_backup" ]; then
		1>&2 echo "repo: No backup of \"$file\" exists"
		exit 1
	fi

	echo "$(date): $USER deleted latest backup of \"$file\"" >> "$repo"/events.log
	rm -r "$repo"/backup/"$latest_backup"
}


selected_subcmd=unset

case "$subcommand" in
	create) selected_subcmd=create ;;
	restore) selected_subcmd=restore ;;
	delete) selected_subcmd=delete ;;
	*) 1>&2 echo "repo: invalid subcommand to \"backup\""; exit 1 ;;
esac

if [ -z "$repo" ]; then
	repo="$PWD"/repository
fi

if [ ! -d "$repo" ]; then
	1>&2 echo "repo: repository folder \"$repo\" does not exist"
	exit 1
fi

if [ -z "$file" ]; then
	1>&2 echo "repo: file must have a name"
	exit 1
fi

# Universal permission checks (needed by every subcommand)
# repository: x, data: x, backup: x, events.log: w

if [ ! -x "$repo" ]; then
	1>&2 echo "repo: Cannot access \"$repo\" as the necessary permissions are not available"
	exit 1
fi

if [ ! -x "$repo"/data ]; then
	1>&2 echo "repo: Cannot access data in \"$repo\" as the necessary permissions are not available"
	exit 1
fi

if [ ! -x "$repo"/backup ]; then
	1>&2 echo "repo: Cannot backup \"$file\" in \"$repo\ as the necessary permissions are not available (Cannot create backup file)"
	exit 1
fi

if [ ! -w "$repo"/events.log ]; then
	1>&2 echo "repo: Cannot update event log in \"$repo\". The operation will not be performed"
	exit 1
fi

$selected_subcmd
