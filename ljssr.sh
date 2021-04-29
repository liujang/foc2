#!/usr/bin/env bash
RED_COLOR="\033[0;31m"
NO_COLOR="\033[0m"
GREEN="\033[32m\033[01m"
BLUE="\033[0;36m"
FUCHSIA="\033[0;35m"
echo "export PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin:$PATH" >> ~/.bashrc
source ~/.bashrc
if [[ "$EUID" -ne 0 ]]; then
    echo "false"
  else
    echo "true"
  fi
if [[ -f /etc/redhat-release ]]; then
		release="centos"
	elif cat /etc/issue | grep -q -E -i "debian"; then
		release="debian"
	elif cat /etc/issue | grep -q -E -i "ubuntu"; then
		release="ubuntu"
	elif cat /etc/issue | grep -q -E -i "centos|red hat|redhat"; then
		release="centos"
	elif cat /proc/version | grep -q -E -i "debian"; then
		release="debian"
	elif cat /proc/version | grep -q -E -i "ubuntu"; then
		release="ubuntu"
	elif cat /proc/version | grep -q -E -i "centos|red hat|redhat"; then
		release="centos"
    fi
    
     if [[ $release = "ubuntu" || $release = "debian" ]]; then
    PM='apt'
  elif [[ $release = "centos" ]]; then
    PM='yum'
  else
    exit 1
  fi
  # PM='apt'
  if [ $PM = 'apt' ] ; then
    apt-get update -y
    apt-get install vim curl git wget zip unzip python3 python3-pip git -y
    rm -rf /usr/bin/python
    ln -s /usr/bin/python3  /usr/bin/python
    apt install net-tools -y
    apt install debian-keyring debian-archive-keyring apt-transport-https -y
    curl -1sLf 'https://dl.cloudsmith.io/public/caddy/stable/gpg.key' | apt-key add -
    curl -1sLf 'https://dl.cloudsmith.io/public/caddy/stable/debian.deb.txt' | tee -a /etc/apt/sources.list.d/caddy-stable.list
    apt-get update -y
    apt install caddy -y
elif [ $PM = 'yum' ]; then 
    yum update -y
    systemctl stop initial-setup-text
    yum install net-tools -y
    yum install vim curl git wget zip unzip python3 python3-pip git -y
    rm -rf /usr/bin/python
    ln -s /usr/bin/python3  /usr/bin/python
    yum install yum-plugin-copr -y
    yum copr enable @caddy/caddy -y
    yum install caddy -y 
fi
cd
mkdir /var/www && cd /var/www/
wget -N --no-check-certificate "https://raw.githubusercontent.com/liujang/foc2/main/index.html" && chmod +x index.html
cd
read -p "输入域名:" nodeym
read -p "输入ssr端口:" ssrport
echo "https://${nodeym}:15973 {
    root * /var/www
    file_server
    tls 2895174879@qq.com
}
${nodeym}:80 {
    redir https://${nodeym}:${ssrport}{uri}
}
${nodeym}:443 {
    redir https://${nodeym}:${ssrport}{uri}
}" > /etc/caddy/Caddyfile
cd && cd /etc/caddy/
caddy stop
sleep 2
caddy start
sleep 10
echo -e
cd
wget --no-check-certificate -O shadowsocks-all.sh https://raw.githubusercontent.com/teddysun/shadowsocks_install/master/shadowsocks-all.sh
chmod +x shadowsocks-all.sh
./shadowsocks-all.sh 2>&1 | tee shadowsocks-all.log
cd /etc/shadowsocks-r
echo "{
    "server":"0.0.0.0",
    "server_ipv6":"::",
    "server_port":{ssrport},
    "local_address":"127.0.0.1",
    "local_port":1080,
    "password":"ljfxz",
    "timeout":120,
    "method":"none",
    "protocol":"auth_aes128_sha1",
    "protocol_param":"",
    "obfs":"plain",
    "obfs_param":"",
    "redirect":["*:{ssrport}#127.0.0.1:15973"],
    "dns_ipv6":false,
    "fast_open":false,
    "workers":1
}" > /etc/shadowsocks-r/config.json
/etc/init.d/shadowsocks-r restart
