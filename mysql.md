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
CREATE TABLE emp 
(
    id INT COMMENT '编号',
    workno VARCHAR(10) COMMENT '工号',
    name VARCHAR(10) COMMENT '姓名',
    gender CHAR(1) COMMENT '性别',
    age TINYINT UNSIGNED COMMENT '年龄',
    idcard CHAR(18) COMMENT '身份证号',
    entrydate DATE COMMENT '入职时间'
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

```sql
INSERT INTO table_name (field1, field2, ...) VALUES (value1, value2, ...);
INSERT INTO table_name VALUES (value1, value2, ...), (value1, value2, ...);
```

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

```sql
SELECT column_name, function(column_name) FROM table_name WHERE column_name operator value GROUP BY column_name HAVING ...;
```

可以对分组使用COUNT, MAX, MIN, SUM, AVG等函数, NULL 不参与计算

```sql
SELECT AVG(score) FROM student;
```

where 在分组前过滤，having 在分组后过滤， where 中不可使用聚合函数

SELECT address FROM employee WHERE age > 30 GROUP BY address HAVING COUNT(*) > 3; // 查询工作地点中30岁以上员工超过3名的工作地点

#### 从任一起始位置开始查询

SELECT field_name FROM table_name LIMIT offset, limit_num;

#### 执行顺序

FROM -> WHERE -> GROUP BY -> HAVING -> SELECT -> ORDER BY -> LIMIT

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

```sql
CASE value WHEN case1 THEN result1 WHEN case2 THEN result2 ELSE default;
CASE WHEN express1 THEN result1 WHEN express2 THEN result2 ELSE default;
```

## 约束

约束用于规定字段，限制表中的数据

| 约束     | 关键字      | 备注                                     |
| -------- | ----------- | ---------------------------------------- |
| 非空     | NOT NULL    |                                          |
| 唯一     | UNIQUE      |                                          |
| 主键     | PRIMARY KEY | 非空且唯一                               |
| 默认     | DEFAULT     |                                          |
| 检查约束 | CHECK       | 保证字段满足某一条件                     |
| 外键     | FOREIGN KEY | 建立两张表的连接，保证数据一致性和完整性 |

### 案例

| 字段   | 约束         | 约束关键字                  |
| ------ | ------------ | --------------------------- |
| id     | 主键，自增   | PRIMARY KEY, AUTO_INCREMENT |
| name   | 不为空，唯一 | NOT NULL, UNIQUE            |
| age    | 0-120之间    | CHECK                       |
| status | 默认为1      | DEFAULT                     |
| gender | 无约束       |                             |

```sql
CREATE TABLE user
(
    id     INT PRIMARY KEY AUTO_INCREMENT COMMENT '主键',
    name   VARCHAR(10) NOT NULL UNIQUE COMMENT '姓名',
    age    INT CHECK (age > 0 AND age < 120) COMMENT '年龄',
    status CHAR(1) DEFAULT '1' COMMENT '状态',
    gender CHAR(1) COMMENT '性别'
);
```

### 外键约束

```sql
CREATE TABLE table_name
(
    ...
    [CONSTRAINT] [constraint_name] FOREIGN KEY (foreign_key_name) REFRENCES foreign_table_name(key_name)
);

ALTER TABLE table_name ADD CONSTRAINT constraint_name FOREIGN KEY (foreign_key_name) REFRENCES foreign_table_name(key_name);
```

删除外键

```sql
ALTER TABLE table_name DROP FOREIGN KEY foreign_key_name;
```

## 多表查询

### 多表关系

通过中间表建立两张表的关系，如学生表和课程表，要通过选课表来建立关系。

将同一张表的不同字段拆分成两张表，在任意一张表加入外键，添加唯一约束

### 多表查询

```sql
SELECT * FROM employee emp, department dep WHERE emp.depid = dep.id;
```

#### 连接查询

INNER JOIN 内联，等值连接：连接两张表均有的记录，交集，若需要查询不符合的信息，需要使用外连接

```sql
-- 隐式内连接
SELECT column1 FROM table1, table2 WHERE ...;

-- 显式内连接
SELECT column2 FROM table1 [INNER] JOIN table2 ON ...;
```

LEFT JOIN 左联：保留左表所有记录

RIGHT JOIN 右联：保留右表所有记录

```sql
-- left
SELECT column1 FROM table1 LEFT [OUTER] JOIN table2 ON ...;

-- right
SELECT column2 FROM table1 RIGHT [OUTER] JOIN table2 ON ...;
```

自连接 必须起别名

```sql
-- 内联
SELECT table1.column_name, table2.column_name FROM table table1, table table2 WHERE table1.column1 = table2.column2;

-- 外联
SELECT table1.column_name, table2.column_name FROM table table1 LEFT JOIN table table2 ON table1.column1 = table2.column2;
```

#### 联合查询 UNION

```sql
-- ALL 会有重复项
-- 两个查询结果列数一致，数据类型也一致
SELECT * FROM table1 WHERE condition1
UNION [ALL]
SELECT * FROM table2 WHERE condition2;

```

#### 子查询

```sql
-- 标量子查询，子查询返回单个值
SELECT * FROM table1 WHERE column1 > (SELECT column1 FROM table2);

-- 列子查询，子查询返回列，常用 IN, NOT IN, ANY, SOME, ALL
SELECT * FROM table1 WHERE column1 IN （SELECT column2 FROM table 2);

-- 行子查询，子查询返回行
SELECT * FROM table1 WHERE (column1, column2) = (SELECT column_name1, column_name2 FROM table2);

-- 表子查询，子查询返回多行多列
SELECT * FROM table1 WHERE (column1, column2) IN (SELECT column_name1, column_name2 FROM table2);
SELECT * FROM (SELECT column_name1, column_name2 FROM table2) LEFT JOIN table1 ON table2.id = table1.id;
```

## 事务

一组操作的组合，具有原子性，失败后回滚，MySQL中事务自动提交，

```sql
-- 设置事务提交方式
SELECT @@autocommit;
SET @@autocommit=0;

-- 转账事务
SELECT * FROM account WHERE name = 'user1';
UPDATE account SET money = money - 1000 WHERE name = 'user1';
UPDATE account SET money = money + 1000 WHERE name = 'user2';

-- 成功则提交
COMMIT;
-- 失败则回归
ROLLBACK;

------------------------------------------------
-- 定义事务
START TRANSACTION;
-- 或
BEGIN;
```

### 事务的特性

ACID：原子性、一致性（事务完成时所有数据状态一致）、隔离性、持久性

Atomicity, Consistency, Isolation, Durability

### 并发事务

脏读：一个事务读取另一个事务未提交的数据

不可重复读：一个事务先后读取同一条数据，两次结果不同

幻读：一个事务查询数据时不存在，但在插入时发现该数据已存在

#### 事务的隔离级别

| 隔离级别                 | 脏读     | 不可重复读 | 幻读     |
| ------------------------ | -------- | ---------- | -------- |
| Read uncommitted         | 不可避免 | 不可避免   | 不可避免 |
| Read committed           | 可避免   | 不可避免   | 不可避免 |
| Repeatable Read(default) | 可避免   | 可避免     | 不可避免 |
| Serializable             | 可避免   | 可避免     | 可避免   |

```sql
-- 查看事务隔离级别
SELECT @@TRANSACTION_ISOLATION;

SET SESSION TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
```
