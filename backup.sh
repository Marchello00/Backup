mkdir archive
for name in $(find ./test -name "*.cpp")
do
	cp $name  archive/${name##*/};
done
