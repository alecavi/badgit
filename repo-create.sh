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

# The above checks are nonexhaustive: mkdir and touch can also fail due to disk space issues and missing permissions
# Moreover, even if they were exhaustive, there would still be the possibility of some error-causing condition being created between check and use
# (such as permissions being removed after the check, but before mkdir/touch actually runs)
# The correct way to handle this would be to simply run mkdir/touch and handle any error that might occur. This is what the following two functions are for.
# The above checks, on the other hand, it to provide better error messages for common cases. In theory, it should be possible to use the status code returned by
# mkdir or man to know if and which error occurred, but in practice I can't find a table of which code means which error anywhere, so all I can say is that an error occurred, which doesn't
# make for a particularly useful error message.

handle_err() {
if [ $? -ne 0 ]; then
	1>&2 echo "repo: Couldn't create repository folder: internal error"
	exit 1
fi
}

handle_err_and_cleanup() {
	if [ $? -ne 0 ]; then
		1>&2 echo "repo: Couldn't create repository folder: internal error"
		rm -r "$path"/repository
		if [ $? -ne 0 ]; then
			1>&2 echo "couldn't cleanup partial repository creation after failure!"
		fi
		exit 1
	fi
}

mkdir "$path"/repository
handle_err
mkdir "$path"/repository/data
handle_err_and_cleanup
mkdir "$path"/repository/checked_out
handle_err_and_cleanup
touch "$path"/repository/events.log
handle_err_and_cleanup

