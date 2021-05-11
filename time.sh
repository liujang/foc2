#!/usr/bin/env bash
RED_COLOR="\033[0;31m"
NO_COLOR="\033[0m"
GREEN="\033[32m\033[01m"
BLUE="\033[0;36m"
FUCHSIA="\033[0;35m"
echo "export PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin:$PATH" >> ~/.bashrc
source ~/.bashrc
cd
read -p "多少小时重启一次后端:" ssrtime
wget -N --no-check-certificate "https://raw.githubusercontent.com/liujang/foc2/main/cqtest.sh" && chmod +x cqtest.sh
crontab -l > conf
echo "0 */${ssrtime} * * * ./cq.sh" >> conf
crontab conf
rm -f conf
echo "已设置每${ssrtime}小时重启一次后端"
