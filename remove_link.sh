#!/bin/bash

while [ ! -z $1 ]
do
	if [ -L "$1" ]
	then
		cd `dirname $1`
		mv $1 $1.old
		mkdir $1
		cp -r $1.old/* $1/
		rm $1.old
	else
		echo "$1 n'est pas un lien symbolique"
	fi
	shift
done
