#! /bin/bash
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH

###########################################
#        Centos Yum Install LNMP          #
#      Intro: http://www.anenv.com        #
#      Author: Anenv(anenv@live.cn)       #
###########################################

clear
echo ""
echo "###########################################"
echo "#        Centos Yum Install LNMP          #"
echo "#      Intro: http://www.anenv.com        #"
echo "#      Author: Anenv(anenv@live.cn)       #"
echo "###########################################"
echo ""

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

case "$phpversion" in
5)
echo "You will install PHP 5.5.*"
phpversion="5"
;;
6)
echo "You will install PHP 5.6.*"
phpversion="6"
;;
*)
echo "INPUT error,You will install PHP 5.5.*"
phpversion="5"
esac

# remove pack
yum remove -y httpd* php* mysql*

rpm -ivh http://mirrors.ustc.edu.cn/fedora/epel/5/i386/epel-release-5-4.noarch.rpm
rpm -ivh http://rpms.famillecollet.com/enterprise/remi-release-5.rpm

mkdir /home/mysql
mkdir /home/mysql/data
mkdir /home/mysql/log
mkdir /home/wwwlogs
mkdir /home/wwwroot
mkdir /home/wwwroot/default
cat > /home/wwwroot/default/index.html<<-EOF
the is index
EOF
cat > /home/wwwroot/default/info.php<<-EOF
<?php phpinfo();?>
EOF

mv /etc/yum.repos.d/remi.repo  /etc/yum.repos.d/remi.repo.bak

if phpversion 6; then
   wget --no-check-certificate https://raw.githubusercontent.com/Anenv/vlnmp/master/centos5/remi5.6.repo -O /etc/yum.repos.d/remi.repo
else
   wget --no-check-certificate https://raw.githubusercontent.com/Anenv/vlnmp/master/centos5/remi5.5.repo -O /etc/yum.repos.d/remi.repo
fi
yum install -y php php-fpm php-zip php-curl php-bcmath php-ctype php-exif php-sockets php-session php-gd php-mbstring php-mcrypt php-mysql php-json php-ioncube-loader php-xml php-xmlrpc php-xcache xcache-admin php-soap php-opcache php-pdo php-imap

/etc/init.d/php-fpm restart

yum install mysql-server  

mv /etc/my.cnf  /etc/my.cnf.bak
wget --no-check-certificate https://raw.githubusercontent.com/Anenv/vlnmp/master/centos5/my.cnf  -O /etc/my.cnf

/etc/init.d/mysqld restart
mysqladmin -u root password  $mysqlrootpwd


groupadd www
useradd -m -s /sbin/nologin -g www www
		
		
rpm -ivh http://nginx.org/packages/centos/5/noarch/RPMS/nginx-release-centos-5-0.el5.ngx.noarch.rpm

yum install nginx  
/etc/init.d/nginx restart

chkconfig httpd off
chkconfig php-fpm on
chkconfig nginx on
chkconfig mysqld on