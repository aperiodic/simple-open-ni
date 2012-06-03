#!/bin/bash

tmp=`mktemp /tmp/soni-jar-XXXXXXX`
rm $tmp
mkdir $tmp
platforms=(linux macosx windows)

if [[ -z $1 ]]; then
  echo 'usage: jar.sh $version' 1>&2
  exit 1
fi

read major minor <<<$(IFS='.'; echo $1)
echo $major
echo $minor
bugfix=0

soni_url="https://simple-openni.googlecode.com/files/SimpleOpenNI-$major.$minor.zip"
echo "Downloading SimpleOpenNI-$minor.zip..."
curl $soni_url > $tmp/soni-$minor.zip
echo "...DONE"
printf "Extracting..."
unzip -d $tmp $tmp/soni-$minor.zip > /dev/null
echo "DONE"
library=$tmp/SimpleOpenNI/library

ajar=$tmp/ajar-$major.$minor.$bugfix
# create the native library folders for the jar
for platform in ${platforms[@]}; do
  for architecture in x86 x86_64; do
    mkdir -p $ajar/native/$platform/$architecture
  done
done

printf "Unjarring (ajarring?)..."
in_jar=$library/SimpleOpenNI.jar
out_jar=simple-open-ni-$major.$minor.$bugfix.jar
unzip -d $ajar $in_jar > /dev/null
echo "DONE"

printf "Inserting native deps..."
# this is probably the nuttiest bash i've ever written
# if you know a better way, please tell me
libraries=('libSimpleOpenNI32.so;libSimpleOpenNI64.so'
           'libSimpleOpenNI.jnilib;libSimpleOpenNI.jnilib'
           'SimpleOpenNI32.dll;SimpleOpenNI64.dll')
for ((i = 0; i < 3; i++)); do
  platform=${platforms[$i]}
  libs=${libraries[$i]}
  read libx86 libx86_64 <<<$(IFS=';'; echo $libs)
  cp $library/$libx86 $ajar/native/$platform/x86/
  cp $library/$libx86_64 $ajar/native/$platform/x86_64/
done
echo "DONE"

printf "Jarring..."
pushd $ajar > /dev/null
zip -r $out_jar . > /dev/null
popd > /dev/null
cp $ajar/$out_jar .
echo "DONE"

rm -r $tmp
