#!/usr/bin/env bash
RED_COLOR="\033[0;31m"
NO_COLOR="\033[0m"
GREEN="\033[32m\033[01m"
BLUE="\033[0;36m"
FUCHSIA="\033[0;35m"
echo "export PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin:$PATH" >> ~/.bashrc
source ~/.bashrc
cd && cd /usr/local/caddy/
ps -ax | grep caddy
kill `caddy-id`
sleep 2
nohup caddy &
send "\03" 
sleep 10
echo -e
cd
