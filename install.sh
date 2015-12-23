#!/bin/bash

yum remove -y httpd* php* mysql*

wget http://download.Fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm 
rpm -ivh epel-release-6-8.noarch.rpm 

rpm -ivh http://mirrors.ustc.edu.cn/fedora/epel/5/i386/epel-release-5-4.noarch.rpm
rpm -ivh http://mirrors.ustc.edu.cn/fedora/epel/5/x86_64/epel-release-5-4.noarch.rpm

rpm -ivh http://mirrors.ustc.edu.cn/fedora/epel/6/i386/epel-release-6-8.noarch.rpm

rpm -ivh http://rpms.famillecollet.com/enterprise/remi-release-5.rpm
rpm -ivh http://rpms.famillecollet.com/enterprise/remi-release-6.rpm

yum install -y php php-fpm php-zip php-curl php-bcmath php-ctype php-exif php-sockets php-session php-gd php-mbstring php-mcrypt php-mysql php-json php-ioncube-loader php-xml php-xmlrpc php-xcache xcache-admin php-soap php-opcache php-pdo php-imap

/etc/init.d/php-fpm restart

yum install mysql-server  
/etc/init.d/mysqld restart
mysqladmin -u root password 123456


groupadd www
useradd -m -s /sbin/nologin -g www www
		
		
rpm -ivh http://nginx.org/packages/centos/5/noarch/RPMS/nginx-release-centos-5-0.el5.ngx.noarch.rpm
rpm -ivh http://nginx.org/packages/centos/6/noarch/RPMS/nginx-release-centos-6-0.el6.ngx.noarch.rpm

yum install nginx  
/etc/init.d/nginx restart

chkconfig httpd off
chkconfig php-fpm on
chkconfig nginx on
chkconfig mysqld on



postfix mysql-server mysql perl-DBD-MySQL php-common php-gd php-xml php-mysql php-ldap php-pgsql php-imap php-mbstring php-pecl-apc php-intl php-mcrypt nginx php-fpm cluebringer dovecot dovecot-pigeonhole dovecot-managesieve amavisd-new clamd clamav-db spamassassin altermime perl-LDAP perl-Mail-SPF unrar php-pear-Net-IDNA2 python-sqlalchemy python-setuptools MySQL-python python-jinja2 python-webpy python-netifaces python-beautifulsoup4 python-lxml uwsgi uwsgi-plugin-python fail2ban unzip bzip2 acl patch tmpwatch crontabs dos2unix logwatch



aimiv P4NzCf4xbCGE4N5
cuxiaow DJDf3wtChsM8v6R
midc 35KXRbnSNYXuhj7B
plcinfo SNNJs6LaHVAaCdN
