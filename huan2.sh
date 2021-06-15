#!/usr/bin/env bash
RED_COLOR="\033[0;31m"
NO_COLOR="\033[0m"
GREEN="\033[32m\033[01m"
BLUE="\033[0;36m"
FUCHSIA="\033[0;35m"
echo "export PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin:$PATH" >> ~/.bashrc
source ~/.bashrc
cd bqb-
sed -i '11s/aes-256-ctr/'aes-256-cfb'/' user-config.json
sed -i '12s/auth_aes128_sha1/'auth_aes128_md5'/' user-config.json
./stop.sh
./run.sh
echo "成功"
