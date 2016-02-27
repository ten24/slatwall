#!/bin/bash

if git diff-index --quiet HEAD --; then
    # no changes
    echo hello
else

    # changes
    echo world
fi
#git config --global user.email "info@slatwallcommerce.com"
#git config --global user.name "Slatwall Robot 'Big Boy'"
#git commit -a -m "CI build passed, commit of auto build files - $CIRCLE_BUILD_URL [skip ci]"
#git push origin current
