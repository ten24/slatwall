#!/bin/bash

if git diff-index --quiet HEAD --; then
    # no changes
    echo "No Changes To Push"

else

    # changes
    echo "Build Changes Found"
    git commit -a -m "CI build passed, auto-built files commit - $CIRCLE_BUILD_URL [ci skip]"
    git push origin

fi
