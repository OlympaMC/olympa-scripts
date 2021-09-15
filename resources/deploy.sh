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
## Script to deploy api with good version
## Author > Tristiisch
# chmod 700 /home/repo/olympa-*/ -R
#
# ./deploy.sh api master
# ./deploy.sh core dev

# PARAMETRES
SERVEUR_DIR="/home/data/repo"

cd $SERVEUR_DIR

if [ -n "$1" ] && [ "$1" = "executeall" ]; then
	for plugin in `ls -d $SERVEUR_DIR/*/`
	do
		cd $plugin && ${@:2}
	done
elif [ -n "$1" ] && [ "$1" = "execute" ]; then
	for plugin in `ls -d $SERVEUR_DIR/olympa-*/`
	do
		cd $plugin && ${@:2}
	done
else
	if [ -n "$1" ] && [ -n "$2" ]; then
		PLUGIN_NAME="$1"
		BRANCH_NAME="$2"
		if [ ! -d $SERVEUR_DIR/*$PLUGIN_NAME ]; then
				echo -e "\e[91m$SERVEUR_DIR/olympa-$PLUGIN_NAME n'existe pas.\e[0m"
				exit 1
		else
			PLUGIN_DIR="$SERVEUR_DIR/olympa*$PLUGIN_NAME"
		fi
		# DÉPENDANCES
		if [ $PLUGIN_NAME == "core" ]; then
			bash $0 api master justGitPull
		elif [ $PLUGIN_NAME == "zta" ]; then
			bash $0 core dev justGitPull
		elif [ $PLUGIN_NAME == "creatif" ]; then
			bash $0 core dev justGitPull
		elif [ $PLUGIN_NAME == "pvpkit" ]; then
			bash $0 core dev justGitPull
		elif [ $PLUGIN_NAME == "bungee" ]; then
			bash $0 core dev justGitPull
		fi
		cd $PLUGIN_DIR
		if [ "$?" -ne 0 ]; then
			echo -e "\e[91mErreur > Arrêt du maven build du $PLUGIN_NAME\e[0m"; exit 1
		fi
	else
		echo -e "\e[91mTu dois choisir la version du $PLUGIN_NAME en ajoutant une branch (ex './deploy.sh core $master')"
		echo -e "un commit (ex './deploy.sh dev commitId').\e[0m"
		exit 1
	fi
	git pull --all
	if [ "$?" -ne 0 ]; then
		echo -e "\e[91mEchec du git pull pour $PLUGIN_NAME, tentative de git checkout\e[0m"
		#git reset --hard HEAD
		git checkout $BRANCH_NAME --force
		if [ "$?" -ne 0 ]; then
			echo -e "\e[91mEchec du git checkout pour $PLUGIN_NAME.[0m"; exit 1
		fi
		git pull --all
		if [ "$?" -ne 0 ]; then
			echo -e "\e[91mEchec du git pull pour $PLUGIN_NAME.\e[0m"; exit 1
		fi
	else
		git checkout $BRANCH_NAME --force
		if [ "$?" -ne 0 ]; then
			echo -e "\e[91mEchec du git checkout pour $PLUGIN_NAME.\e[0m"; exit 1
		fi
	fi
	if [[ ${@:1} == *justGitPull ]]; then
		echo -e "\e[0;36mLe $PLUGIN_NAME n'a pas été build comme demandé, il a juste été git pull.\e[0m"; exit 0
	else
		if [ -f "pom.xml" ]; then
			export JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64/
			mvn clean install
		else
			if [ $PLUGIN_NAME == "core" ] || [ $PLUGIN_NAME == "api" ]; then
				./gradlew publishToMavenLocal
			elif [ $PLUGIN_NAME == "bot" ]; then
				./gradlew shadowJar
			else
				./gradlew jar
			fi
		fi
	fi
	if [ "$?" -ne 0 ]; then
		echo -e "\e[91mLe build du $PLUGIN_NAME a échoué !\e[0m"; exit 1
	fi
	echo -e "\e[32mLe jar $PLUGIN_NAME du commit ` git rev-parse HEAD` a été build.\e[0m"
fi
