#!/bin/bash

function install_passenger_with_nginx {
  add-apt-repository -y ppa:brightbox/passenger-nginx
  apt-get -y update
  apt-get -y install libapache2-mod-passenger nginx-full
  cat <<EOF > /etc/nginx/conf.d/passenger.conf
passenger_root /usr/lib/phusion-passenger;
passenger_ruby /usr/local/bin/ruby;
EOF
}

function set_default_nginx_config_with_passenger {
  cat <<EOF > /etc/nginx/sites-available/default
server {
  listen 80;
  server_name $DOMAIN_NAME;
  root /home/app/production/current/public;
  passenger_enabled on;
  access_log /var/log/nginx/app.access.log;
  error_log /var/log/nginx/app.error.log;
  gzip  on;
  gzip_http_version 1.1;
  gzip_comp_level 6;
  gzip_proxied any;
  gzip_min_length  1024;
  gzip_buffers 16 8k;
  gzip_types text/plain text/html text/css application/json application/x-javascript text/xml application/xml application/xml+rss text/javascript;
  gzip_vary on;
  gzip_disable “MSIE [1-6].(?!.*SV1)”;
}
EOF
/etc/init.d/nginx restart
}
