#!/bin/bash

commentLogs () {
	read -p "Enter a comment for the logs: " comment
	if [[ ! -z $comment ]]; then
		echo "$(date): Comment from \"$USER\": \"$comment\"" >> "$repo"/events.log
	fi
}

read -p 'What is the name of the repository you wish to unzip? ' repo

read -p 'Where would you like the repository to be extracted to? ' path

if [ !-d $repo ]; then
	echo "repo: zipped repository was not found"
	exit 1
fi

unzip -d $path $repo
commentLogs
echo $(date)": repo was un-archived" >> $repo/events.log
