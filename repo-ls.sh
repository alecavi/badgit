#!/bin/bash

subfolder="$1"
repo="$2"

if [ -z "$repo" ]; then
	repo="$PWD"/repository
fi

if [ ! -x "$repo" ]; then
	1>&2 echo "repo: Cannot access repository folder as the necessary permissions are not available"
	exit 1
fi

IFS="/" read -a	subfolder_array <<< "$subfolder"
end=$((${#subfolder_array[@]} - 1))
temppath="$repo"/data/"${subfolder_array[0]}"
for ((i=1; i<end; i++)); do
	temppath+="/${subfolder_array[i]}"

	if [ ! -d "$temppath" ]; then
		1>&2 echo "repo: Cannot list specified subdirectory as the path to it contains a non-directory \"$temppath\""
		exit 1
	fi

	if [ ! -x "$temppath" ]; then
		1>&2 echo "repo: Cannot list specified subdirectory as permission to access the contents of \"$temppath\" on the path to it is not available"
		exit 1
	fi
done

# Last file in the path needs special handling: this one is allowed to not be executable
file="$repo"/data/"$subfolder"

if [ ! -d "$file" ]; then
	1>&2 echo "repo: Cannot list specified subdirectory as the path to it contains a non-directory \"$file\""
	exit 1
fi

if [ ! -r "$file" ]; then
	1>&2 echo "repo: Cannot list specified subdirectory as permission to access the contents of \"$file\" on the path to it is not available"
	exit 1
fi

if [ -x "$file" ]; then
	ls -l "$file"
else
	ls "$file"
fi
