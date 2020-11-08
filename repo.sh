#!/bin/bash

while :
do
	case "$1" in
		create)	shift; exec ./repo-create.sh $@ ;;
		add) shift; exec ./repo-add.sh $@ ;;
		checkout) shift; exec ./repo-checkout.sh $@ ;;
		checkin) shift; exec ./repo-checkin.sh $@ ;;
		edit) shift; exec ./repo-edit.sh $@ ;;
		ls) shift; exec ./repo-ls.sh $@ ;;
		backup) shift; exec ./repo-backup.sh $@ ;;
		zip) shift; exec ./repo-zip.sh $@;;
		unzip) shift; exec ./repo-unzip.sh $@;;
		--)shift; break ;;
		*) echo "invalid subcommand \"$1\""; break ;;
	esac
done

