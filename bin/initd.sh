#!/bin/bash
#######################################################
# $Name:         initid.sh
# $Version:      v1.0
# $Function:     Nginx start script
# $Author:       Tan <tandamailzone@gmail.com>
# $organization: https://github.com/one-villager
# $Create Date:  2018-05-31
# $Description:  Nginx start script
#######################################################
BASE_PATH=$(cd "$(dirname "$0")"; cd ..; pwd)
# update 1
NGINX_SBIN_PATH="/usr/local/openresty/nginx/sbin/nginx"
# update 1
NGINX_CONFIG_PATH=${BASE_PATH}"/conf/nginx.conf"
PID=$(ps -aef | grep nginx | grep -v grep | grep master  | grep ${BASE_PATH} |awk '{print $2}')
shell_usage(){
    echo $"Usage: $0 start|stop"
}

test_nginx(){
    echo -e "\033[35m [ Nginx testing ] \033[0m"
    sudo $NGINX_SBIN_PATH  -t -c $NGINX_CONFIG_PATH
}

start_nginx(){
    if [[ $? == 0 && -n $PID ]]
    then
        echo -e "\033[35m [ Nginx running ] \033[0m"
        sudo $NGINX_SBIN_PATH  -t -c $NGINX_CONFIG_PATH
        sudo kill -HUP $PID
        echo -e "\033[33m [ Nginx has reload ] \033[0m"
    else
        echo -e "\033[31m [ Stop OK ] \033[0m"
        sudo $NGINX_SBIN_PATH  -t -c $NGINX_CONFIG_PATH
        sudo $NGINX_SBIN_PATH  -c $NGINX_CONFIG_PATH
        echo -e "\033[32m [ Start OK ] \033[0m"
    fi
}

stop_nginx(){
    sudo kill -QUIT ${PID}
    if [[ $? == 0 &&  -n $PID ]]
    then
        echo -e "\033[33m [ Stop Success ] \033[0m"
    else
        echo -e "\033[31m [ Stop Fail ] \033[0m"
    fi
    exit 1
}

# Main Function
main(){
    case $1 in
        start) start_nginx
        ;;
        stop) stop_nginx
        ;;
        test) test_nginx
        ;;
        *) shell_usage
        ;;
    esac
}

main $1
