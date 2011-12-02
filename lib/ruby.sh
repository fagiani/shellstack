#!/bin/bash

function create_gemrc {
	cat > ~/.gemrc << EOF
verbose: true
bulk_treshold: 1000
install: --no-ri --no-rdoc --env-shebang
benchmark: false
backtrace: false
update: --no-ri --no-rdoc --env-shebang
update_sources: true
EOF
	cp ~/.gemrc $USER_HOME
	chown $DEPLOY_USER:$DEPLOY_USER $USER_HOME/.gemrc
}

######################
# Ruby / Rails       #
######################

function ruby_install
{
	local curdir=$(pwd)

	ruby_ee_source_url=$(echo $(wget -O-  http://www.rubyenterpriseedition.com/download.html 2>/dev/null ) | egrep -o 'href="[^\"]*\.tar\.gz' | sed 's/^href="//g')
	mkdir /tmp/ruby
	cd /tmp/ruby

	aptitude install -y build-essential zlib1g-dev libssl-dev
	aptitude install -y libreadline5-dev >/dev/null 2>&1
	aptitude install -y libreadline6-dev >/dev/null 2>&1
	aptitude install -y libreadline-dev  >/dev/null 2>&1

	wget "$ruby_ee_source_url"
	tar xvzf *.tar.gz
	rm -rf *.tar.gz

	cd ruby*
	if [ -e "source/ext/openssl/ossl_ssl.c" ] ; then
		sed -i 's/OSSL_SSL_METHOD_ENTRY.SSLv2[\)_].*$/ /g' "source/ext/openssl/ossl_ssl.c"
	fi

	./installer --auto "$RUBY_PREFIX"
	for ex in erb gem irb rackup rails rake rdoc ri ruby bundle ; do
		ln -s "$RUBY_PREFIX/bin/$ex" "/usr/bin/$ex"
	done

        # Install rails
        gem install rails --no-ri --no-rdoc

	cd "$curdir"
	rm -rf /tmp/ruby
}
