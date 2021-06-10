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

/bin/setfacl -m u:minecraft:--- /usr/bin/mysql
/bin/setfacl -m u:bullobily:--- /usr/bin/mysql
/bin/setfacl -m u:ayfri:--- /usr/bin/mysql
/bin/setfacl -m u:loockeeer:--- /usr/bin/mysql

/bin/setfacl -m u:minecraft:--- /usr/bin/redis-cli
/bin/setfacl -m u:bullobily:--- /usr/bin/redis-cli
/bin/setfacl -m u:ayfri:--- /usr/bin/redis-cli
/bin/setfacl -m u:loockeeer:--- /usr/bin/redis-cli