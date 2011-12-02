#!/bin/bash

##Uncomment below to indicate where
##library is installed, so we can source sub-modules properly
#SHELLSTACK_INSTALL_DIR=/usr/local/lib/shellstack

if [ -z "$SHELLSTACK_INSTALL_DIR" ] ; then
	SHELLSTACK_INSTALL_DIR="./lib"
fi

export SHELLSTACK_INSTALL_DIR

source "$SHELLSTACK_INSTALL_DIR/constants.sh"
source "$SHELLSTACK_INSTALL_DIR/hostname.sh"
source "$SHELLSTACK_INSTALL_DIR/user.sh"
source "$SHELLSTACK_INSTALL_DIR/utils.sh"
source "$SHELLSTACK_INSTALL_DIR/security.sh"
source "$SHELLSTACK_INSTALL_DIR/mysql.sh"
source "$SHELLSTACK_INSTALL_DIR/postgresql.sh"
source "$SHELLSTACK_INSTALL_DIR/nginx.sh"
source "$SHELLSTACK_INSTALL_DIR/git.sh"
source "$SHELLSTACK_INSTALL_DIR/wordpress.sh"
source "$SHELLSTACK_INSTALL_DIR/ruby.sh"
source "$SHELLSTACK_INSTALL_DIR/php.sh"
