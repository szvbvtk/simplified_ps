#!/bin/bash

if [ -z "$1" ]
then
	echo "Brak argumentu"
	exit 1
elif [[ "$1" != "-p" && "$1" != "-u" ]]
then
	echo "Nieprawidłowy argument"
	exit 1
fi

cd /proc

proc_content=`ls | sort -n`

info=""

for process_dir in $proc_content
do
re='^[0-9]+$'
if ! [[ $process_dir =~ $re ]]
then
continue
fi

if [ -d "$process_dir" ]
then
if [ "$1" = "-p" ]
then
	echo -n "$process_dir	"
	cd ./$process_dir
	echo -n `cat status | grep "PPid:" | cut -d"	" -f2`
	echo -n "	"
	_uid=`cat status | grep "Uid:" | cut -d"	" -f2`
	echo -n " $_uid ("
	echo -n `id -un $_uid`
	echo -n ")	"
	echo `cat status | grep "Name:" | cut -d"	" -f2`
	cd ..
else
	#echo $process_dir
	cd ./$process_dir
	_uid=`cat status | grep "Uid:" | cut -d"	" -f2`
	
	if [[ $UID = $_uid ]]
	then
	#echo "$UID $_uid"
	echo -n `cat status | grep "^Pid:" | cut -d"	" -f2`
	echo -n "	"
	echo -n `cat status | grep "Name:" | cut -d"	" -f2`
	echo -n "  "
	if [ -d cwd ]
	then

		#echo `ls -l cwd | cut -d">" -f2`
	# lub
		cd cwd
		echo `pwd -P`
		cd ..
	fi
	fi

	cd .. 
fi
fi

done

