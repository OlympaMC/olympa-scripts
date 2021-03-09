##   ____  _
##  / __ \| |
## | |  | | |_   _ _ __ ___  _ __   __ _
## | |  | | | | | | '_ ` _ \| '_ \ / _` |
## | |__| | | |_| | | | | | | |_) | (_| |
##  \____/|_|\__, |_| |_| |_| .__/ \__,_|
##            __/ |         | |
##           |___/          |_|
##
## Install all requirement and add default value to OS
## Need to be run as root

# Outils
apt install curl htop nano nmap jq unzip
# Logiciels
apt install portsentry fail2ban mariadb-server default-jre default-jdk webhook

echo resources/profile >> /etc/profile
chmod 755 resources/firewall
chmod 755 resources/mc
ln -s resources/firewall /bin/
ln -s resources/mc /bin/