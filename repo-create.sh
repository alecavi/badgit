#!/bin/bash

path=$1;
if [ -z "$path" ]; then
	path="$PWD"
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

repo="$path"/repository

mkdir "$repo"
mkdir "$repo"/data
mkdir "$repo"/checked_out
mkdir "$repo"/backup
touch "$repo"/events.log
