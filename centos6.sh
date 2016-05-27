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

case "${phpversion}" in
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

rpm -ivh https://raw.githubusercontent.com/Anenv/vlnmp/master/centos6/epel-release-6-8.noarch.rpm
rpm -ivh https://raw.githubusercontent.com/Anenv/vlnmp/master/centos6/remi-release-6.rpm

mkdir /home/mysql
mkdir /home/mysql/data
mkdir /home/mysql/log
mkdir /home/wwwlogs
mkdir /home/wwwroot
mkdir /home/wwwroot/default
cat > /home/wwwroot/default/index.html<<-EOF
The is index page! <a href='info.php'>phpinfo</a>
EOF
cat > /home/wwwroot/default/info.php<<-EOF
<?php phpinfo();?>
EOF

mv /etc/yum.repos.d/remi.repo  /etc/yum.repos.d/remi.repo.bak

if [ "${phpversion}" == "6" ]; then
   wget --no-check-certificate https://raw.githubusercontent.com/Anenv/vlnmp/master/centos6/remi5.6.repo -O /etc/yum.repos.d/remi.repo
else
   wget --no-check-certificate https://raw.githubusercontent.com/Anenv/vlnmp/master/centos6/remi5.5.repo -O /etc/yum.repos.d/remi.repo
fi

yum install -y php php-fpm php-zip php-curl php-bcmath php-ctype php-exif php-sockets php-session php-gd php-mbstring php-mcrypt php-mysql php-json php-ioncube-loader php-xml php-xmlrpc php-xcache xcache-admin php-soap php-opcache php-pdo php-imap

/etc/init.d/php-fpm restart

yum install -y mysql-server  

mv /etc/my.cnf  /etc/my.cnf.bak
wget --no-check-certificate https://raw.githubusercontent.com/Anenv/vlnmp/master/centos6/my.cnf  -O /etc/my.cnf

/etc/init.d/mysqld restart
mysqladmin -u root password $mysqlrootpwd

groupadd www
useradd -m -s /sbin/nologin -g www www
rm -rf /home/www

rpm -ivh http://nginx.org/packages/centos/6/noarch/RPMS/nginx-release-centos-6-0.el6.ngx.noarch.rpm

yum install -y nginx  

mv /etc/nginx/nginx.conf  /etc/nginx/nginx.conf.bak
wget --no-check-certificate https://raw.githubusercontent.com/Anenv/vlnmp/master/conf/nginx.conf  -O /etc/nginx/nginx.conf
mv /etc/nginx/conf.d/default.conf /etc/nginx/conf.d/default.conf.bak
wget --no-check-certificate https://raw.githubusercontent.com/Anenv/vlnmp/master/conf/default.conf  -O /etc/nginx/default.conf

mv /etc/php-fpm.d/www.conf  /etc/php-fpm.d/www.conf.bak
wget --no-check-certificate https://raw.githubusercontent.com/Anenv/vlnmp/master/conf/www.conf  -O /etc/php-fpm.d/www.conf

chown -R www.www /home/wwwroot
/etc/init.d/nginx restart

chkconfig httpd off
chkconfig php-fpm on
chkconfig nginx on
chkconfig mysqld on