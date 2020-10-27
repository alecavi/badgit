#!/bin/bash

#getopts -n (program name) -o (short options) --long (long options, comma-separated)
#a : means that option takes a value

while :
do
	case "$1" in
		create)	shift; exec ./repo-create.sh $@ ;;
		add) shift; exec ./repo-add.sh $@ ;;
		checkout) shift; exec ./repo-checkout.sh $@ ;;
		checkin) shift; exec ./repo-checkin.sh $@ ;;
		--)shift; break ;;
		*) echo "invalid subcommand \"$1\""; break ;;
	esac
done

