#
# Ubuntu Server 18.04.3 LTS (Bionic Beaver)
# Basic packages
# Installs multiple packages on Ubuntu Server 18.04 (Bionic Beaver)
#
# Author: Pavel Petrov <papahelmsman@gmail.com>
#

.PHONY: all preparations libs update upgrade fonts nginx-install

all:
	@echo "Installation of all targets"
	make update
	make upgrade
	make clean
	make prerequisites
	make git
	make apt-transport-https

	make nginx-install

	make reboot

update:
	sudo apt update

upgrade:
	sudo apt upgrade -y

curl:
	sudo apt install curl

gnupg2:
	sudo apt install gnupg2

ca-certificates:
	sudo apt install ca-certificates

lsb-release:
	sudo apt install lsb-release

prerequisites:
	sudo apt install wget curl zip unzip screen ffmpeg libfile-fcntllock-perl tree

	sudo apt install -y \
		zip \
		ffmpeg \
		ghostscript

	sudo apt install \
		libfile-fcntllock-perl \
		tree \
		gnupg2 \
		ssl-cert \
		apt-transport-https \

nginx-repo-setup:
	echo "deb [arch=amd64] http://nginx.org/packages/mainline/ubuntu `lsb_release -cs` nginx" | sudo tee /etc/apt/sources.list.d/nginx.list

nginx-install: update curl gnupg2 ca-certificates lsb-release
	curl -fsSL https://nginx.org/keys/nginx_signing.key | sudo apt-key add -
	sudo apt install nginx -y
	sudo systemctl enable nginx.service

nginx-config:
	sudo mv /etc/nginx/nginx.conf /etc/nginx/nginx.conf.bak && vi /etc/nginx/nginx.conf


reposetup:
	echo "deb [arch=amd64] http://nginx.org/packages/mainline/ubuntu `lsb_release -cs` nginx" \
        | sudo tee /etc/apt/sources.list.d/nginx.list
	echo "deb [arch=amd64] http://ppa.launchpad.net/ondrej/php/ubuntu $(lsb_release -cs) main" \
		| sudo tee /etc/apt/sources.list.d/php.list
