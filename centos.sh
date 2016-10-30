#! /bin/bash
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin

###########################################
#        Centos Yum Install LNMP          #
#      Intro: http://www.anenv.com        #
#      Author: Anenv(anenv@live.cn)       #
###########################################

echo ""
echo "###########################################"
echo "#        Centos Yum Install LNMP          #"
echo "#      Intro: http://www.anenv.com        #"
echo "#      Author: Anenv(anenv@live.cn)       #"
echo "###########################################"
echo ""

if [[ `getconf WORD_BIT` = '32' && `getconf LONG_BIT` = '64' ]] ; then
    Os_Bit='64'
else
    Os_Bit='32'
fi
	
if grep -Eqi "release 5." /etc/redhat-release; then
    RHEL_Ver='5'
elif grep -Eqi "release 6." /etc/redhat-release; then
    RHEL_Ver='6'
elif grep -Eqi "release 7." /etc/redhat-release; then
    RHEL_Ver='7'
fi

echo "The is Centos${RHEL_Ver} ${Os_Bit}bit, Begin install..."



mysqlrootpwd="root"
echo "Please input the root password of mysql:"
read -p "(Default password: root):" mysqlrootpwd
if [ "$mysqlrootpwd" = "" ]; then
	mysqlrootpwd="root"
fi
echo "==========================="
echo "MySQL root password:$mysqlrootpwd"
echo "==========================="

phpversion="n"
echo "Install PHP 5.5.*,Please input 5"
echo "Install PHP 5.6.*,Please input 6"
read -p "(Please input 5 or 6):" phpversion

case "${phpversion}" in
5)
echo "You will install PHP 5.5.*"
phpversion="5";;
6)
echo "You will install PHP 5.6.*"
phpversion="6";;
*)
echo "INPUT error,You will install PHP 5.5.*"
phpversion="5"
esac


#Disable SeLinux
if [ -s /etc/selinux/config ]; then
    sed -i 's/^SELINUX=.*/SELINUX=disabled/g' /etc/selinux/config
fi

#Set_Timezone
echo "Setting timezone..."
rm -rf /etc/localtime
ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime

#CentOS_InstallNTP()
echo "[+] Installing ntp..."
yum install -y ntp
ntpdate -u pool.ntp.org
date

# remove pack
yum remove -y httpd* php* mysql*

groupadd www
useradd -m -s /sbin/nologin -g www www
rm -rf /home/www

mkdir /home/mysql
mkdir /home/mysql/data
mkdir /home/mysql/log
mkdir /home/wwwlogs
mkdir /home/wwwroot
mkdir /home/wwwroot/default
wget --no-check-certificate https://raw.githubusercontent.com/Anenv/vlnmp/master/conf/index.html  -O /home/wwwroot/default/index.html
wget --no-check-certificate https://raw.githubusercontent.com/Anenv/vlnmp/master/conf/phpinfo.php  -O /home/wwwroot/default/phpinfo.php 
wget --no-check-certificate https://raw.githubusercontent.com/Anenv/vlnmp/master/conf/tz.php  -O /home/wwwroot/default/tz.php

rpm -ivh https://raw.githubusercontent.com/Anenv/vlnmp/master/centos${RHEL_Ver}/epel-release-${RHEL_Ver}.rpm
rpm -ivh https://raw.githubusercontent.com/Anenv/vlnmp/master/centos${RHEL_Ver}/remi-release-${RHEL_Ver}.rpm

mv /etc/yum.repos.d/remi.repo  /etc/yum.repos.d/remi.repo.bak

if [ "${phpversion}" == "6" ]; then
   wget --no-check-certificate https://raw.githubusercontent.com/Anenv/vlnmp/master/centos${RHEL_Ver}/remi5.6.repo -O /etc/yum.repos.d/remi.repo
else
   wget --no-check-certificate https://raw.githubusercontent.com/Anenv/vlnmp/master/centos${RHEL_Ver}/remi5.5.repo -O /etc/yum.repos.d/remi.repo
fi

yum install -y php php-fpm php-zip php-curl php-bcmath php-ctype php-exif php-sockets php-session php-gd php-mbstring php-mcrypt php-mysql php-json php-ioncube-loader php-xml php-xmlrpc php-xcache xcache-admin php-soap php-opcache php-pdo php-imap

mv /etc/php.ini  /etc/php.ini.bak
wget --no-check-certificate https://raw.githubusercontent.com/Anenv/vlnmp/master/conf/php.ini  -O /etc/php.ini

mv /etc/php-fpm.d/www.conf  /etc/php-fpm.d/www.conf.bak
wget --no-check-certificate https://raw.githubusercontent.com/Anenv/vlnmp/master/conf/www.conf  -O /etc/php-fpm.d/www.conf

/etc/init.d/php-fpm restart

yum install -y mysql-server  

mv /etc/my.cnf  /etc/my.cnf.bak
wget --no-check-certificate https://raw.githubusercontent.com/Anenv/vlnmp/master/centos${RHEL_Ver}/my.cnf  -O /etc/my.cnf

/etc/init.d/mysqld restart
mysqladmin -u root password $mysqlrootpwd

rpm -ivh http://nginx.org/packages/centos/6/noarch/RPMS/nginx-release-centos-${RHEL_Ver}-0.el${RHEL_Ver}.ngx.noarch.rpm

yum install -y nginx  

mv /etc/nginx/nginx.conf  /etc/nginx/nginx.conf.bak
wget --no-check-certificate https://raw.githubusercontent.com/Anenv/vlnmp/master/conf/nginx.conf  -O /etc/nginx/nginx.conf
mv /etc/nginx/conf.d/default.conf /etc/nginx/conf.d/default.conf.bak
wget --no-check-certificate https://raw.githubusercontent.com/Anenv/vlnmp/master/conf/default.conf  -O /etc/nginx/default.conf

chown -R www.www /home/wwwroot
/etc/init.d/nginx restart



chkconfig httpd off
chkconfig php-fpm on
chkconfig nginx on
chkconfig mysqld on
