#!/usr/bin/env bash

if test "$1" != debug -a "$1" != release
then
  echo "Usage $0 debug|release"
  exit 1
fi

source attributes.sh

./deploy.sh

if test "$1" = debug
then
  DEBUG_FLAGS='-D'
else
  DEBUG_FLAGS=''
fi

#The script launches first activity declared in the manifest file
ACTIVITY=$(xmllint --xpath "string(/manifest/application/activity[1]/@*[namespace-uri()='http://schemas.android.com/apk/res/android' and local-name()='name'])" AndroidManifest.xml) 
if [[ -n $ACTIVITY ]]
then
  echo 'Starting package activity: '$ACTIVITY
  adb -d shell "am start $DEBUG_FLAGS -W -n $PACKAGE/$PACKAGE.$ACTIVITY"
else
  INTENT=$(xmllint --xpath "string(/manifest/application/service/intent-filter/action/@*[namespace-uri()='http://schemas.android.com/apk/res/android' and local-name()='name'])" AndroidManifest.xml)
  if [[ -n $INTENT ]]
  then
    echo 'Starting package intent: '$INTENT
    adb -d shell "am startservice $DEBUG_FLAGS -W $PACKAGE/$INTENT"
  else
    echo Error: cannot parse package manifest file AndroidManifest.xml >&2
    exit 1
  fi
fi

if test "$1" = debug
then
  while true
  do
    for pid in `adb -d jdwp`
    do
      name=$(adb shell ps $pid | awk -v RS=\\r\\n 'NR==2 {printf $NF}')
      echo Found a process hosting a JDWP transport: PID=$pid, NAME = $name
      if test $name = $PACKAGE
      then
        adb forward tcp:29882 jdwp:$pid
        exec jdb -sourcepath ../funf-open-sensing-framework/src/ -connect com.sun.jdi.SocketAttach:hostname=localhost,port=29882
      fi
    done
    echo Error: debug launch failure, will try again
    sleep 1
  done
fi
