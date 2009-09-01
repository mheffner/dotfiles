#!/bin/bash

# Exit if we don't have git
which git &> /dev/null
if [ $? -ne 0 ]; then
    exit 0
fi

# General GIT configuration

git config --global branch.autosetupmerge true
