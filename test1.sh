#!/bin/bash

# 字体颜色
blue(){
    echo -e "\033[34m\033[01m$1\033[0m"
}
green(){
    echo -e "\033[32m\033[01m$1\033[0m"
}
red(){
    echo -e "\033[31m\033[01m$1\033[0m"
}

osRelease=""
osSystemPackage=""
osSystemmdPath=""

function setDateZone () {

    if [[ -f /etc/localtime ]] && [[ -f /usr/share/zoneinfo/Asia/Shanghai ]];  then
        mv /etc/localtime /etc/localtime.bak
        cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
    fi

    date -R
}


function installOnMyZsh () {

    if [ "$osRelease" == "centos" ]; then

        echo "Install ZSH and oh-my-zsh"
        sudo $osSystemPackage update && sudo $osSystemPackage install zsh -y

    elif [ "$osRelease" == "ubuntu" ]; then

        echo "Install ZSH and oh-my-zsh"
        $osSystemPackage install zsh -y

    elif [ "$osRelease" == "debian" ]; then

        echo "Install ZSH and oh-my-zsh"
        $osSystemPackage install zsh -y

    fi


    if [[ ! -d "${HOME}/.oh-my-zsh" ]] ;  then
        sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
    fi

    if [[ ! -d "${HOME}/.oh-my-zsh/custom/plugins/zsh-autosuggestions" ]] ;  then
        git clone "https://github.com/zsh-users/zsh-autosuggestions" "${HOME}/.oh-my-zsh/custom/plugins/zsh-autosuggestions"
    fi


    zshConfig=${HOME}/.zshrc
    zshTheme="maran"
    sed -i 's/ZSH_THEME=.*/ZSH_THEME="'${zshTheme}'"/' $zshConfig
    sed -i 's/plugins=(git)/plugins=(git cp history z rsync colorize zsh-autosuggestions)/' $zshConfig

    zshAutosuggestionsConfig=${HOME}/.oh-my-zsh/custom/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
    sed -i "s/ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=8'/ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=1'/" $zshAutosuggestionsConfig

}




function getLinuxOSVersion () {
    # copy from 秋水逸冰 ss scripts
    if [[ -f /etc/redhat-release ]]; then
        osRelease="centos"
        osSystemPackage="yum"
        osSystemmdPath="/usr/lib/systemd/system/"
    elif cat /etc/issue | grep -Eqi "debian"; then
        osRelease="debian"
        osSystemPackage="apt-get"
        osSystemmdPath="/lib/systemd/system/"
    elif cat /etc/issue | grep -Eqi "ubuntu"; then
        osRelease="ubuntu"
        osSystemPackage="apt-get"
        osSystemmdPath="/lib/systemd/system/"
    elif cat /etc/issue | grep -Eqi "centos|red hat|redhat"; then
        osRelease="centos"
        osSystemPackage="yum"
        osSystemmdPath="/usr/lib/systemd/system/"
    elif cat /proc/version | grep -Eqi "debian"; then
        osRelease="debian"
        osSystemPackage="apt-get"
        osSystemmdPath="/lib/systemd/system/"
    elif cat /proc/version | grep -Eqi "ubuntu"; then
        osRelease="ubuntu"
        osSystemPackage="apt-get"
        osSystemmdPath="/lib/systemd/system/"
    elif cat /proc/version | grep -Eqi "centos|red hat|redhat"; then
        osRelease="centos"
        osSystemPackage="yum"
        osSystemmdPath="/usr/lib/systemd/system/"
    fi

    echo "OS info: ${osRelease}, ${osSystemPackage}, ${osSystemmdPath}"

}


osPort80=""
osPort443=""
osSELINUXCheck=""
osSELINUXCheckIsReboot=""

function testPortUsage() {
    $osSystemPackage -y install net-tools socat

    osPort80=`netstat -tlpn | awk -F '[: ]+' '$1=="tcp"{print $5}' | grep -w 80`
    osPort443=`netstat -tlpn | awk -F '[: ]+' '$1=="tcp"{print $5}' | grep -w 443`

    if [ -n "$osPort80" ]; then
        process80=`netstat -tlpn | awk -F '[: ]+' '$5=="80"{print $9}'`
        red "==========================================================="
        red "检测到80端口被占用，占用进程为：${process80}，本次安装结束"
        red "==========================================================="
        exit 1
    fi

    if [ -n "$osPort443" ]; then
        process443=`netstat -tlpn | awk -F '[: ]+' '$5=="443"{print $9}'`
        red "============================================================="
        red "检测到443端口被占用，占用进程为：${process443}，本次安装结束"
        red "============================================================="
        exit 1
    fi

    osSELINUXCheck=$(grep SELINUX= /etc/selinux/config | grep -v "#")
    if [ "$osSELINUXCheck" == "SELINUX=enforcing" ]; then
        red "======================================================================="
        red "检测到SELinux为开启强制模式状态，为防止申请证书失败，请先重启VPS后，再执行本脚本"
        red "======================================================================="
        read -p "是否现在重启 ?请输入 [Y/n] :" osSELINUXCheckIsReboot
        [ -z "${osSELINUXCheckIsReboot}" ] && osSELINUXCheckIsReboot="y"
        if [[ $osSELINUXCheckIsReboot == [Yy] ]]; then
            sed -i 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/selinux/config
                setenforce 0
            echo -e "VPS 重启中..."
            reboot
        fi
        exit
    fi

    if [ "$osSELINUXCheck" == "SELINUX=permissive" ]; then
        red "======================================================================="
        red "检测到SELinux为宽容模式状态，为防止申请证书失败，请先重启VPS后，再执行本脚本"
        red "======================================================================="
        read -p "是否现在重启 ?请输入 [Y/n] :" osSELINUXCheckIsReboot
        [ -z "${osSELINUXCheckIsReboot}" ] && osSELINUXCheckIsReboot="y"
        if [[ $osSELINUXCheckIsReboot == [Yy] ]]; then
            sed -i 's/SELINUX=permissive/SELINUX=disabled/g' /etc/selinux/config
                setenforce 0
            echo -e "VPS 重启中..."
            reboot
        fi
        exit
    fi

    if [ "$osRelease" == "centos" ]; then
        if  [ -n "$(grep ' 6\.' /etc/redhat-release)" ] ;then
        red "==============="
        red "当前系统不受支持"
        red "==============="
        exit
        fi

        if  [ -n "$(grep ' 5\.' /etc/redhat-release)" ] ;then
        red "==============="
        red "当前系统不受支持"
        red "==============="
        exit
        fi

        systemctl stop firewalld
        systemctl disable firewalld
        rpm -Uvh http://nginx.org/packages/centos/7/noarch/RPMS/nginx-release-centos-7-0.el7.ngx.noarch.rpm
        $osSystemPackage update -y
        $osSystemPackage install curl wget xz git unzip -y

    elif [ "$osRelease" == "ubuntu" ]; then
        if  [ -n "$(grep ' 14\.' /etc/os-release)" ] ;then
        red "==============="
        red "当前系统不受支持"
        red "==============="
        exit
        fi
        if  [ -n "$(grep ' 12\.' /etc/os-release)" ] ;then
        red "==============="
        red "当前系统不受支持"
        red "==============="
        exit
        fi

        systemctl stop ufw
        systemctl disable ufw
        $osSystemPackage update -y
        $osSystemPackage install curl wget git unzip xz-utils -y

    elif [ "$osRelease" == "debian" ]; then
        $osSystemPackage update -y
        $osSystemPackage install curl wget git unzip xz-utils -y
    fi

}



function bbr_boost_sh(){
    wget -N --no-check-certificate "https://raw.githubusercontent.com/chiakge/Linux-NetSpeed/master/tcp.sh" && chmod +x tcp.sh && ./tcp.sh
}


function download_trojan(){

    #wget https://github.com/trojan-gfw/trojan/releases/download/v1.15.1/trojan-1.15.1-linux-amd64.tar.xz
    trojanVersion=$(curl --silent "https://api.github.com/repos/trojan-gfw/trojan/releases/latest" | grep -Po '"tag_name": "v\K.*?(?=")')

    green " ===== Trojan Version: ${trojanVersion}"

}

function start_menu(){
    clear
    green " ===================================="
    green " Trojan V2ray 一键安装自动脚本 2020-2-27 更新  "
    green " 系统：centos7+/debian9+/ubuntu16.04+"
    green " 网站：www.v2rayssr.com （已开启禁止国内访问）"
    green " 此脚本为 atrandys 的，波仔集成BBRPLUS加速及MAC客户端 "
    green " Youtube：波仔分享                "
    green " ===================================="
    blue " 声明："
    red " *请不要在任何生产环境使用此脚本"
    red " *请不要有其他程序占用80和443端口"
    red " *若是第二次使用脚本，请先执行卸载trojan"
    green " ======================================="
    echo
    green " 1. 安装trojan"
    red " 2. 卸载trojan"
    green " 3. 修复证书"
    green " 4. 安装BBR-PLUS加速4合一脚本"
    green " 5. 安装 Oh My Zsh , 和 插件zsh-autosuggestions"
    green " 6. 设置时区为北京时间+0800区"
    blue " 0. 退出脚本"
    echo
    read -p "请输入数字:" num
    case "$num" in
    1)
    download_trojan
    ;;
    2)
    testPortUsage
    ;;
    3)
    testPortUsage
    ;;
    4)
    bbr_boost_sh 
    ;;
    5)
    installOnMyZsh
    ;;
    6)
    setDateZone
    ;;
    0)
    exit 1
    ;;
    *)
    clear
    red "请输入正确数字"
    sleep 1s
    start_menu
    ;;
    esac
}


getLinuxOSVersion
start_menu
