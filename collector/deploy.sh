#!/usr/bin/env bash

if test `adb get-state| tail --lines=1` != device
then
  echo Error: device is not connected to the Android Debug Bridge
fi

source attributes.sh

echo Project: $PROJECT
echo Package: $PACKAGE

./build.sh




echo -n 'Uninstalling existing package version: '
adb uninstall $PACKAGE
echo 'Installing package: '$PACKAGE
#temp adb -d install -r bin/$PROJECT-$1.apk
adb -d install -r bin/$PROJECT-debug.apk

