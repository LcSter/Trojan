# Trojan V2ray 一键安装脚本

====================================

系统：centos7+/debian9+/ubuntu16.04+

网站：www.v2rayssr.com （已开启禁止国内访问）

脚本东拼西凑 需要感谢 秋水逸冰、Atrandys、V2ray官方等

Youtube：波仔分享

默认会创建10个用户账号, trojan还能创建指定的密码, 方便用户使用.

====================================

脚本安装命令

```bash
curl -O https://raw.githubusercontent.com/jinwyp/Trojan/master/trojan_v2ray_install.sh && chmod +x trojan_v2ray_install.sh && ./trojan_v2ray_install.sh

```

或

```bash
wget --no-check-certificate https://raw.githubusercontent.com/jinwyp/Trojan/master/trojan_v2ray_install.sh && chmod +x trojan_v2ray_install.sh && ./trojan_v2ray_install.sh

```




![功能说明](https://github.com/jinwyp/Trojan/blob/master/docs/readme.jpg?raw=true)


## 使用说明 Usage 

####


1. 该步骤可省略. 如果是使用google cloud 谷歌云服务器，默认无法使用root账号登陆， 可以选择16 开启root用户登录. 建议使用root用户运行该脚本.
2. 安装 BBR plus. 运行脚本 ```./trojan_v2ray_install.sh ``` 选择1 然后选择2 安装 BBRplus版内核, 注意安装过程中会弹出大框的英文提示(下面有示例图)"安装linux内核有风险是否终止", 要选择" NO" 不终止. 安装完毕会重启VPS
3. 使用BBRplus版加速. 重新登录VPS后, 重新运行脚本 ```./trojan_v2ray_install.sh ```  选择1 然后 选择7 使用BBRplus版加速. 
4. 该步骤可省略. 选择15, 安装 oh-my-zsh. 这样以后登录有命令提示, 方便新手操作. 安装完成后请退出VPS, 命令为```exit```.  重新登录VPS后继续下面操作. 
5. 安装 trojan 或 v2ray. 根据提示 重新运行脚本 ```./trojan_v2ray_install.sh ```  选2 安装trojan, 或选5 安装trojan-go, 或选11 安装v2ray, 或选13 同时安装trojan和v2ray.


6. 第一步安装 BBR plus 时出现的提示 "是否终止删除内核" 请选择 "NO". 就是要卸载掉目前的内核. 
![注意 安装BBR plus](https://github.com/jinwyp/Trojan/blob/master/docs/debian.jpg?raw=true)
![注意 安装BBR plus](https://github.com/jinwyp/Trojan/blob/master/docs/kernel.png?raw=true)
![注意 安装BBR plus](https://github.com/jinwyp/Trojan/blob/master/docs/ubuntu.png?raw=true)


## 注意事项与常见问题 FAQ 

1. 免费域名可以使用 [freenom](https://www.freenom.com/zh/index.html?lang=zh). 注册freenom时需要使用美国IP,否则无法通过注册邮件验证. 请自行搜索教程.
2. 使用脚本安装时请先关闭CDN, cloudflare.com 中DNS设置页面, 二级域名设置为DNS only 为关闭CDN. 安装v2ray完毕后 可以开启CDN 设置为Proxied 即可. trojan目前不支持CDN, trojan-go 默认不支持CDN,可以手动修改配置支持CDN.
![注意 cloudflare CDN](https://github.com/jinwyp/Trojan/blob/master/docs/cloudflare1.jpg?raw=true)

