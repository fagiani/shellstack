#!/bin/bash

###########################################################
# varnish
###########################################################

function install_varnish {
  log "Installing varnish..."
  aptitude install -y varnish
  cat "apc.shm_size=100" >> /etc/php5/fpm/conf.d/apc.ini
  /etc/init.d/varnish restart
  /etc/init.d/nginx restart
}

function setup_varnish_wordpress_vcl {
  log "Setting up varnish wordpress.vcl..."
  echo > /etc/varnish/wordpress.vcl << EOF
backend default {
    .host = "127.0.0.1";
    .port = "8080";
}
acl purge {
    "localhost";
}
sub vcl_hit {
    if (req.request == "PURGE") {
        set obj.ttl = 0s;
        error 200 "Purged.";
    }
}
sub vcl_miss {
    if (req.request == "PURGE") {
        error 404 "Not in cache.";
    }
    if (!(req.url ~ "wp-(login|admin)")) {
      unset req.http.cookie;
    }
    if (req.url ~ "^/[^?]+.(jpeg|jpg|png|gif|ico|js|css|txt|gz|zip|lzma|bz2|tgz|tbz|html|htm)(\?.|)$") {
        unset req.http.cookie;
        set req.url = regsub(req.url, "\?.$", "");
    }
    if (req.url ~ "^/$") {
        unset req.http.cookie;
    }
}
sub vcl_fetch {
    if (req.url ~ "^/$") {
        unset beresp.http.set-cookie;
    }
    if (!(req.url ~ "wp-(login|admin)")) {
        unset beresp.http.set-cookie;
    }
}
EOF
  IP_ADDRESS=$(system_ip)
  sed -i "s/:6081/$IP_ADDRESS:80/" /etc/default/varnish
  sed -i "s/default.vcl/wordpress.vcl/" /etc/default/varnish
  /etc/init.d/varnish restart
  /etc/init.d/php5-fpm stop
  /etc/init.d/php5-fpm start
}
