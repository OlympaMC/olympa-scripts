#!/bin/bash
if [ ! -d "plugins" ];then
	echo "Dossier plugins n'existe pas"
	exit 1
fi
if [ ! -d "pluginsNew" ];then
	echo "Dossier pluginsNew n'existe pas, création"
	mkdir pluginsNew
	chmod 770 pluginsNew
	exit 1
else
	if [ -z "$(ls -A pluginsNew)" ]; then
		echo "Dossier pluginsNew vide"
		exit 1
	fi
	files=`ls pluginsNew`
	if [ ! -d "pluginsOld" ];then
		echo "Dossier pluginsOld n'existe pas, création"
		mkdir pluginsOld
		chmod 770 pluginsNew
		exit
	fi
	for file in $files
	do
		mv plugins/$file pluginsOld/
		echo "Mv plugins/$file to pluginsOld/"
	done
	for file in $files
	do
		chmod 770 pluginsNew/$file
		chown minecraft:minecraft pluginsNew/$file
		mv pluginsNew/$file plugins/
		echo "Mv pluginsNew/$file to plugins/"
	done
fi
