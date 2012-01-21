#!/bin/bash

######################
# Ruby/RubyGem/Rails #
######################

function install_ruby
{
    cd /usr/local/src
    RUBY_VERSION=ruby-1.9.2-$RUBY_RELEASE
    wget ftp://ftp.ruby-lang.org/pub/ruby/1.9/$RUBY_VERSION.tar.gz
    tar xzf $RUBY_VERSION.tar.gz
    cd $RUBY_VERSION
    ./configure
    make
    make install
}

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

function update_rubygems {
  gem update --system
}

function set_rails_production_environment {
  cat >> /etc/environment << EOF
RAILS_ENV=$R_ENV
RACK_ENV=$R_ENV
EOF
}

function install_bundler {
  gem install bundler
}
