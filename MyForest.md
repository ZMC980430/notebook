# MyForest 项目

## 安装MySQL数据库(win)

终端中登录数据库 (password: 123456)

```powershell
mysql -h localhost -u root -p
```

启动和停止 `mysql` 服务

```powershell
net start MySQL80
net stop MySQL80
```

## 安装MySQL数据库(Linux)

* 从官网下载安装包 tar.xz
* 解压 tar -xvf ... 并移动到/opt/mysql/
* 建立data文件夹
* 创建mysql用户和用户组

  ```shell
  groupadd mysql
  useradd -g mysql mysql
  # 修改访问权限
  chown -R mysql.mysql /opt/mysql/
  ```
* 数据库初始化，记录初始密码，可能在命令行中，可能在/data/mysql.err文件中

  ```shell
  ./bin/mysqld --user=mysql --basedir=/opt/mysql --datadir=/opt/mysql/data --initialize
  ```
* 修改my.cnf

  ```properties
  [mysqld]
      basedir = /usr/local/mysql
      datadir = /usr/local/mysql/data
      socket = /usr/local/mysql/mysql.sock
      character-set-server=utf8
      port = 3306
     sql_mode=NO_ENGINE_SUBSTITUTION,STRICT_TRANS_TABLES
   [client]
     socket = /usr/local/mysql/mysql.sock
     default-character-set=utf8
  ```
* 创建mysql服务

  ```shell
  # 复制mysql服务并重命名为mysqld 
  cp -a /usr/local/mysql/support-files/mysql.server /etc/init.d/mysqld
  chmod +x /etc/init.d/mysqld
  chkconfig --add mysqld
  # chkconfig 可能没有，可以安装sysv-rc-conf
  # 找不到包可以在/etc/apt/sources.list 后面添加
  # deb http://archive.ubuntu.com/ubuntu/ trusty main universe restricted multiverse

  # 查看mysql服务是否添加上
  chkconfig --list mysql
  # 或者
  sysv-rc-conf --list mysql

  ```
* 配置环境变量，编辑/etc/profile，添加以下

  ```properties
  export PATH=$PATH:/usr/local/mysql/bin:/usr/local/mysql/lib
  export PATH
  ```
* 启动mysql服务：service mysql start
* 在本地访问可能没有安装客户端，可直接使用 apt install mysql-client-core-8.0
* 修改登录密码，使用初始密码登陆，再修改密码

  ```sql
  ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY '123456';
  ```
* 设置远程登录

  ```sql
  use mysql;
  update user set host='%' where user='root' limit 1;
  flush privileges;
  ```
* 测试端口能否使用

  ```shell
  telnet [ip] [port]
  ```
* 关闭防火墙

  ```shell
  # 查看端口
  firewall-cmd --list-ports
  # 设置端口可在外部访问
  firewall-cmd --zone=public --add-port=3306/tcp --permanent
  ```

[参考](https://www.cnblogs.com/MrYoodb/p/15811199.html)

## 生成ssh密钥

在客户端生成密钥
```shell
# 指定算法
ssh-keygen [-t dsa]
```
上传密钥到服务器端 ~/.authorized_keys
或使用 ssh-copy-id -i id_rsa user@host 直接上传

## springboot demo项目

创建Maven项目，修改pom.xml，添加依赖

```xml
<?xml version="1.0" encoding="UTF-8"?>
<project xmlns="http://maven.apache.org/POM/4.0.0"
         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/xsd/maven-4.0.0.xsd">
    <modelVersion>4.0.0</modelVersion>

    <groupId>org.example</groupId>
    <artifactId>SpringBootDemo</artifactId>
    <version>1.0-SNAPSHOT</version>

    <!--继承的父工程-->
    <parent>
        <artifactId>spring-boot-starter-parent</artifactId>
        <groupId>org.springframework.boot</groupId>
        <version>2.7.2</version>
    </parent>

    <dependencies>
        <!-- web 开发的起步依赖-->
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-web</artifactId>
            <version>2.7.2</version>
        </dependency>
    </dependencies>

    <properties>
        <maven.compiler.source>17</maven.compiler.source>
        <maven.compiler.target>17</maven.compiler.target>
    </properties>

</project>
```

 springboot 项目继承自spring-boot-starter-parent，所用到的jar包版本均在父工程中定义，可直接继承。

### SpringBoot 配置

application.properties 和 application.yml，位于 resources 文件夹

properties:

```properties
server.port=8080
names:
  - Alan
  - Bob

person:
  name: ${names}[0]
  age: 10
```

yml:

```yaml
server:
  port: 8080
```

properties 文件的优先级更高，因为 properties 文件是最后加载，会覆盖其他文件配置。properties > yml > yaml

### 配置文件参数注入

```java
@RestController
Class Demo {
    // 注入单个属性
    @Value("${names[0]}")
    private String name;

    // 注入环境(整个配置文件)
    @AutoWired
    private Environment env
}
```

```java
@Component \\bean
@ConfigurationProperties(prefix="person")
Class Person {
	private String name; \\ Alan
	private int age;     \\ 10
}
```

### profile

#### profile 配置

多文件形式：

配置多个application-dev.properties, application-test.properties，在主 application.properties 中配置 spring.profiles.active=dev

单文件形式：application.yml

```yaml
---
server:
  port: 8080
spring:
  profiles: dev
---
server:
  port: 8081
spring:
  profiles: test
---
spring:
  profiles:
    active: dev
```

#### profile 激活

VM 配置：-Dspring.profiles.active=test

命令行配置：--spring.profiles.active=test

### 配置加载

SpringBoot 程序配置加载顺序：

- file: ./config/ 项目路径下config
- file: ./ 项目根目录
- classpath:/config
- classpath:/

优先级依次递减
