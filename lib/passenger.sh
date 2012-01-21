#!/bin/bash

function install_passenger_with_nginx {
  add-apt-repository -y ppa:brightbox/passenger-nginx
  apt-get -y update
  apt-get -y install nginx-full
  cat <<EOF > /etc/nginx/conf.d/passenger.conf
passenger_root /usr/lib/phusion-passenger;
EOF
}
