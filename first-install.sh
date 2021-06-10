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
## Install all requirement and add default value to OS. Use it only at once.
## Need to be run as root

echo resources/profile >> /etc/profile

# Go
wget https://golang.org/dl/go1.16.3.linux-amd64.tar.gz
rm -rf /usr/local/go && tar -C /usr/local -xzf go1.16.3.linux-amd64.tar.gz
go1.16.3.linux-amd64.tar.gz
export PATH=$PATH:/usr/local/go/bingo
export GOPATH=/usr/local/go/bingo
wget github.com/prasmussen/gdrive

# Google Drive Cli
go get github.com/prasmussen/gdrive
export PATH=$PATH:/usr/local/go/bin
