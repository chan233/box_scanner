#!/bin/bash
# htb 基本信息收集
# 输入一个ip 地址
# 检查输入到是不是ip地址,如果不是就退出

# curl --head | grep location
# 如果没有域名 把域名存到 /etc/hosts
# 如果有域名 ...

# 进行 全端口扫描
# 枚举每个端口的banner

 
function check_ip(){
        IP=$1
        VALID_CHECK=$(echo $IP|awk -F. '$1<=255 && $2<=255 && $3<=255 && $4<=255 {print "yes"}')
        echo $VALID_CHECK
        if echo $IP|grep -E "^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$">/dev/null; then
                if [[ $VALID_CHECK == "yes" ]]; then
                        echo "$IP available."
                else
                        echo "$IP not available!"
                fi
        else
                echo "$IP Address Format error!"
                exit
        fi
}


if [[ $# -lt 1 ]]
then
    echo '[-] please input an address'
    echo '[-] be like bash box_scanner.sh 10.10.10.xxx'
    exit
fi

ADDRESS=$1
FULLSCAN=$2
check_ip $ADDRESS

echo "[+]scaning for $ADDRESS"
echo '[+] staring curl...'

DOMAIN=$(curl $ADDRESS --head | grep 'Location' | cut -d " " -f 2) 

echo "[+] get domain: $DOMAIN"
# do you want export domain to /etc/host?

if [[ $FULLSCAN == 'f' ]]
then
    echo "[+] start full tcp port scan"
    PORT=65535
else
    echo "[+] start 1000 tcp port scan"
    PORT=1000
fi

for ((i=1 ; i <= $PORT; i++))
do
    nc -nvv -w 1 -z $ADDRESS $i 2>&1 | grep 'succeeded'
done
