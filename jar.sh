#!/bin/bash

platforms=(linux macosx windows)

major=0
minor=$1
bugfix=0

if [[ -z $minor ]]; then
  echo 'usage: jar.sh $minor-version' 1>&2
  exit 1
fi

ajar=ajar-$major.$minor.$bugfix
# create the native library folders for the jar
for platform in ${platforms[@]}; do
  for architecture in x86 x86_64; do
    mkdir -p $ajar/native/$platform/$architecture
  done
done

in_jar=SimpleOpenNI.jar
out_jar=simple-open-ni-$major.$minor.$bugfix.jar
cp $in_jar $ajar/
cd $ajar
unzip $in_jar
rm $in_jar
cd ..

if [[ ! -d library ]]; then
  echo "can't find SimpleOpenNI library folder" 1>&2
  exit 2
fi

# this is probably the nuttiest bash i've ever written
# if you know a better way, please tell me
libraries=('libSimpleOpenNI32.so;libSimpleOpenNI64.so'
           'libSimpleOpenNI.jnilib;libSimpleOpenNI.jnilib'
           'SimpleOpenNI32.dll;SimpleOpenNI64.dll')
for ((i = 0; i < 3; i++)); do
  platform=${platforms[$i]}
  libs=${libraries[$i]}
  read libx86 libx86_64 <<<$(IFS=';'; echo $libs)
  cp library/$libx86 $ajar/native/$platform/x86/
  cp library/$libx86_64 $ajar/native/$platform/x86_64/
done

cd $ajar
zip -r $out_jar .
cd ..

mv $ajar/$out_jar .
rm -r $ajar
