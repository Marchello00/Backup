mkdir archive
for name in $(find ./test -name "*.cpp")
do
	cp $name  archive/${name##*/}
done
tar -cf archive.tar archive/*
rm -rf archive
echo done
