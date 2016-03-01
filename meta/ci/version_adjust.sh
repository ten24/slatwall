version=$(<version.txt.cfm)
major=$(echo $version | cut -d. -f1)
minor=$(echo $version | cut -d. -f2)
micro=$(echo $version | cut -d. -f3)
build=$(echo $version | cut -d. -f4)
echo $version
echo $major
echo $minor
echo $micro
echo $build
