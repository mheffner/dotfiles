#!/bin/bash

# Exit if we don't have git
which git &> /dev/null
if [ $? -ne 0 ]; then
    exit 0
fi

# Run this to set git aliases
function galias {
    ALIAS="$1"
    shift
    CMD="$@"

    git config --global "alias.$ALIAS" "$CMD"
}

# Clear aliases
git config --global --remove-section alias &> /dev/null

galias unpushed log --abbrev-commit --pretty=oneline origin/master...master
galias st status
galias ci commit
galias co checkout
galias br branch
galias df diff --no-prefix
galias dfp diff
galias lp log -p
