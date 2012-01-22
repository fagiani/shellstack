#!/bin/bash

function install_redis {
  cd /usr/local/src
  wget http://redis.googlecode.com/files/redis-$REDIS_VERSION.tar.gz
  tar xvzf redis-$REDIS_VERSION.tar.gz
  cd redis-$REDIS_VERSION
  make
  make install
  mkdir -p /var/lib/redis
  mkdir -p /var/log/redis
  /usr/sbin/useradd --system --user-group --home-dir /var/lib/redis redis
  chown redis.redis /var/lib/redis
  chown redis.redis /var/log/redis
  wget "https://github.com/ijonas/dotfiles/raw/master/etc/init.d/redis-server" -O /etc/init.d/redis-server
  chmod +x /etc/init.d/redis-server
  /usr/sbin/update-rc.d -f redis-server defaults
  cat > /etc/redis.conf << EOF
daemonize yes
pidfile /var/run/redis.pid
port 6379
timeout 0
loglevel verbose
logfile /var/log/redis/redis.log
databases 16
save 900 1
save 300 10
save 60 10000
rdbcompression yes
dbfilename dump.rdb
dir ./
slave-serve-stale-data yes
appendonly no
appendfsync everysec
no-appendfsync-on-rewrite no
auto-aof-rewrite-percentage 100
auto-aof-rewrite-min-size 64mb
slowlog-log-slower-than 10000
slowlog-max-len 1024
vm-enabled no
vm-swap-file /tmp/redis.swap
vm-max-memory 0
vm-page-size 32
vm-pages 134217728
vm-max-threads 4
hash-max-zipmap-entries 512
hash-max-zipmap-value 64
list-max-ziplist-entries 512
list-max-ziplist-value 64
set-max-intset-entries 512
zset-max-ziplist-entries 128
zset-max-ziplist-value 64
activerehashing yes
EOF
  /etc/init.d/redis-server start
}
