# MySQL 基础

## 相关概念

- 数据库：DB
- 数据库管理系统：DBMS
- 操作数据库的语言：SQL (Structured Query Language)

常见DBMS：

- Oracle
- MySQL
- MS SQL Server

关系型数据库（RDBMS）：关系模型，由多张二维表组成

## SQL

| 分类 | 全称                       |
| ---- | -------------------------- |
| DDL  | Data Definition Language   |
| DML  | Data Manipulation Language |
| DQL  | Data Query Language        |
| DCL  | Data Control Language      |

### DDL

创建数据库 create database if not exists {database_name} default charset utf8mb4;

#### 数值类型

| 类型         | 大小                                           | 范围（有符号）                                                                                                                                  | 范围（无符号）                                                          | 用途                 |
| ------------ | ---------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------- | ----------------------------------------------------------------------- | -------------------- |
| TINYINT      | 1 Bytes                                        | (-128，127)                                                                                                                                     | (0，255)                                                                | 小整数值             |
| SMALLINT     | 2 Bytes                                        | (-32 768，32 767)                                                                                                                               | (0，65 535)                                                             | 大整数值             |
| MEDIUMINT    | 3 Bytes                                        | (-8 388 608，8 388 607)                                                                                                                         | (0，16 777 215)                                                         | 大整数值             |
| INT或INTEGER | 4 Bytes                                        | (-2 147 483 648，2 147 483 647)                                                                                                                 | (0，4 294 967 295)                                                      | 大整数值             |
| BIGINT       | 8 Bytes                                        | (-9,223,372,036,854,775,808，9 223 372 036 854 775 807)                                                                                         | (0，18 446 744 073 709 551 615)                                         | 极大整数值           |
| FLOAT        | 4 Bytes                                        | (-3.402 823 466 E+38，-1.175 494 351 E-38)，0，<br />(1.175 494 351 E-38，3.402 823 466 351 E+38)                                               | 0，(1.175 494 351 E-38，<br />3.402 823 466 E+38)                       | 单精度<br />浮点数值 |
| DOUBLE       | 8 Bytes                                        | (-1.797 693 134 862 315 7 E+308，-2.225 073 858 507 201 4 E-308)，<br />0，<br />(2.225 073 858 507 201 4 E-308，1.797 693 134 862 315 7 E+308) | 0，(2.225 073 858 507 201 4 E-308，<br />1.797 693 134 862 315 7 E+308) | 双精度<br />浮点数值 |
| DECIMAL      | 对DECIMAL(M,D) ，<br />如果M>D，为M+2否则为D+2 | 依赖于M和D的值                                                                                                                                  | 依赖于M和D的值                                                          | 小数值               |

#### 时间类型

| 类型      | 大小 ( bytes) | 范围                                                                                                                                                                                     | 格式                | 用途                           |
| --------- | ------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------- | ------------------------------ |
| DATE      | 3             | 1000-01-01/9999-12-31                                                                                                                                                                    | YYYY-MM-DD          | 日期值                         |
| TIME      | 3             | '-838:59:59'/'838:59:59'                                                                                                                                                                 | HH:MM:SS            | 时间值或持续时间               |
| YEAR      | 1             | 1901/2155                                                                                                                                                                                | YYYY                | 年份值                         |
| DATETIME  | 8             | '1000-01-01 00:00:00' 到 '9999-12-31 23:59:59'                                                                                                                                           | YYYY-MM-DD hh:mm:ss | 混合日期和时间值               |
| TIMESTAMP | 4             | '1970-01-01 00:00:01' UTC 到 '2038-01-19 03:14:07'<br /> UTC结束时间是第**2147483647** 秒，北京时间  **2038-1-19 11:14:07** ，<br />格林尼治时间 2038年1月19日 凌晨 03:14:07 | YYYY-MM-DD hh:mm:ss | 混合日期和时间值，<br />时间戳 |

#### 字符串类型

| 类型       | 大小                   | 用途                            |
| ---------- | ---------------------- | ------------------------------- |
| CHAR       | 0-255 bytes            | 定长字符串                      |
| VARCHAR    | 0-65535 bytes          | 变长字符串                      |
| TINYBLOB   | 0-255 bytes            | 不超过 255 个字符的二进制字符串 |
| TINYTEXT   | 0-255 bytes            | 短文本字符串                    |
| BLOB       | 0-65 535 bytes         | 二进制形式的长文本数据          |
| TEXT       | 0-65 535 bytes         | 长文本数据                      |
| MEDIUMBLOB | 0-16 777 215 bytes     | 二进制形式的中等长度文本数据    |
| MEDIUMTEXT | 0-16 777 215 bytes     | 中等长度文本数据                |
| LONGBLOB   | 0-4 294 967 295 bytes  | 二进制形式的极大文本数据        |
| LONGTEXT   | 0-4 294 967 295 bytes | 极大文本数据                    |

age TINYINT UNSIGNED

score double(4, 1) (整体长度，小数位数)

CHAR 相对于 VARCHAR 性能更高，VARCHAR 会根据字符长度确定存储空间

```sql
CREATE TABLE emp (
    id INT COMMENT '编号',
    workno VARCHAR(10) COMMENT '工号',
    name VARCHAR(10) COMMENT '姓名',
    gender CHAR(1) COMMENT '性别',
    age TINYINT UNSIGNED COMMENT '年龄',
    idcard CHAR(18) COMMENT '身份证号',
    entrydate DATE COMMENT '入职时间',
) COMMENT '员工表';

```

#### 表修改

添加字段：ALTER TABLE table_name ADD field type;

修改数据类型：ALTER TABLE table_name MODIFY field new_type;

修改字段名和类型：ALTER TABLE table_name CHANGE old_field new_field type;

删除字段：ALTER TABLE table_name DROP field;

修改表名：ALTER TABLE table_name RENAME TO new_table_name;

删除表：DROP TABLE [IF EXISTS] table_name;

删除并重建：TRUNCATE TABLE table_name;

### DML

#### 插入语句

INSERT INTO table_name (field1, field2, ...) VALUES (value1, value2, ...);

INSERT INTO table_name VALUES (value1, value2, ...), (value1, value2, ...);

#### 更新语句

UPDATE table_name SET field1=new_value1, field2=new_value2, ... [WHERE ...];

#### 删除语句

DELETE FROM table_name [WHERE ...]

delete 不能删除某一字段的值，要修改某一字段应使用 update

### DQL

#### 查询语句：

SELECT [DISTINCT] field_name, field_name [[AS] name], ...

FROM table_name

WHERE ... GROUP BY ... HAVING ... ORDER BY ... LIMIT num ... OFFSET num;

distinct 去重，offset 指定了查询的偏移量

#### WHERE 字句

多个条件可用 AND 和 OR连接，BETWEEN ... AND ... ，IN (...)

#### LIKE 子句

LIKE 子句用于模糊匹配

- % 表示任意数量的字符，若是中文用%%来表示
- _ 表示任意单个字符，通常用于限定字符长度
- [] 表示括号内中字符的任意一个，用于指定范围
- [^] 表示不包含括号内的字符
- 查询以上特殊字符可以用 [] 包围

#### UNION 操作符

UNION 用于将多个 SELECT 语句的结果组合，重复的结果会被删除

SELECT ... FROM table_name WHERE ... UNION [ALL|DISTINCT] SELECT ... FROM table_name WHERE ...;

DISTINCT 会删除重复数据，默认为DISTINCT，ALL 会保留重复数据

#### ORDER BY 子句

ORDER BY field1 ... [ASC|DESC], field2 ... ]ASC|DESC];

默认升序

#### GROUPY BY 子句

SELECT column_name, function(column_name) FROM table_name WHERE column_name operator value GROUP BY column_name HAVING ...;

可以对分组使用COUNT, MAX, MIN, SUM, AVG等函数, NULL 不参与计算

SELECT AVG(score) FROM student;

where 在分组前过滤，having 在分组后过滤， where 中不可使用聚合函数

SELECT address FROM employee WHERE age > 30 GROUP BY address HAVING COUNT(*) > 3; // 查询工作地点中30岁以上员工超过3名的工作地点

### DCL

DCL语言管理数据库用户权限

查询用户：USE mysql;

创建用户：CREATE USER 'username'@'locallhost' IDENTIFIED BY '123456'; localhost表示只能本机访问，%表示任意主机都可访问

修改密码：ALTER USER 'username'@'hostname' IDENTIFIED WITH mysql_native_password BY '123';

删除用户：DROP USER 'username'@'hostname';

### 函数

#### 字符串函数

| 函数                       | 功能               |
| -------------------------- | ------------------ |
| CONCAT                     | 拼接               |
| LOWER, UPPER               | 大小写转换         |
| LPAD, RPAD(str, n, pad)    | padding            |
| TRIM                       | 删除前缀和后缀空格 |
| SUBSTRING(str, start, len) | 子串               |

#### 数值函数

| 函数  | 功能       |
| ----- | ---------- |
| CEIL  | 向上取整   |
| FLOOR | 向下取整   |
| MOD   |            |
| RAND  | (0, 1)随机 |
| ROUND |            |

#### 日期函数

| 函数     | 功能                                                |
| -------- | --------------------------------------------------- |
| CURDATE  | 当前日期 YYYY-MM-DD                                 |
| CURTIME  | 当前时间 HH-MM-SS                                   |
| NOW      | 当前时间 YYYY-MM-DD HH-MM-SS                        |
| YEAR     | 取时间中的年                                        |
| MONTH    | 取时间中的月                                        |
| DAY      | 取时间中的日                                        |
| DATE_ADD | 日期加法 SELECT DATE_ADD(NOW(), INTERVAL 70 MONTH); |
| DATEDIFF | 日期减法                                            |

#### 控制函数

IF(VALUE, T, F)：VALUE 为 TRUE 返回 T, 否则返回 F

IFNULL(VALUE1, VALUE2): VALUE1 不为 NULL 则返回 VALUE1，否则 VALUE2

CASE value WHEN case1 THEN result1 WHEN case2 THEN result2 ELSE default;

CASE WHEN express1 THEN result1 WHEN express2 THEN result2 ELSE defualt;

#### 分页查询

SELECT field_name FROM table_name LIMIT offset, limit_num;

#### 执行顺序

FROM -> WHERE -> GROUP BY -> HAVING -> SELECT -> ORDER BY -> LIMIT

#### 3表连接

INNER JOIN 内联，等值连接：连接两张表均有的记录

LEFT JOIN 左联：保留左表所有记录

RIGHT JOIN 右联：保留右表所有记录
