#!/bin/bash

#TESTING ONLY!!!!
CIRCLE_BRANCH='master'

# Functions for increasing the version number
function format3Digit( ) {
  if [ ${#micro} = 1 ]
    then
      micro=00$micro
  elif [ ${#micro} = 2 ]
    then
      micro=0$micro
  fi
  if [ ${#build} = 1 ]
    then
      build=00$build
  elif [ ${#build} = 2 ]
    then
      build=0$build
  fi

  return 0
}

# Get the current version number
version=$(<version.txt.cfm)
major=$(echo $version | cut -d. -f1)
minor=$(echo $version | cut -d. -f2)
micro=$(echo $version | cut -d. -f3 | sed 's/^0*//')
build=$(echo $version | cut -d. -f4 | sed 's/^0*//')
tag=false

# Get the las commit message, and more importantly the merfedFrom Variable
lastCommit=$(git log --merges --pretty=%s -n1 2>&1)
if [[ $lastCommit == *ten24/master ]]; then
  mergedFrom="master"
elif [[ $lastCommit == *ten24/hotfix ]]; then
  mergedFrom="hotfix"
elif [[ $lastCommit == *ten24/develop ]]; then
  mergedFrom="develop"
else
  mergedFrom="any-feature"
fi

# MASTER | MINOR If this is develop -> master, do a minor version update, tag & push
if [ $mergedFrom = "develop" ] && [ $CIRCLE_BRANCH = "master" ]; then
  echo 'develop -> master'
  # Increment Minor
  minor=$((minor + 1))
  newVersion=$major.$minor.$micro
  # Write File
  echo $newVersion > version.txt.cfm
  echo "Updated $version -> $newVersion"
  tag=true
# MASTER | MICRO If this is hotfix -> master, do a micro version update
elif [ $mergedFrom = "hotfix" ] && [ $CIRCLE_BRANCH = "master" ]; then
  echo 'hotfix -> master'
  # Increment Micro
  micro=$((micro + 1))
  format3Digit
  newVersion=$major.$minor.$micro
  # Write File
  echo $newVersion > version.txt.cfm
  echo "Updated $version -> $newVersion"
  tag=true
# DEVELOP | BUILD If this is !master -> develop, do a build version update
elif [ $mergedFrom != "master" ] && [ $CIRCLE_BRANCH = "develop" ]; then
  echo 'feature -> develop'
  # Increment Build
  build=$((build + 1))
  format3Digit
  newVersion=$major.$minor.$micro.$build
  # Write File
  echo $newVersion > version.txt.cfm
  echo "Updated $version -> $newVersion"
  tag=true
fi

# Commit To git with compiled JS, and version file updates
if git diff-index --quiet HEAD --; then
    # no changes
    echo "No Changes To Push"
else
    # changes
    echo "Build/Version Changes Found"
    git commit -a -m "CI build passed, auto-built files commit - $CIRCLE_BUILD_URL [ci skip]"
    # Push
    git push origin

    if [ tag == true ]; then
      git tag -a $(newVersion) -m "Version $newVersion"
      git push origin $(newVersion)
    fi
fi

# If this was a master branch change, we need to try and merge into develop, and then push develop
if [ $CIRCLE_BRANCH = "master" ]; then
  # checkout develop
  git checkout develop
  # merge master into develop
  git merge master

fi
