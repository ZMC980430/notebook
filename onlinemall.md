# Initialize Project

## Install Mysql on Aliyun

### Install Apache HTTP Server

```shell
yum -y install httpd httpd-manual mod_ssl mod_perl mod_auth_mysql
systemctl start httpd.service
# visit the ip to validate success
```

### Mysql

```shell
wget http://dev.mysql.com/get/mysql57-community-release-el7-10.noarch.rpm
yum -y install mysql57-community-release-el7-10.noarch.rpm
yum -y install mysql-community-server --nogpgcheck

# check version
mysql -V

# start server
systemctl start mysqld.service

# modify password
grep "password" /var/log/mysqld.log
mysql -uroot -p
```

```sql
set global validate_password_policy=0;  #修改密码安全策略为低（只校验密码长度，至少8位）。
ALTER USER 'root'@'localhost' IDENTIFIED BY '12345678';

# visit from any ip
GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' IDENTIFIED BY '12345678';

```

### PHP

```shell
yum -y install php php-mysql gd php-gd gd-devel php-xml php-common php-mbstring php-ldap php-pear php-xmlrpc php-imap

# create test page
echo "<?php phpinfo(); ?>" > /var/www/html/phpinfo.php

# restart apache server
systemctl restart httpd

# visit http://{ip}/phpinfo.php
```

### phpMyAdmin

phpMyAdmin is a mysql manage tool which allows administrator manage mysql via web interface

```shell
mkdir -p /var/www/html/phpmyadmin
wget --no-check-certificate https://labfileapp.oss-cn-hangzhou.aliyuncs.com/phpMyAdmin-4.0.10.20-all-languages.zip

yum install -y unzip
unzip phpMyAdmin-4.0.10.20-all-languages.zip

# move phpMyAdmin file to mysql data folder
mv phpMyAdmin-4.0.10.20-all-languages/*  /var/www/html/phpmyadmin

# visit http://{ip}/phpmyadmin
```

## Tencent Cloud Mysql

os: ubuntu

connection refused: 修改防火墙端口限制，修改 /etc/mysql/mysql.conf.d/mysqld.cnf 中的bind-address=0.0.0.0

host is not allowed : 修改user表中的 host字段，localhost改为%

更新权限后要使用 flush privileges;

## renren-fast-vue

background management, front-back seperate

install node.js

run

```shell
sudo apt-get install npm
# 全局安装n工具
sudo npm install n -g
n 16.16 # 安装指定版本nodejs

#全局安装命令行工具
npm install --location=global @vue/cli
#创建一个项目
vue create vue-test #选择vue2
#进入到项目目录
cd vue-test
#启动程序
npm run serve
```

## relativepath

在pom文件中的 `<parent> `标签加入 `<relativepath/>`可以正确导入部分依赖

## 安装mysql80

```shell
# 查看ubuntu版本，低版本ubuntu的mysql源不是80
cat /proc/version 

sudo apt-get update

sudo apt-get install mysql-server

# 查看服务运行状态
systemctl status mysql

# 重启服务
service mysql restart

```

```sql
# 删除密码（可选）
use mysql;
update user set authentication_string='' where user='root';
# 修改密码 目前这样会存在问题
alter user u@p identified by 'password';

```

```shell
# 成功的方式是先修改密码强度，会报错，然后去数据库中修改root密码
sudo my_secure_installation

sudo mysql
```

```sql
# 将root登录设置为密码登录，新版本默认是auth_socket
alter user 'root'@'localhost' identified with mysql_native_password by 'password';

# 创建用户
create user 'user'@'%' identified with mysql_native_password by 'password';
grant all privileges on *.* to 'user'@'%' with grant option;
```

```shell
# 查看监听端口
sudo ss -ltn
netstat -tlunp | grep 3306

# 使用netcat侦听本地端口
nc -l 8080

# 查看mysql配置文件
/usr/bin/mysql --verbose --help | grep -A 1 'Default options'

# 开放地址
sudo vim /etc/mysql/my.cnf
# 添加
# [mysqld]
# 
# bind-address=0.0.0.0

```

## SSH端口转发

[端口转发](https://zhuanlan.zhihu.com/p/148825449)

```shell
# 三种使用场景 ssh连接A->B
# A 可以访问公网但无公网ip，想让B访问A
ssh -R portA:localhost:portB user@ipB

# B与C处于同一内网中，A可连接B，要让A访问C，当C和B相同就相当于B自身端口映射
ssh -L portB:ipC:portC user@ipB

# 
```

## 跨域

协议，ip，端口号与前端页面本身不一致，会限制访问

解决方法：

在Controller类前添加注释 @CrossOrigin

# 一些Linux命令

| 功能     | 命令 | 备注 |
| -------- | ---- | ---- |
| 查看架构 | arch |      |
|          |      |      |
