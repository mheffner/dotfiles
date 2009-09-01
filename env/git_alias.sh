#!/bin/bash

# Run this to set git aliases
function alias {
    ALIAS="$1"
    shift
    CMD="$@"

    git config --global "alias.$ALIAS" "$CMD"
}


alias up log origin/master...master
