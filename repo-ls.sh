#!/bin/bash

repo="$1"

if [ -z "$repo" ]; then
	repo="$PWD"/repository
fi

if [ ! -x "$repo" ]; then
	1>&2 echo "repo: Cannot access repository folder as the necessary permissions are not available"
	exit 1
fi

if [ -r "$repo"/data ]; then
	if [ -x "$repo/data" ]; then
		ls -l "$repo"/data
	else 
		1>&2 echo "repo: Insufficient permissions to display detailed information. Simple information will be displayed instead"
		ls "$repo"/data
	fi
else
	1>&2 echo "repo: Cannot access repository data as the necessary permissions are not available"
	exit 1
fi
