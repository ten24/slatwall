#!/bin/bash

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

# Get the las commit message, and more importantly the mergedFrom Variable
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
  newVersion=$major.$minor.000
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

fi

# Find out if any files changed as part of this build
changedFiles=$(git diff --name-only)

# Commit To git with compiled JS, and version file updates
if [ "$changedFiles" = "" ]; then
    # no changes
    echo "No Changes To Push"
elif [ $CIRCLE_BRANCH = "master" ] || [ $CIRCLE_BRANCH = "develop" ]; then
    # changes
    echo "Build/Version Changes Found"
    git commit -a -m "CI build passed, auto-built files commit - $CIRCLE_BUILD_URL [ci skip]"

    # Push the code
    git push origin

    # If this was a taged branch (master)
    if [ $tag = true ]; then
      # Create a zip & hash of this release
      git archive --format=zip HEAD > slatwall-latest.zip
      cp slatwall-latest.zip slatwall-$newVersion.zip

      md5sum slatwall-latest.zip > slatwall-latest.md5.txt
      cp slatwall-latest.md5.txt slatwall-$newVersion.md5.txt

      aws s3 cp slatwall-latest.zip s3://slatwall-releases/slatwall-latest.zip
      aws s3 cp slatwall-$newVersion.zip s3://slatwall-releases/slatwall-$newVersion.zip
      aws s3 cp slatwall-latest.md5.txt s3://slatwall-releases/slatwall-latest.md5.txt
      aws s3 cp slatwall-$newVersion.md5.txt s3://slatwall-releases/slatwall-$newVersion.md5.txt

      # Tag this version
      git tag -a -m "Version $newVersion" $newVersion

      # Push Tag to github
      git push origin $newVersion
    fi

    # If this is the develop branch then we can push up BE Release to S3
    if [ $CIRCLE_BRANCH = "develop" ]; then
      git archive --format=zip HEAD > slatwall-be.zip
      md5sum slatwall-be.zip > slatwall-be.md5.txt
      aws s3 cp slatwall-be.zip s3://slatwall-releases/slatwall-be.zip
      aws s3 cp slatwall-be.md5.txt s3://slatwall-releases/slatwall-be.md5.txt
    fi


fi

# If this is the develop branch then we can push up BE Release to S3
if [ $CIRCLE_BRANCH = "hotfix" ]; then
  git archive --format=zip HEAD > slatwall-hotfix.zip
  md5sum slatwall-hotfix.zip > slatwall-hotfix.md5.txt
  aws s3 cp slatwall-hotfix.zip s3://slatwall-releases/slatwall-hotfix.zip
  aws s3 cp slatwall-hotfix.md5.txt s3://slatwall-releases/slatwall-hotfix.md5.txt
fi

# If this was a master branch change, we need to try and merge into develop, and then push develop
if [ $CIRCLE_BRANCH = "master" ]; then
  # checkout hotfix
  git checkout hotfix
  # merge master into hotfix
  git merge -m "Merge branch 'master' into 'hotfix'" master
  # push hotfix back up
  git push origin

  # checkout develop
  git checkout develop
  # merge master into develop
  git merge -m "Merge branch 'master' into 'develop'"  master
  # Read all the conflicts of the repository
  conflicts=$(git diff --name-only --diff-filter=U)

  # If there are no conflicts it was likely a minor release
  if [ "$conflicts" = "" ] && [ $mergedFrom = "develop" ] && [ $CIRCLE_BRANCH = "master" ]; then
    echo "No Conflict, Minor Release"

    # Write version file with 000 build
    echo $newVersion.000 > version.txt.cfm

    # Commit the version file edit
    git commit -a -m "Added a baseline 000 build [ci skip]"

    # push up the latest develop
    git push origin

  # If the only conflict is the version.txt.cfm file, then we can interperate and fix
  elif [ "$conflicts" = "version.txt.cfm" ]; then
    echo "Only Version Conflict"
    # Update the Version File
    versionArray=() # Create array
    while IFS= read -r line # Read a line
    do
        versionArray+=("$line") # Append line to the array
    done < "version.txt.cfm"
    echo ${versionArray[3]}.$(echo ${versionArray[1]} | cut -d. -f4) > version.txt.cfm

    # Add the version file back
    git add version.txt.cfm

    # commit the updates & merge
    git commit --no-edit

    # push up the latest develop
    git push origin

  # If there were multiple merge conflicts
  else
    echo "Multiple merge conflicts found and must be resolved manually"
  fi

fi
