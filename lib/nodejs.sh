#!/bin/bash

function install_nodejs {
  apt-get -y install python-software-properties
  add-apt-repository ppa:chris-lea/node.js
  apt-get -y update
  apt-get -y install nodejs nodejs-dev
}
