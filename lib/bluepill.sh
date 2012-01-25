#!/bin/bash

function install_bluepill {
  gem install bluepill
  echo "local6.* /var/log/bluepill.log" > /etc/rsyslog.d/bluepill.conf
  sed -i '/\/var\/log\/messages/i/var/log/bluepill.log' /etc/logrotate.d/rsyslog
  mkdir -p /var/bluepill/pids /var/bluepill/socks
  echo "$USER_NAME    ALL=(ALL) NOPASSWD:/usr/local/bin/bluepill" >> /etc/sudoers
  cat > /etc/init.d/bluepill << EOF
#!/bin/sh

# Author: Jon Kinney
# Based on the opensuse skeleton /etc/init.d/skeleton init script

### BEGIN INIT INFO
# Provides: bluepill
# Required-Start:
# Required-Stop:
# Default-Start: 2 3 4 5
# Default-Stop: 0 1 6
# Short-Description: bluepill daemon, providing process monitoring
# Description: bluepill is a monitoring tool. More info at http://github.com/arya/bluepill.
### END INIT INFO

export PATH="/usr/local/bin:\$PATH"

# Check for missing binaries
BLUEPILL_BIN=/usr/local/bin/bluepill
test -x \$BLUEPILL_BIN || { echo "\$BLUEPILL_BIN not installed";
        if [ "\$1" = "stop" ]; then exit 0;
        else exit 5; fi; }

# Check for existence of needed config file and read it
BLUEPILL_CONFIG=/etc/bluepill.conf
test -r \$BLUEPILL_CONFIG || { echo "\$BLUEPILL_CONFIG not existing";
        if [ "\$1" = "stop" ]; then exit 0;
        else exit 6; fi; }

case "\$1" in
    start)
        echo -n "Starting bluepill "
        \$BLUEPILL_BIN load \$BLUEPILL_CONFIG
        ;;
    stop)
        echo -n "Shutting down bluepill "
        \$BLUEPILL_BIN quit
        ;;
    restart)
        ## Stop the service and regardless of whether it was
        ## running or not, start it again.
        \$0 stop
        \$0 start
        ;;
    *)
        echo "Usage: \$0 {start|stop|restart}"
        exit 1
        ;;
esac
EOF
  chmod +x /etc/init.d/bluepill
  /usr/sbin/update-rc.d -f bluepill defaults
  cat > /etc/bluepill.conf << EOF
#just include here in ruby language your bluepill config
EOF
}
