# MyForest 项目

## 安装MySQL数据库

终端中登录数据库 (password: 123456)

```powershell
mysql -h localhost -u root -p
```

启动和停止 `mysql` 服务

```powershell
net start MySQL80
net stop MySQL80
```

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
