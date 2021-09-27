#!/bin/bash
# Author Mohammadhosein Chahardoli      https://www.linkedin.com/in/mohammadhoseinchahardoli/
####################################################################################################
# Set debug mode
set -vx
# Disable and Stop Firewalld Service
systemctl stop firewalld
systemctl disable firewalld
# Disable SELinux
sestatus
setenforce permissive
sed -i '7s/.*/SELINUX=permissive/' /etc/selinux/config
sestatus
# Set hostname
hostnamectl set-hostname minikubelab
# Configure /etc/hosts
echo -e "`ip a|grep inet|egrep -v "127.0|inet6"|awk '{print $2}'|cut -f 1 -d /`\t`hostname`" >>/etc/hosts
ping -c 2 `hostname`
# Install Dependency
yum clean all
yum install -y epel-release
yum update -y
yum upgrade -y
yum install -y git ansible vim dstat htop iotop glances xorg-x11-utils xorg-x11-xauth atop iftop wget axel nmap bind-utils net-tools conntrack yum-utils device-mapper-persistent-data lvm2
# Install Docker
yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
yum remove -y docker docker-client docker-client-latest docker-common docker-latest docker-latest-logrotate docker-logrotate docker-engine
yum install -y docker-ce docker-ce-cli containerd.io
systemctl enable docker.service
systemctl start docker.service
useradd -m -g docker docker
echo "docker:Aa#123456" | chpasswd
# get latest docker compose released tag
COMPOSE_VERSION=$(curl -s https://api.github.com/repos/docker/compose/releases/latest | grep 'tag_name' | cut -d\" -f4)
# Install docker-compose
sh -c "curl -L https://github.com/docker/compose/releases/download/${COMPOSE_VERSION}/docker-compose-`uname -s`-`uname -m` > /usr/local/bin/docker-compose"
chmod +x /usr/local/bin/docker-compose
sh -c "curl -L https://raw.githubusercontent.com/docker/compose/${COMPOSE_VERSION}/contrib/completion/bash/docker-compose > /etc/bash_completion.d/docker-compose"
# Install Kubectl
curl -LO https://storage.googleapis.com/kubernetes-release/release/`curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt`/bin/linux/amd64/kubectl
chmod +x ./kubectl
mv ./kubectl /usr/local/bin/kubectl
# Configure PATH
export PATH=$PATH:/usr/local/bin
echo 'export PATH=$PATH:/usr/local/bin' >> /root/.bashrc
kubectl version --client || exit 1
# Install minikube
curl -Lo minikube https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
chmod +x minikube
install minikube /usr/local/bin/
# Start the minikube
minikube start --driver=none
minikube status
# Unset Debug Mode
set +vx
