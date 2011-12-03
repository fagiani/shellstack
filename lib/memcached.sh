#!/bin/bash

###########################################################
# memcached
###########################################################

function install_memcached {
  log "Installing memcached..."
  aptitude install -y memcached
}
