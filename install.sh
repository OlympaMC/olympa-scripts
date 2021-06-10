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
apt install curl htop nano nmap jq unzip wget
# Logiciels
apt install portsentry fail2ban mariadb-server default-jre default-jdk webhook screen

chmod 777 $(pwd)/resources -R
ln -s $(pwd)/resources/firewall /bin/
ln -s $(pwd)/resources/mc /bin/
ln -s $(pwd)/resources/deploy.sh /bin/deploy