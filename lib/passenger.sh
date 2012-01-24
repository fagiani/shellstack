#!/bin/bash

function install_passenger_with_nginx {
  gem install passenger
  PASSENGER_PATH=`passenger-config --root`/ext/nginx
  cd /usr/local/src
  NGINX_VERSION="nginx-$NGINX_RELEASE"
  wget "http://nginx.org/download/$NGINX_VERSION.tar.gz"
  tar xzf $NGINX_VERSION.tar.gz
  cd $NGINX_VERSION
  ./configure --prefix=/usr/local --sbin-path=/usr/local/sbin --conf-path=/etc/nginx/nginx.conf --with-http_ssl_module --with-http_gzip_static_module --add-module=$PASSENGER_PATH --with-http_sub_module
  cp -r conf /etc/nginx
  make && make install
  wget "http://library.linode.com/assets/660-init-deb.sh" -O /etc/init.d/nginx
  sed -i 's/\/opt\/nginx/\/usr\/local/g' /etc/init.d/nginx
  chmod +x /etc/init.d/nginx
  /usr/sbin/update-rc.d -f nginx defaults
  mkdir -p /var/log/nginx /etc/nginx/conf.d /etc/nginx/sites-available /etc/nginx/sites-enabled
  cat <<EOF > /etc/logrotate.d/nginx
/var/log/nginx/*.log {
        daily
        missingok
        rotate 52
        compress
        defaultslaycompress
        notifempty
        create 0640 www-data adm
        sharedscripts
        postrotate
                [ ! -f /var/run/nginx.pid ] || kill -USR1 \`cat /var/run/nginx.pid\`
        endscriptript
}
EOF
  cat <<EOF > /etc/nginx/conf.d/passenger.conf
passenger_root /usr/local/lib/ruby/gems/1.9.1/gems/passenger-3.0.11;
passenger_ruby /usr/local/bin/ruby;
EOF
  cat <<EOF > /etc/nginx/nginx.conf
user www-data;
worker_processes 6;
pid /var/run/nginx.pid;

events {
        worker_connections 1024;
}

http {
  tcp_nodelay on;
  keepalive_timeout 65;
  types_hash_max_size 2048;

  include /etc/nginx/mime.types;
  default_type application/octet-stream;

  access_log /var/log/nginx/access.log;
  error_log /var/log/nginx/error.log;

  include /etc/nginx/conf.d/*.conf;
  include /etc/nginx/sites-enabled/*;
}
EOF
  cat <<EOF > /etc/nginx/sites-available/default
server {
  listen 80;
  server_name $DOMAIN_NAME;
  root /home/$USER_NAME/production/current/public;
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
  ln -s /etc/nginx/sites-available/default /etc/nginx/sites-enabled/default
  /etc/init.d/nginx start
}
