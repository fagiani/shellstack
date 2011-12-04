#!/bin/bash

function install_wordpress_site {
        #$1 - MySQL root password
        #$2 - MySQL WordPress user
        #$3 - MySQL WordPress password
        #$4 - Wordpress Database name
	#$5 - Site URL
        #$6 - WP admin name
        #$7 - WP admin password
        #$8 - WP admin email
        #$9 - Public Blog? 0 - no | 1 - yes
        log "Intalling WordPress..."
        download_and_unzip_wordpress
        create_wordpress_database_user_and_tables $2 $3 $4 $1
        setup_wordpress_configuration $2 $3 $4
        trigger_wordpress_installation $5 $6 $7 $8 $9
}

function download_and_unzip_wordpress {
        log "Downloading and extracting WordPress..."
	wget "http://wordpress.org/latest.tar.gz" -O /var/www/wp-latest.tar.gz
	tar xfz /var/www/wp-latest.tar.gz -C /var/www
}

function create_wordpress_database_user_and_tables {
        #$1 - MySQL user
        #$2 - MySQL password
        #$3 - Wordpress Database name
        #$4 - MySQL root pasword
        log "Creating WordPress database and user..."
	create_mysql_database "$4" "$3"
	create_mysql_user "$4" "$1" "$2"
	grant_mysql_user "$4" "$1" "$3"
}

function setup_wordpress_configuration {
        #$1 - MySQL user
        #$2 - MySQL password
        #$3 - Wordpress Database name
        log "Setting up WordPress initial configuration..."
	mv /var/www/wordpress/wp-config-sample.php /var/www/wordpress/wp-config.php
        SALT=$(curl -L https://api.wordpress.org/secret-key/1.1/salt/)
        WP_CONFIG=/var/www/wordpress/wp-config.php
	chmod 640 $WP_CONFIG
        printf '%s\n' "g/put your unique phrase here/d" a "$SALT" . w | ed -s $WP_CONFIG
	sed -i "s/database_name_here/$3/" $WP_CONFIG
	sed -i "s/username_here/$1/" $WP_CONFIG
	sed -i "s/password_here/$2/" $WP_CONFIG
        sed -i "s/<?php/<?php \ndefine('WP_CACHE', true);/" $WP_CONFIG

	chown -R www-data.www-data /var/www/wordpress
	/etc/init.d/nginx restart
	/etc/init.d/php5-fpm restart
}

function trigger_wordpress_installation {
	#$1 - Site URL
        #$2 - WP admin name
        #$3 - WP admin password
        #$4 - WP admin email
        #$5 - Public Blog? 0 - no | 1 - yes
        log "Triggering WordPress instalation procedure..."
	php << EOF
<?php
  define( 'WP_SITEURL', 'http://$1');
  define( 'WP_INSTALLING', true );
  require_once( '/var/www/wordpress/wp-load.php' );
  require_once( '/var/www/wordpress/wp-admin/includes/upgrade.php' );
  require_once( '/var/www/wordpress/wp-includes/wp-db.php' );
  wp_install('My WP Blog', "$2", "$4", $5, '', "$3");
?>
EOF
}

function download_and_unzip_wp_cache_plugin {
        WP_CACHE_PATH=/var/www/wordpress/wp-content/plugins
	wget http://downloads.wordpress.org/plugin/wp-super-cache.0.9.9.9.zip -O $WP_CACHE_PATH/wp-super-cache.0.9.9.9.zip
	unzip $WP_CACHE_PATH/wp-super-cache.0.9.9.9.zip -d $WP_CACHE_PATH
        chown -R www-data.www-data $WP_CACHE_PATH
        mv $WP_CACHE_PATH/wp-super-cache/wp-cache-config-sample.php $WP_CACHE_PATH/wp-super-cache/wp-cache-config.php
}

function setup_initial_wp_cache_configuration {
	cat << 'EOF' >>../wp-cache-config.php
$wp_cache_mobile_groups = '';
$wp_cache_mobile_prefixes = 'w3c , w3c-, acs-, alav, alca, amoi, audi, avan, benq, bird, blac, blaz, brew, cell, cldc, cmd-, dang, doco, eric, hipt, htc_, inno, ipaq, ipod, jigs, kddi, keji, leno, lg-c, lg-d, lg-g, lge-, lg/u, maui, maxo, midp, mits, mmef, mobi, mot-, moto, mwbp, nec-, newt, noki, palm, pana, pant, phil, play, port, prox, qwap, sage, sams, sany, sch-, sec-, send, seri, sgh-, shar, sie-, siem, smal, smar, sony, sph-, symb, t-mo, teli, tim-, tosh, tsm-, upg1, upsi, vk-v, voda, wap-, wapa, wapi, wapp, wapr, webc, winw, winw, xda , xda-';
$wp_cache_refresh_single_only = '0';
$wp_cache_mod_rewrite = 0;
$wp_cache_front_page_checks = 0;
$wp_supercache_304 = 0;
$wp_cache_slash_check = 0;
$cache_enabled = true;
$super_cache_enabled = true;
$sem_id = 1816471371;
$wp_cache_mobile_enabled = 1;
EOF
}

function activate_wp_cache_plugin {
  #$1 - MySQL user
  #$2 - MySQL password
  #$3 - Wordpress Database name
  echo "UPDATE wp_options SET option_value='/index.php/archives/%post_id%' WHERE option_name='permalink_structure';"               | mysql --user="$1" --password="$2" $3
  echo "UPDATE wp_options SET option_value='a:1:{i:0;s:27:\"wp-super-cache/wp-cache.php\";}' WHERE option_name='active_plugins';"  | mysql --user="$1'" --password="$2" $3
  echo "UPDATE wp_options SET autoload='yes' WHERE option_name='active_plugins';"                                                  | mysql --user="$1" --password="$2" $3
}
