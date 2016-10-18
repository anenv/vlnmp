# vlnmp
centos通过yum一键安装lnmp脚本

## Centos5

wget --no-check-certificate https://raw.githubusercontent.com/Anenv/vlnmp/master/centos5.sh -O lnmp.sh
chmod +x lnmp.sh
sh lnmp.sh


## Centos6

wget --no-check-certificate https://raw.githubusercontent.com/Anenv/vlnmp/master/centos6.sh -O lnmp.sh
chmod +x lnmp.sh
sh lnmp.sh

## 说明及文件位置

自动安装最新版本PHP+MySql+Nginx，可选安装PHP 5.5.* 或者PHP 5.6.*

网站目录为 /home/wwwroot/

日志目录为 /home/wwwlogs/

MySql数据目录为 /home/mysql/data/

PHP的php.ini文件位置 /etc/php.ini

MySql的my.cnf位置 /etc/my.cnf

Nginx目录 /etc/nginx

Nginx网站配置目录 /etc/nginx/conf
