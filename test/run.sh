#!/bin/sh
cd $(dirname $0)

cd ../
echo $pwd
./gradlew clean build
ret=$?
if [ $ret -ne 0 ]; then
exit $ret
fi

exit
