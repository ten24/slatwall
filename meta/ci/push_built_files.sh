#!/bin/bash

if git diff-index --quiet HEAD --; then
    # no changes
    #echo No Changes To Push
    echo no changes
else

    # changes
    #git commit -a -m "CI build passed, commit of automatically built files - $CIRCLE_BUILD_URL [skip ci]"
    #git push origin current
    echo changes
fi
