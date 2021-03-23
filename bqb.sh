#!/usr/bin/env bash
RED_COLOR="\033[0;31m"
NO_COLOR="\033[0m"
GREEN="\033[32m\033[01m"
BLUE="\033[0;36m"
FUCHSIA="\033[0;35m"
echo "export PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin:$PATH" >> ~/.bashrc
source ~/.bashrc
sleep 3
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
elif [ $PM = 'yum' ]; then
    yum update -y
    yum install vim curl git wget zip unzip python3 python3-pip git -y
fi
pip3 install --upgrade pip
echo -e
cd
echo -e
git clone https://github.com/liujang/bqb-.git
echo -e
cd bqb-
pip3 install -r requirements.txt
sleep 5
cp apiconfig.py userapiconfig.py && cp config.json user-config.json
echo -e
echo -e "
 ${GREEN} 1.web
 ${GREEN} 2.db
 "
 read -p "输入你要的对接方式:" aNum
if [ "$aNum" = "1" ];then
read -p "请输入网站mukey:" key
 echo "网站mukey为：${key}"
 sleep 1
 sed -i '17s/123/'${key}'/' userapiconfig.py
 read -p "请输入节点序号:" node
 echo "节点序号为：${node}"
 sleep 1
 sed -i '2s/0/'${node}'/' userapiconfig.py
  cd
  cd foc- && chmod +x run.sh && ./run.sh
 elif [ "$aNum" = "2" ] ;then
 sed -i '14s/modwebapi/glzjinmod/' userapiconfig.py
 read -p "请输入数据库地址:" ip
 echo "数据库地址为：${ip}"
 sleep 1
 sed -i '23s/127.0.0.1/'${ip}'/' userapiconfig.py
 read -p "请输入数据库用户名:" user
 echo "数据库用户名为：${user}"
 sleep 1
 sed -i '25s/ss/'${user}'/' userapiconfig.py
 read -p "请输入数据库名:" db
 echo "数据库名为：${db}"
 sleep 1
 sed -i '27s/shadowsocks/'${db}'/' userapiconfig.py
 read -p "请输入数据库密码:" passwd
 echo "数据库密码为：${passwd}"
 sleep 1
 sed -i '26s/ss/'${passwd}'/' userapiconfig.py
 read -p "请输入节点序号:" node
 echo "节点序号为：${node}"
 sleep 1
 sed -i '2s/0/'${node}'/' userapiconfig.py
  cd
  cd bqb- && chmod +x run.sh && ./run.sh
  else
            echo "你他妈是猪吗，就两个数字给你选，你都选错，滚！！！"
            fi
echo "已经对接完成！！!。"
echo "本脚本为比奇堡的一键对接脚本，只适用于比奇堡机场"
sleep 1
echo "是否为直连节点上ws加密:
  ${GREEN}1.是(以后要直连的节点)
  ${GREEN}2.否(以后要中转的节点)
  "
  read -p "输入你的选项:" bNum
  if [ "$bNum" = "1" ];then
  cd
  wget https://github.com/Ehco1996/ehco/releases/download/v1.0.3/ehco_1.0.3_linux_amd64 && mv ehco_1.0.3_linux_amd64 ehco && chmod +x ehco
  read -p "请输入节点ip:" nodeip
  nohup ./ehco -l 0.0.0.0:1234 -lt ws -r ${nodeip}:11361 --ur ${nodeip}:11361 >> /dev/null 2>&1 &
  sleep 2
  nohup ./ehco -l 0.0.0.0:12341 -r ws://${nodeip}:1234 -tt ws --web_port 11790 --ur ${nodeip}:1234 >> /dev/null 2>&1 &
  echo "已为节点增加ws加密"
  elif [ "$bNum" = "2" ] ;then
  echo "脚本3秒后停止"
  sleep 3
  exit
