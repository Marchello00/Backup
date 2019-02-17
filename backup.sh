#!/bin/bash

function help {
	echo "Usage: ./backup.sh [-c <catalog name> -a <archive name>] <extention list>"
	exit 1
}

CATALOG_NAME="archive"
ARCHIVE_NAME=$CATALOG_NAME

while [[ $# -gt 0 ]]
do
	key=$1
	case $key in
	-c)
		CATALOG_NAME="$2"
		shift
		shift
		;;
	-a)
		ARCHIVE_NAME="$2"
		shift
		shift
		;;
	-*)
		echo "Wrong param"
		help
		;;
	*)
		break
		;;
	esac
done

if [ $# -eq 0 ]
then 
	echo "Empty extention list"
	help
fi

mkdir $CATALOG_NAME

touch $CATALOG_NAME/names_map.txt

while [[ $# -gt 0 ]]
do
	last=""
	num=0
	for str in $(find ./test -name "*.$1" | awk -F/ -v ext=".$1" '{ print substr($NF, 1, length($NF) - length(ext)) "/" $0 }' | sort -r -k1) 
	do
		name=${str#*/}
		sname=${str:0:${#str}-${#name} - 1}
		if [[ "$last" = "$sname" ]]
		then
			num=$(( num + 1 ))
			sname="${sname}(${num})"
		elif [[ -z $(find ./${CATALOG_NAME} -name "${sname}.$1") ]]
		then
			last=$sname
			num=0
		else 
			last=$sname
			num=1
			sname="${sname}(${num})"
		fi
		cp $name $CATALOG_NAME/${sname}.$1
		echo "$name -> $sname.$1" >> $CATALOG_NAME/names_map.txt
	done
	shift
done

tar -cf ${ARCHIVE_NAME}.tar $CATALOG_NAME/*
echo done
