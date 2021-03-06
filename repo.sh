#!/bin/bash

path=$(dirname $(realpath "$0"))

case "$1" in
	create)	  shift; exec "$path"/repo-create.sh $@ ;;
	add) 	  shift; exec "$path"/repo-add.sh $@ ;;
	checkout) shift; exec "$path"/repo-checkout.sh $@ ;;
	checkin)  shift; exec "$path"/repo-checkin.sh $@ ;;
	edit)	  shift; exec "$path"/repo-edit.sh $@ ;;
	ls) 	  shift; exec "$path"/repo-ls.sh $@ ;;
	backup)   shift; exec "$path"/repo-backup.sh $@ ;;
	zip) 	  shift; exec "$path"/repo-zip.sh $@ ;;
	unzip)    shift; exec "$path"/repo-unzip.sh $@ ;;
	--)	  shift ;;
	*) 	  echo "invalid subcommand \"$1\""; exit 1 ;;
esac
