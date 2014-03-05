
PACKAGE=$(xmllint --xpath 'string(/manifest/@package)' AndroidManifest.xml) 
if test -z $PACKAGE 
then
  echo Error: cannot parse package manifest file AndroidManifest.xml >&2
  exit 1
fi

PROJECT=$(xmllint --xpath 'string(/project/@name)' build.xml) 
if test -z $PROJECT
then
  echo Error: cannot parse ant build file build.xml >&2
  exit 1
fi
