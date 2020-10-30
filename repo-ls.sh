#!/bin/bash

repo="$PWD"/repository

if [ ! -x "$repo" ]; then
	1>&2 echo "repo: Cannot access repository folder as the necessary permissions are not available"
	exit 1
fi

if [ ! -r "$repo"/data ]; then
	1>&2 echo "repo: Cannot access repository data as the necessary permissions are not available"
	exit 1
fi

ls "$repo"/data
