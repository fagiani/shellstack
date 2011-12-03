#!/bin/bash

###########################################################
# varnish
###########################################################

function install_varnish {
  log "Installing varnish..."
  aptitude install -y varnish
}
