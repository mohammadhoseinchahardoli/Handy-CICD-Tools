#!/bin/bash
# Author       : Mohammad Hosein Chahardoli         https://www.linkedin.com/in/mohammadhoseinchahardoli/
# Description  : This bash script install docker-ce and docker-compose.
# Last Modified: 10/03/2021
# exit status
# 127		wronge OS
####################################################################################################
function osversioncheck {
	# Must be Enterprise Linux 7.x
if [[ -f /etc/os-release ]]; then
		# freedesktop.org and systemd
		. /etc/os-release
		export OS=$NAME
		export VER=$VERSION_ID
else
        echo 'Sorry, This script developed for Enterprise Linux 7.x family. It seems your distribution not supported in this release.'
		exit 127
fi

if [[ $OS == 'Oracle Linux Server' ]]; then
	if [[ $VER == 7* ]]; then
		:
	else
		echo 'Sorry, This script developed for Enterprise Linux 7.x family. It seems your distribution not supported in this release.'
		exit 127
	fi
elif [[ $OS == 'CentOS Linux' ]]; then
	if [[ $VER == 7* ]]; then
		:
	else
		echo 'Sorry, This script developed for Enterprise Linux 7.x family. It seems your distribution not supported in this release.'
		exit 127
	fi
elif [[ $OS == 'Red Hat Enterprise Linux Server' ]]; then
	if [[ $VER == 7* ]]; then
		:
	else
		echo 'Sorry, This script developed for Enterprise Linux 7.x family. It seems your distribution not supported in this release.'
		exit 127
	fi
fi
}

function rootusercheck {
	if [[ $USER == root ]]; then
		:
	else
		echo 'Sorry, You must run this script as root user. Please login via root user and try again.'
		exit 128
	fi
}

function hostnamesetup {
	hostnamectl set-hostname docker
	echo -e "`ip a|grep inet|egrep -v "127.0|inet6"|awk '{print $2}'|cut -f 1 -d /`\t`hostname`" >>/etc/hosts
	ping -c 2 `hostname`
}

function reposetup {
	yum clean all && yum update -y && yum upgrade -y && yum install -y yum-utils device-mapper-persistent-data lvm2 && yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
}

function docker-compose {
	curl -L "https://github.com/docker/compose/releases/download/1.28.5/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
	chmod +x /usr/local/bin/docker-compose
}

function postinstallation {
	useradd -m -g docker docker
	echo "docker:Aa#123456" | chpasswd
}

osversioncheck
rootusercheck
hostnamesetup
yum remove -y docker docker-client docker-client-latest docker-common docker-latest docker-latest-logrotate docker-logrotate docker-engine
reposetup
yum install -y docker-ce docker-ce-cli containerd.io
systemctl enable docker.service
systemctl start docker.service
docker-compose
postinstallation
