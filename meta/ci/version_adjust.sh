#!/bin/bash

version=$(<version.txt.cfm)
major=$(echo $version | cut -d. -f1)
minor=$(echo $version | cut -d. -f2)
micro=$(echo $version | cut -d. -f3 | sed 's/^0*//')
build=$(echo $version | cut -d. -f4 | sed 's/^0*//')

CIRCLE_BRANCH='master'

if [ $CIRCLE_BRANCH = 'master' ]
  then

    echo "Updating Master Micro Version"

    micro=$((micro + 1))

    if [ ${#micro} = 0 ]
      then
        micro=000
    elif [ ${#micro} = 1 ]
      then
        micro=00$micro
    elif [ ${#micro} = 2 ]
      then
        micro=0$micro
    fi

    newVersion=$major.$minor.$micro

elif [ $CIRCLE_BRANCH = 'develop' ]
  then
    echo "Updating Develop Build Version"

    build=$((build + 1))

    if [ ${#micro} = 0 ]
      then
        micro=000
    elif [ ${#micro} = 1 ]
      then
        micro=00$micro
    elif [ ${#micro} = 2 ]
      then
        micro=0$micro
    fi

    if [ ${#build} = 0 ]
      then
        build=000
    elif [ ${#build} = 1 ]
      then
        build=00$build
    elif [ ${#build} = 2 ]
      then
        build=0$build
    fi

    newVersion=$major.$minor.$micro.$build

fi

echo "Updating $version -> $newVersion"
echo $newVersion > version.txt.cfm
