# Trojan V2ray 一键安装脚本

====================================

系统：centos7+/debian9+/ubuntu16.04+

网站：www.v2rayssr.com （已开启禁止国内访问）

脚本东拼西凑 需要感谢 秋水逸冰、Atrandys、V2ray官方等

Youtube：波仔分享

====================================

脚本安装命令

```bash
curl -O https://raw.githubusercontent.com/jinwyp/Trojan/master/trojan_v2ray_install.sh && chmod +x trojan_v2ray_install.sh && ./trojan_v2ray_install.sh

```

或

```bash
wget --no-check-certificate https://raw.githubusercontent.com/jinwyp/Trojan/master/trojan_v2ray_install.sh && chmod +x trojan_v2ray_install.sh && ./trojan_v2ray_install.sh

```




![功能说明](https://github.com/jinwyp/Trojan/blob/master/readme.png?raw=true)


## 使用说明 Usage 

####

1. 选择9 先安装 oh-my-zsh 这样以后登录有命令提示,方便新手操作. 安装完成后请退出VPS重新登录. 该步骤可省略.
2. 安装 BBR plus. 重新运行脚本 ```./trojan_v2ray_install.sh ``` 选择1 然后 选择 2 安装 BBRplus版内核 , 注意安装过程中会弹出大框的英文提示"安装linux内核有风险是否终止, 要选择 NO 不终止. 安装完毕会重启VPS
3. 使用BBRplus版加速. 重新登录VPS后 重新运行脚本 ```./trojan_v2ray_install.sh ```  选择1 然后 选择 7 使用BBRplus版加速. 
4. 安装 trojan 或 v2ray. 根据提示 重新运行脚本 ```./trojan_v2ray_install.sh ```  选2 安装trojan, 或选5 安装v2ray, 或选7同时安装trojan和v2ray.



