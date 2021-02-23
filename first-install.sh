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

apt-get install portsentry fail2ban htop nano nmap mariadb-server default-jre jq

echo resources/profile >> /etc/profile
ln -s resources/firewall /bin/
ln -s resources/mc /bin/
chmod 755 firewall
chmod 755 mc