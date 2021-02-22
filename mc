#!/bin/bash
# screen -S rush1 -X stuff "say test$(printf '\r')"

# PARAMETRE

# Commandes
START="start"
STOP="stop"
SEE="see"
BACKUP="backup"
RESTART="restart"
SSH="ssh"

# Commande en cas d'erreur ou d'arguments non d?nie
USAGE="Usage: \e[0;36m$(basename "$0") $START|$STOP|$SEE all|<server>\e[0m"

# Format de la date 
DATE="$(date +"%a %d %b %Y %H:%M")"
DATE_DAY="$(date +"%j")"

# Dossier des serveurs (dossier qui contient les dossiers qui contiennent les fichiers du serveur). Il est recommand?e cr?un dossier dans /home tel que /home/<nom de votre network> pour y mettre tous les autres serveurs.
SERVEUR_DIR="/home/serveurs"
# Nom des script qui lance le serveur (qui lance le .jar). Par default start.sh
STARTSH="start.sh"

VERSION="1.16.5"
VERSION_WATERFALL="1.16"

PAPER_API_VERSION="https://papermc.io/api/v1/paper/$VERSION/latest"
PAPER_API_DOWNLOAD="$PAPER_API_VERSION/download"
WATERFALL_API_VERSION="https://papermc.io/api/v1/waterfall/$VERSION_WATERFALL/latest"
WATERFALL_API_DOWNLOAD="$WATERFALL_API_VERSION/download"

spigot_jenkins="https://papermc.io/ci/job/Paper-1.16"
spigot_file="paperclip.jar"
bungee_jenkins="https://papermc.io/ci/job/Waterfall"
bungee_file="Waterfall.jar"

# Nom de l'utilisateur avec lequel les serveurs se lance. Par default root
USER="minecraft"

# Serveurs:
# ALL="$(ls $SERVEUR_DIR)"
ALL="lobby1 omega bungee1"

# Backup mysql
BDD_USER="root"
BDD_PASSWORD="deMmeROCIR1iSGdng0RY_P_aleCQ5n3g12fSSe8iUry4_BmZcy"
BDD_HOST="localhost"

BACKUP_DIR="/home/.backup"

# FTP sauvegarde ################################
# IP (chiffr?u dns) du ftp
FTP_HOST=""
# Port du ftp (default 21)
FTP_PORT="21"
# Nom d'utiliser du compte ftp
FTP_USER=""
# Mdp du compte ftp
FTP_PASSWORD=""
# Dossier des backups sur le ftp
FTP_DIR="/serveurs/"
#- - - - - - - - - - - - - - - - - - - - - - - - - - IS OPEN - - - - - - - - - - - - - - - - - - - - - - - - - -
if [ "$1" = "isopen" ]; then

	if [ -n "$2" ]; then
		if [ `ls /run/screen/S-$USER | grep -w $2 | wc -l` -eq "0" ]; then
			echo "1"
		else
			serv_ouvert+=" $element"
			echo "0"
		fi
	else
		echo "-1"
	fi

#- - - - - - - - - - - - - - - - - - - - - - - - - - START - - - - - - - - - - - - - - - - - - - - - - - - - -
elif [ "$1" = "$START" ]; then
	if [ -n "$2" ]; then
		if [ "$2" = "all" ]; then
			serv="$ALL"
		else
			serv="${*:2}"
		fi
		echo
		for element in $serv
		do
		if [ -d "$SERVEUR_DIR/$element" ];then
			U=$(stat -c '%U' $SERVEUR_DIR/$element)
			# if [ -f "$SERVEUR_DIR/$element/$STARTSH" ];then
				if [ `ls /run/screen/S-$USER | grep -w $element | wc -l` -eq "0" ]; then
					serv_lance+=" $element"
				else
					serv_ouvert+=" $element"
				fi
			# else
				# serv_script+=" $element"
			# fi
		else
			serv_dossier+=" $element"
		fi
		done
		if [ "$element" = "omega" ]; then
			sh -c "cd /home/omega; sh $STARTSH"
			echo -e "\e[32m$element\e[0;32m a démarré\e[0m"
		else 
			if [ -n "$serv_dossier" ]; then
				echo -e "\e[31m$serv_dossier\e[0;31m n'existe pas (dossier $SERVEUR_DIR/nom du serveur)\e[0m"
			fi
			# if [ -n "$serv_script" ]; then	
				# echo -e "\e[35m$serv_script\e[0;35m n'existe pas (fichier $STARTSH)\e[0m"
			# fi
			if [ -n "$serv_ouvert" ]; then
				echo -e "\e[36m$serv_ouvert\e[0;36m est déjà ouvert\e[0m"
			fi
			if [ -n "$serv_lance" ]; then
				for element in $serv_lance
				do
					U=$(stat -c '%U' $SERVEUR_DIR/$element)
					sh -c "cd $SERVEUR_DIR/$element; sh $STARTSH"
				done
				echo -e "\e[32m$serv_lance\e[0;32m a démarré\e[0m"
			fi
		fi
		
	else
		read -p 'Quel(s) serveur(s) ? ' server_select
		$0 $START $server_select
	fi
#- - - - - - - - - - - - - - - - - - - - - - - - - - STOP - - - - - - - - - - - - - - - - - - - - - - - - - -
elif [ "$1" = "$STOP" ]; then
	if [ -n "$2" ]; then
		if [ "$2" = "all" ]; then
			serv="$ALL"
		else
			serv="${*:2}"
		fi
		for element in $serv
		do
			U=$(stat -c '%U' $SERVEUR_DIR/$element)
			if [ `ls /run/screen/S-$USER | grep -w $element | wc -l` -eq "1" ]; then
				if [[ $element == bungee* ]]; then
					serv_vafermerb+=" $element"
				else
					serv_vafermer+=" $element"
				fi
			else
				serv_fermer+=" $element"
			fi
		done
	echo
	if [ -n "$serv_vafermerb" ]; then
		for element in $serv_vafermerb
		do
			U=$(stat -c '%U' $SERVEUR_DIR/$element)
			screen -S $element -X stuff 'end\r'
		done
		echo -e "\e[36m$serv_vafermerb\e[0;36m s'est arrêté (BUNGEE)\e[0m"
		
	fi
	if [ -n "$serv_vafermer" ]; then
		for element in $serv_vafermer
		do
			U=$(stat -c '%U' $SERVEUR_DIR/$element)
			screen -S $element -X stuff 'stop\r'
		done
		echo -e "\e[36m$serv_vafermer\e[0;36m s'est arrêté \e[0m"
	fi
	if [ -n "$serv_fermer" ]; then
		echo -e "\e[31m$serv_fermer\e[0;31m n'est pas ouvert\e[0m"
	fi
	
	else
		read -p 'Quel(s) serveur(s) ? ' server_select
		$0 $STOP $server_select
	fi
	echo
#- - - - - - - - - - - - - - - - - - - - - - - - - - - BACKUP - - - - - - - - - - - - - - - - - - - - - - - - - -
elif [ "$1" = "backupserv" ]; then
	echo -e "\e[32mCréation de la backup des serveurs...\e[0m"
	tar -c $SERVEUR_DIR | pv -s $(du -sb $SERVEUR_DIR | awk '{print $1}') > "$BACKUP_DIR/$DATE_DAY | serveurs.tar"
#- - - - - - - - - - - - - - - - - - - - - - - - - - - BACKUP - - - - - - - - - - - - - - - - - - - - - - - - - -
elif [ "$1" = "backupbdd" ]; then
	echo -e "\e[32mCréation de la backup bdd ...\e[0m"
	SIZE_BYTES=$(mysql --skip-column-names -h $BDD_HOST -u $BDD_USER -p$BDD_PASSWORD <<< 'SELECT SUM(data_length) AS "size_bytes" FROM information_schema.TABLES;')
	mysqldump -h $BDD_HOST -u $BDD_USER -p$BDD_PASSWORD -A -x | pv --progress --size $SIZE_BYTES > "$BACKUP_DIR/$DATE_DAY | databases.sql"
#- - - - - - - - - - - - - - - - - - - - - - - - - - - BACKUP - - - - - - - - - - - - - - - - - - - - - - - - - -
elif [ "$1" = "$BACKUP" ]; then
	find "$BACKUP_DIR/" -type f -mtime +0 -exec rm {} \;
	# find "/home/.backup/" -type f -mtime +1 -exec rm {} \;
	echo -e "\e[94mSuppression des backups de + de 2 jours effectué."
	for element in `ls $SERVEUR_DIR`
	do
		find "$SERVEUR_DIR/$element/logs/" -type f -mtime +1 -exec rm {} \;
		if [ `ls /run/screen/S-$USER | grep -w $element | wc -l` -eq "1" ]; then
			serv_allumer+=" $element"
		fi
	done
	echo -e "\e[94mSuppression des logs des serveurs minecraft de + de 2 jours effectué.\e[0m"

	if [ "$serv_allumer" != "" ]; then
		echo -e "\e[93mLes serveurs$serv_allumer sont encore ouvert, les joueurs ont reçu un message leur annonçant la fermeture dans 15 mins.\e[0m"
		for element in $serv_allumer
		do
			if [[ $element == bungee* ]]; then
				backupb+=" $element"
			else
				backupm+=" $element"
			fi
		done
		for element in $backupm
		do
			screen -S $element -p 0 -X stuff "tellraw @a [\"\",{\"text\":\"[\",\"color\":\"dark_red\"},{\"text\":\"INFO\",\"color\":\"gold\"},{\"text\":\"] \",\"color\":\"dark_red\"},{\"text\":\"Redémarrage des serveurs dans 15 minutes.\",\"bold\":true,\"color\":\"red\"}]^M"
		done
		echo -e "\e[93mFermeture dans 15 mins.\e[0m"
		sleep 300
		
		for element in $backupm
		do
			screen -S $element -p 0 -X stuff "tellraw @a [\"\",{\"text\":\"[\",\"color\":\"dark_red\"},{\"text\":\"INFO\",\"color\":\"gold\"},{\"text\":\"] \",\"color\":\"dark_red\"},{\"text\":\"Redémarrage des serveurs dans 10 minutes.\",\"bold\":true,\"color\":\"red\"}]^M"
		done
		echo -e "\e[93mFermeture dans 10 mins.\e[0m"
		sleep 300
		
		for element in $backupm
		do
			screen -S $element -p 0 -X stuff "tellraw @a [\"\",{\"text\":\"[\",\"color\":\"dark_red\"},{\"text\":\"INFO\",\"color\":\"gold\"},{\"text\":\"] \",\"color\":\"dark_red\"},{\"text\":\"Redémarrage des serveurs dans 5 minutes.\",\"bold\":true,\"color\":\"red\"}]^M"
		done
		echo -e "\e[93mFermeture dans 5 mins.\e[0m"
		sleep 180
		for element in $backupm
		do
			screen -S $element -p 0 -X stuff "tellraw @a [\"\",{\"text\":\"[\",\"color\":\"dark_red\"},{\"text\":\"INFO\",\"color\":\"gold\"},{\"text\":\"] \",\"color\":\"dark_red\"},{\"text\":\"Redémarrage des serveurs dans 2 minutes.\",\"bold\":true,\"color\":\"red\"}]^M"
		done
		echo -e "\e[93mFermeture dans 2 mins.\e[0m"
		sleep 60
		for element in $backupm
		do
			screen -S $element -p 0 -X stuff "tellraw @a [\"\",{\"text\":\"[\",\"color\":\"dark_red\"},{\"text\":\"INFO\",\"color\":\"gold\"},{\"text\":\"] \",\"color\":\"dark_red\"},{\"text\":\"Redémarrage des serveurs dans 1 minutes.\",\"bold\":true,\"color\":\"red\"}]^M"
		done
		echo -e "\e[93mFermeture dans 1 min.\e[0m"
		sleep 55
		for element in $backupm
		do
			screen -S $element -p 0 -X stuff "tellraw @a [\"\",{\"text\":\"[\",\"color\":\"dark_red\"},{\"text\":\"INFO\",\"color\":\"gold\"},{\"text\":\"] \",\"color\":\"dark_red\"},{\"text\":\"Redémarrage des serveurs dans 5 secondes.\",\"bold\":true,\"color\":\"red\"}]^M"
		done
		sleep 5
		for element in $backupm
		do
			screen -S $element -X stuff 'kick @a §6§lRedémarrage des serveurs en cours\r'
		done
		echo -e "\e[93mTous les joueurs ont été kick.\e[0m"
		sleep 5
		mc stop $serv_allumer
		
		serv_allumer2="open"
		i=0
		while [ "$serv_allumer2" != "" ] && [ "$i" -lt "60" ]
		do
			sleep 1
			serv_allumer2=""
			for element in $serv_allumer
			do
				if [ `ls /run/screen/S-$USER | grep -w $element | wc -l` -eq "1" ]; then
					serv_allumer2+=" $element"
				fi
			done
			let "i = i + 1"
			if [ "$serv_allumer2" != "" ]; then
				echo -e "\e[91mLes serveurs\e[36m$serv_allumer2\e[91m ne sont pas encore fermée, attente $i secondes / 60 secondes\e[0m"
			fi
		done
		for element in `ls $SERVEUR_DIR`
		do
			if [ `ls /run/screen/S-$USER | grep -w $element | wc -l` -eq "1" ]; then
				U=$(stat -c '%U' $SERVEUR_DIR/$element)
				screen -X -S $element kill
				echo -e "\e[91m$element a été fermer de force.\e[0m"
			fi
		done
	fi
	mc backupserv
	mc backupbdd

	echo -e "\e[92mRécupération de la dernière MAJ de Paperspigot...\e[0m"
	old_build_id=`cat paperspigot_build_id.txt`
	build_id=`wget -qO- $PAPER_API_VERSION | jq -r '.build'`
	if [ -z $old_build_id ] || [ "$build_id" -gt $old_build_id ]
	then
		echo -e "\e[92mMise à jour des PaperSpigot...\e[0m"
		rm $spigot_file
		wget $PAPER_API_DOWNLOAD
		echo $build_id > paperspigot_build_id.txt
		for element in `ls $SERVEUR_DIR`
		do
			if [[ $element != bungee* ]]; then
				rm $SERVEUR_DIR/$element/$spigot_file
				cp $spigot_file $SERVEUR_DIR/$element
			fi
		done
	fi
	echo -e "\e[92mRécupération de la dernière MAJ de WaterFall...\e[0m"
	old_build_id=`cat bungee_build_id.txt`
	build_id=`wget -qO- $WATERFALL_API_VERSION | jq -r '.build'`
	if [ -z $old_build_id ] || [ "$build_id" -gt $old_build_id ]
	then
		echo -e "\e[92mMise à jour du WaterFall...\e[0m"
		rm $bungee_file
		wget $WATERFALL_API_DOWNLOAD
		echo $build_id > bungee_build_id.txt
		for element in `ls $SERVEUR_DIR`
		do
			if [[ $element == bungee* ]]; then
				rm $SERVEUR_DIR/$element/$bungee_file
				cp $bungee_file $SERVEUR_DIR/$element
			fi
		done
	fi
	echo -e "\e[92mRéouverture de tous les serveurs...\e[0m"
	mc start all
	echo -e "\e[32mTous est parfait, les serveurs se lancent !\e[0m"
#- - - - - - - - - - - - - - - - - - - - - - - - - - - RESTART - - - - - - - - - - - - - - - - - - - - - - - - - -
elif [ "$1" = "$RESTART" ]; then
	if [ -n "$2" ]; then
		if [ "$2" = "all" ]; then
			serv="$ALL"
		else
			serv="${*:2}"
		fi
		for element in $serv
		do
			if [ `ls /run/screen/S-$USER | grep -w $element | wc -l` -eq "1" ]; then
				serv_vafermer+=" $element"
			else
				serv_fermer+=" $element"
			fi
		done
		echo
		if [ -n "$serv_fermer" ]; then
			echo -e "\e[31m$serv_fermer\e[0;31m n'est pas ouvert\e[0m"
		fi
		if [ -n "$serv_vafermer" ]; then
			mc stop $serv_vafermer
			# ----
			for element in $serv_vafermer
			do
				if [ `ls /run/screen/S-$USER | grep -w $element | wc -l` -eq "1" ]; then
					serv_allumer+=" $element"
				fi
			done
			serv_allumer2="open"
			i=0
			while [ "$serv_allumer2" != "" ] && [ "$i" -lt "60" ]
			do
				sleep 1
				serv_allumer2=""
				for element in $serv_allumer
				do
					if [ `ls /run/screen/S-$USER | grep -w $element | wc -l` -eq "1" ]; then
						serv_allumer2+=" $element"
					fi
				done
				let "i = i + 1"
				if [ "$serv_allumer2" != "" ]; then
					if [ ! [ $i % 10 ] ] ; then
						mc stop $serv_allumer2
						echo -e "\e[91mTentative de fermeture de \e[36m$serv_allumer2\e[91m, attente $i secondes (max 60 secondes)\e[0m"
					else
						echo -e "\e[91mLes serveurs\e[36m$serv_allumer2\e[91m ne sont pas encore fermée, attente $i secondes (max 60 secondes)\e[0m"
					fi
				fi
			done
			for element in $serv_vafermer
			do
				if [ `ls /run/screen/S-$USER | grep -w $element | wc -l` -eq "1" ]; then
					screen -X -S $element kill
					echo -e "\e[91m$element a été fermer de force.\e[0m"
				fi
			done
			mc start $serv_vafermer
			echo -e "\e[36m$serv_vafermer\e[0;36m s'est redémarrer \e[0m"
		fi
	else
		read -p 'Quel(s) serveur(s) ? ' server_select
		$0 $RESTART $server_select
	fi
	echo
#- - - - - - - - - - - - - - - - - - - - - - - - - - - MDP - - - - - - - - - - - - - - - - - - - - - - - - - -
elif [ "$1" = "mdp" ]; then
	length=${2:-50}
	tr -dc A-Za-z0-9_ < /dev/urandom | head -c ${length} | xargs
#- - - - - - - - - - - - - - - - - - - - - - - - - - - COPY - - - - - - - - - - - - - - - - - - - - - - - - - -
elif [ "$1" = "copy" ]; then
	if [ -n $2 ]; then
		for element in `ls $SERVEUR_DIR`
		do
			if [ $2 != $element ]; then
				cp $SERVEUR_DIR/$2/plugins/OlympaCore.jar $SERVEUR_DIR/$element/plugins/OlympaCore.jar
				mv $SERVEUR_DIR/$element/plugins/OlympaCore.jar.temp $SERVEUR_DIR/$element/plugins/OlympaCore.jar
			fi
		done
		echo -e "\e[32mOlympaCore est désormais MAJ sur tous les serveurs !\e[0m"
	fi
#- - - - - - - - - - - - - - - - - - - - - - - - - - - LINK - - - - - - - - - - - - - - - - - - - - - - - - - -
elif [ "$1" = "link" ]; then

	USAGElink="/mc link <server> <mode>"
	
	if [ -d "/home/serveurs/.other/link/$3" ]; then
		mode="$3"
		echo
		read -p "Etes vous de vouloir link le serveur $2 en mode $mode ? (y/n)" yesorno
		if [ $yesorno == 'y' ]; then
			cp -lr $SERVEUR_DIR/.other/link/$mode/* $SERVEUR_DIR/$2/
			cp -lr $SERVEUR_DIR/.other/link/common/* $SERVEUR_DIR/$2/
			echo -e "\e[32mLe serveur a été link\e[0m"
		else
			echo -e "\e[32mLe serveur n'a pas été link\e[0m"
	
		fi
	else
		echo $USAGElink
	fi

#- - - - - - - - - - - - - - - - - - - - - - - - - - - SEE - - - - - - - - - - - - - - - - - - - - - - - - - -
elif [ "$1" = "$SEE" ]; then
	if [ -n "$2" ]; then
		U=$(stat -c '%U' $SERVEUR_DIR/$2)
		screen -x "${*:2}"
	fi
#- - - - - - - - - - - - - - - - - - - - - - - - - - - deploy - - - - - - - - - - - - - - - - - - - - - - - - - -
elif [ "$1" = "deploy" ]; then
	if [ -n "$2" ]; then
		if [ "$2" = "buildtools" ]; then
			cd /home/repo/$2/ && sh start.sh
			echo -e "\e[32mLe jar de dernière version de Spigot a été crée."
		elif [ "$2" = "ALL" ]; then
			for element in `ls /home/repo`
			do
				if [ -f "/home/repo/$element/deploy.sh" ]; then
					cd /home/repo/$element/ && sh deploy.sh
					echo -e "\e[32mLe jar de $selement a été crée."
				fi
			done
		else
			cd /home/repo/olympa$2/ && sh deploy.sh
			echo -e "\e[32mLe jar du $2 a été crée."
			echo -e "\e[32mIl faut maintenant copier le jar sur le serveur."
			echo -e "cp /home/repo/olympa$2/target/Olympa*.jar $SERVEUR_DIR/<serveur>/plugins/"
		fi
	else
		for element in `ls /home/repo`
		do
			if [ -f "/home/repo/$element/deploy.sh" ]; then
				repos+=" $element"
			fi
		done
		echo -e "\e[91mLe premier argument doit être dans la liste suivante (sans le prefix Olympa)\n$repos\nou ALL\e[0m"
	fi
#- - - - - - - - - - - - - - - - - - - - - - - - - - - deployTo - - - - - - - - - - - - - - - - - - - - - - - - - -
elif [ "$1" = "deployto" ]; then
	if [ -n "$2" ] && [ -n "$3" ]; then
		if [ "$3" = "ALL" ]; then
			server_to_up="$(ls $SERVEUR_DIR)"
		else
			server_to_up=${@:3}
		fi
		mc stop $server_to_up
		for element in $server_to_up
		do
			if [ `ls /run/screen/S-$USER | grep -w $element | wc -l` -eq "1" ]; then
				serv_allumer+=" $element"
			fi
		done
		serv_allumer2="open"
		i=0
		while [ "$serv_allumer2" != "" ] && [ "$i" -lt "60" ]
		do
			sleep 1
			serv_allumer2=""
			for element in $serv_allumer
			do
				if [ `ls /run/screen/S-$USER | grep -w $element | wc -l` -eq "1" ]; then
					serv_allumer2+=" $element"
				fi
			done
			let "i = i + 1"
			if [ "$serv_allumer2" != "" ]; then
				if [ ! [ $i % 10 ] ] ; then
					mc stop $serv_allumer2
					echo -e "\e[91mTentative de fermeture de \e[36m$serv_allumer2\e[91m, attente $i secondes (max 60 secondes)\e[0m"
				else
					echo -e "\e[91mLes serveurs\e[36m$serv_allumer2\e[91m ne sont pas encore fermée, attente $i secondes (max 60 secondes)\e[0m"
				fi
			fi
		done
		for element in $server_to_up
		do
			if [ `ls /run/screen/S-$USER | grep -w $element | wc -l` -eq "1" ]; then
				screen -X -S $element kill
				echo -e "\e[91m$element a été fermer de force.\e[0m"
			fi
		done
		for element in $server_to_up
		do
			cp -v /home/repo/olympa$2/target/Olympa*.jar $SERVEUR_DIR/$element/plugins/
			echo -e "\e[36molympa$2\e[0;36m a été deploy sur \e[36m$element\e[0m"
		done
		mc start $serv_allumer
	else
		for element in `ls /home/repo`
		do
			if [ -f "/home/repo/$element/deploy.sh" ]; then
				repos+=" $element"
			fi
		done
		echo -e "\e[91mLe premier argument doit être dans la liste suivante (sans le prefix Olympa)\n$repos\nLes arguments suivants doivent être des noms de serveurs\e[0m"
	fi
#- - - - - - - - - - - - - - - - - - - - - - - - - - - TS - - - - - - - - - - - - - - - - - - - - - - - - - -
elif [ "$1" = "ts" ]; then
	telnet 172.0.0.1 10011
	#- - - - - - - - - - - - - - - - - - - - - - - - - - - REDIS - - - - - - - - - - - - - - - - - - - - - - - - - -
elif [ "$1" = "redis" ]; then
	redis-cli -a 1rWS1Fmj7s4snEDCQgw3Mcznf8ShfrLZpPkKtstu5coV9PpDI1
#- - - - - - - - - - - - - - - - - - - - - - - - - - USAGE - - - - - - - - - - - - - - - - - - - - - - - - - -
else
	echo -e "$USAGE"
fi
