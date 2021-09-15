#!/bin/bash
##   ____  _
##  / __ \| |
## | |  | | |_   _ _ __ ___  _ __   __ _
## | |  | | | | | | '_ ` _ \| '_ \ / _` |
## | |__| | | |_| | | | | | | |_) | (_| |
##  \____/|_|\__, |_| |_| |_| .__/ \__,_|
##			__/ |		 | |
##		   |___/		  |_|
##
## Install all requirement. Can be used for fix
## Need to be run as root

# Outils
apt install curl htop nano nmap jq zip wget software-properties-common
# Logiciels
apt install portsentry fail2ban mariadb-server webhook screen gradle maven redis
#apt install default-jre default-jdk

# Java JDK 16 - OpenJ9
apt install -y apt-transport-https gnupg
wget https://adoptopenjdk.jfrog.io/adoptopenjdk/api/gpg/key/public
gpg --no-default-keyring --keyring ./adoptopenjdk-keyring.gpg --import public
gpg --no-default-keyring --keyring ./adoptopenjdk-keyring.gpg --export --output adoptopenjdk-archive-keyring.gpg 
rm adoptopenjdk-keyring.gpg
sudo mv adoptopenjdk-archive-keyring.gpg /usr/share/keyrings 
echo "deb [signed-by=/usr/share/keyrings/adoptopenjdk-archive-keyring.gpg] https://adoptopenjdk.jfrog.io/adoptopenjdk/deb $(cat /etc/os-release | grep VERSION_CODENAME | cut -d = -f 2) main" | sudo tee /etc/apt/sources.list.d/adoptopenjdk.list
apt update
apt install adoptopenjdk-16-openj9
apt install adoptopenjdk-11-openj9

# Ensuite, il faut ouvrir mariadb aux connexions extérieur en modifiant la config `/etc/mysql/mariadb.conf.d/50-server.cnf` -> Il faut commanter `bind-adress`
# Et ajouter le mdp redis à la config redis `/etc/redis/redis.conf` -> `requirepass <password>`