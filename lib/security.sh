#!/bin/bash

#################################
#	Security                #
#################################

function set_basic_security {
        log "Setting up basic security..."
	install_fail2ban
	install_ufw
	basic_ufw_setup
	sshd_permit_root_login No
	sshd_password_authentication No
	sshd_pub_key_authentication Yes
	/etc/init.d/ssh restart
}

function install_fail2ban {
    aptitude -y install fail2ban
}

function install_ufw {
    aptitude -y install ufw
}

function basic_ufw_setup {
    # see https://help.ubuntu.com/community/UFW
    ufw logging on
    ufw default deny
    ufw allow ssh
    ufw allow http
    ufw allow https
    ufw enable
}

function security_logcheck {
    aptitude -y install logcheck logcheck-database
}

function sshd_edit_bool {
    # $1 - param name
    # $2 - Yes/No
    VALUE=`lower $2`
    if [ "$VALUE" == "yes" ] || [ "$VALUE" == "no" ]; then
        sed -i "s/^#*\($1\).*/\1 $VALUE/" /etc/ssh/sshd_config
    fi
}

function sshd_permit_root_login {
    sshd_edit_bool "PermitRootLogin" "$1"
}

function sshd_password_authentication {
    sshd_edit_bool "PasswordAuthentication" "$1"
}

function sshd_pub_key_authentication {
    sshd_edit_bool "PubkeyAuthentication" "$1"
}

function sshd_password_authentication {
    sshd_edit_bool "PasswordAuthentication" "$1"
}
