#!/bin/bash

function create_deploy_user {
	#$1 - USERNAME
        #$2 - PASSWORD
        #$3 - SSHKEY
	add_user $1 $2 "users,sudo"
	add_ssh_key $1 $3
}

function user_home {
	cat /etc/passwd | grep "^$1:" | cut --delimiter=":" -f6
}

function add_user {
	#$1 - USERNAME
	#$2 - PASSWORD
	#$3 - GROUPS
	log "Adding user $1..."
	useradd --create-home --shell "/bin/bash" --user-group --groups "$3" "$1"
	echo "$1:$2" | chpasswd
}

function add_ssh_key {
	#$1 - USERNAME
        #$2 - SSHKEY
	log "Trusting informed public ssh key for user $1..."
	USER_HOME=$(user_home "$1")
	sudo -u "$1" mkdir "$USER_HOME/.ssh"
	sudo -u "$1" touch "$USER_HOME/.ssh/authorized_keys"
	sudo -u "$1" echo "$2" >> "$USER_HOME/.ssh/authorized_keys"
	chmod 0600 "$USER_HOME/.ssh/authorized_keys"
}
