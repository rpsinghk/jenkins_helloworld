#!/bin/sh
cd $(dirname $0)

cd ../
echo $pwd
./gradlew clean build

exit
