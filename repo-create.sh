#!/bin/bash

path=$1;
if [ -z "$path" ]; then
	1>&2 echo "repo: Invalid path \"$path\""
	exit 1
fi

if [ ! -d "$path" ]; then
	1>&2 echo "repo: Cannot create the repository  \"$path/repository\" as the directory \"$path\" does not exist"
	exit 1
fi

if [ -d "$path"/repository ]; then
	1>&2 echo "repo: A repository $path/repository already exists"
	exit 1
fi

if [ ! -w "$path" ] || [ ! -x "$path" ]; then
	1>&2 echo "repo: Cannot create repository in \"$path\" as the required permissions are missing"
	exit 1
fi

mkdir "$path"/repository
mkdir "$path"/repository/data
mkdir "$path"/repository/checked_out
touch "$path"/repository/events.log

