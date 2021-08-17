#!/bin/bash
##   ____  _
##  / __ \| |
## | |  | | |_   _ _ __ ___  _ __   __ _
## | |  | | | | | | '_ ` _ \| '_ \ / _` |
## | |__| | | |_| | | | | | | |_) | (_| |
##  \____/|_|\__, |_| |_| |_| .__/ \__,_|
##            __/ |         | |
##           |___/          |_|
##
git reset --hard HEAD && git pull

chmod 777 $(pwd)/resources -R
chmod 700 $(pwd)/resources/backup
chown root:root $(pwd)/resources/backup
ln -s $(pwd)/resources/firewall /bin/
ln -s $(pwd)/resources/mc /bin/
ln -s $(pwd)/resources/deploy.sh /bin/deploy
ln -s $(pwd)/resources/update.sh /bin/update
ln -s $(pwd)/resources/backup.sh /bin/backup