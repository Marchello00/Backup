function help() {
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

while [[ $# -gt 0 ]]
do
	for name in $(find ./test -name "*.$1")
	do
		cp $name $CATALOG_NAME/${name##*/}
	done
	shift
done

tar -cf ${ARCHIVE_NAME}.tar $CATALOG_NAME/*
echo done
