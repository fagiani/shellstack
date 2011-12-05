#!/bin/bash

function install_php5_fpm {
        log "Installing php5 fpm..."
	mkdir -p /var/www
	aptitude -y install php5-fpm php5-curl php5-mysql php5-memcache php-apc php5-pgsql php5-common php5-suhosin php5-cli php5-imagick php5-gd

	php_fpm_conf_file=`grep -R "^listen.*=.*127" /etc/php5/fpm/* | sed 's/:.*$//g' | uniq | head -n 1`
	#sockets > ports. Using the 127.0.0.1:9000 stuff needlessly introduces TCP/IP overhead.
	sed -i 's/listen = 127.0.0.1:9000/listen = \/var\/run\/php5-fpm.sock/'  $php_fpm_conf_file

	#sockets limited by net.core.somaxconn and listen.backlog to 128 by default, so increase this
	#see http://www.saltwaterc.eu/nginx-php-fpm-for-high-loaded-websites.html
	sed -i 's/^.*listen.backlog.*$/listen.backlog = 1024/g'                $php_fpm_conf_file
	echo "net.core.somaxconn=1024" >/etc/sysctl.d/10-unix-sockets.conf
	sysctl net.core.somaxconn=1024

	#set max requests to deal with any possible memory leaks
	sed -i 's/^.*pm.max_requests.*$/pm.max_requests = 1024/g'              $php_fpm_conf_file
	/etc/init.d/php5-fpm restart
}

function setup_php5_fpm_with_nginx {
  cat > /etc/nginx/conf.d/php5-fpm.conf << EOF
upstream php5-fpm-sock {
server unix:/var/run/php5-fpm.sock;
}
EOF
}
