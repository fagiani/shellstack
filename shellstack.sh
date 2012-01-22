#!/bin/bash

ROOT_PATH=$(dirname $(readlink -f $0))
LIB_PATH="$ROOT_PATH/lib"

source "$LIB_PATH/hostname.sh"
source "$LIB_PATH/user.sh"
source "$LIB_PATH/utils.sh"
source "$LIB_PATH/security.sh"
source "$LIB_PATH/mysql.sh"
source "$LIB_PATH/postgresql.sh"
source "$LIB_PATH/nginx.sh"
source "$LIB_PATH/git.sh"
source "$LIB_PATH/wordpress.sh"
source "$LIB_PATH/ruby.sh"
source "$LIB_PATH/php.sh"
source "$LIB_PATH/memcached.sh"
source "$LIB_PATH/varnish.sh"
source "$LIB_PATH/nodejs.sh"
source "$LIB_PATH/redis.sh"
source "$LIB_PATH/bluepill.sh"
