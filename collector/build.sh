#!/usr/bin/env bash

NDK_PATH=/opt/android.com/android-ndk-r8b

#Temporary workaround
if [[ -d $NDK_PATH ]] 
then
  $NDK_PATH/ndk-build clean || exit 1
  if test "$1" = debug
  then
    $NDK_PATH/ndk-build NDK_DEBUG=1 || exit 1
  else
    $NDK_PATH/ndk-build || exit 1
  fi
fi

ant debug || exit 1
#temp ant $1 || exit 1
