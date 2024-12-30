#!/bin/bash
# #############################################################################
# -----------------------------------------------------------------------------
# #############################################################################
# some checks and basic utilities

# get those pretty print functions and the like
source ./functions.bash

# not entirely sure, but i think we need to check for if bash is at least 4.3
# associative arrays (which we use are available form 4.0 and nameref is 
# available from 4.3
if [ "${BASH_VERSINFO[0]}" -lt 4 ] || [ "${BASH_VERSINFO[0]}" -eq 4 -a "${BASH_VERSINFO[1]}" -lt 3 ]; then
    echo_in red "This script requires Bash version 4.3 or greater. " >&2
    exit 1
fi

# Source os-release for using ID and check if distro is supported
# currently arch, debian and ubuntu, but might add fedora eventually
source /etc/os-release
if [ $ID != "arch" ] && [ $ID != "debian" ] && [ $ID != "ubuntu" ]; then
    error "Unsupported distro. "
fi

# _private directory exists?
if [ ! -d "_private" ]; then
    error "Set up _private first. "
fi
#

# .local may not exist, we will need it (lest it gets symlinked)
if [ ! -d ~/.local ];then
   mkdir ~/.local
fi 

# #############################################################################
# -----------------------------------------------------------------------------
# #############################################################################
# generic software installation 

# Declare packages array
declare -A packages
