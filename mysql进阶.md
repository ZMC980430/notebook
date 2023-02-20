# 存储引擎

![1676527452556](image/mysql进阶/1676527452556.png)

默认存储引擎：InnoDB

```sql
CREATE TABLE (
...
) ENGINE=InnoDB;
```

|       Engine       | Support |                            Comment                            | Transaction | XA | Savepoints |
| :----------------: | :-----: | :------------------------------------------------------------: | :---------: | :-: | :--------: |
|       MEMORY       |   YES   |  "Hash based, stored in memory, useful for temporary tables"  |     NO     |    |            |
|     MRG_MYISAM     |   YES   |             Collection of identical MyISAM tables             |     NO     | NO |     NO     |
|        CSV        |   YES   |                       CSV storage engine                       |     NO     | NO |     NO     |
|     FEDERATED     |   NO   |                 Federated MySQL storage engine                 |            |    |            |
| PERFORMANCE_SCHEMA |   YES   |                       Performance Schema                       |     NO     | NO |     NO     |
|       MyISAM       |   YES   |                     MyISAM storage engine                     |     NO     | NO |     NO     |
|       InnoDB       | DEFAULT |  "Supports transactions, row-level locking, and foreign keys"  |     YES     |    |            |
|      ndbinfo      |   NO   |        MySQL Cluster system information storage engine        |            |    |            |
|     BLACKHOLE     |   YES   | /dev/null storage engine (anything you write to it disappears) |     NO     | NO |     NO     |
|      ARCHIVE      |   YES   |                     Archive storage engine                     |     NO     | NO |     NO     |
|     ndbcluster     |   NO   |               "Clustered, fault-tolerant tables"               |            |    |            |

## InnoDB

DML操作遵循ACID模型，支持事务；行级锁，提高并发性能；支持外键约束

文件结构：表空间文件 table_name.ibd，默认一张表对应一个文件

逻辑存储空间：TableSpace, Segment, Extent, Page, Row

如果对事务完整性有较高要求，并有并发需求，除了插入和查询外，还有更新和删除操作，InnoDB是比较合适的选择

## MyISAM

不支持外键、事务，支持表锁不支持行锁，访问速度快

文件结构：table_name.sdi 储存表结构信息，table_name.MYD 储存数据，table_name.MYI 储存索引

如果以插入和查询为主，很少有删除更新操作，对事务要求低，如日志系统，MyISAM更合适，现在常用MongoDB

## Memory

存储在内存中，只能作为临时表或缓存，访问速度快，支持哈希索引

文件结构：table_name.sdi 储存表结构

对表的大小有限制，且无法保证数据安全性，通常用于临时表和缓存，现在常用Redis

# 索引

 索引在存储引擎层实现

| 索引            | 描述                                                       | InnoDB        | MyISAM | Memory |
| --------------- | ---------------------------------------------------------- | ------------- | ------ | ------ |
| B+树            | 最常见                                                     | 支持          | 支持   | 支持   |
| 哈希索引        | 底层由哈希表实现，只有精确匹配的查询才有效，不支持范围查询 | 不支持        | 不支持 | 支持   |
| R树（空间索引） | MyISAM的特殊索引类型，用于地理空间数据类型                 | 不支持        | 支持   | 不支持 |
| 全文索引        | 通过建立倒排索引，快速匹配文档                             | 5.6版本后支持 | 支持   | 不支持 |

## 索引结构

### B树

对于m阶B树，每个节点最多有m个子节点，根节点至少有两个子节点，根节点中关键字为1-（m-1）个，非根节点至少有m/2个。

搜索性能等价于在关键字全集中进行一次二分搜索，相较于二叉树，B树层数少，磁盘IO少

插入节点时，要分裂已满的节点，即将该节点中居中的节点提取并入父节点，剩下两部分作为子节点，若父节点也满，则重复分裂。

删除节点时要合并节点数不足m/2的兄弟节点。

### B+树

与B树不同，B+树中所有数据都存储在叶子节点中，非叶子节点只保存索引，叶子节点保存为一个单链表

在B树中，每个节点保存为一个页，查询时会访问多个页，而在B+树中，一个页可以保存多个索引，减小了查询时磁盘访问次数

在MySQL中，B+树的叶子节点保存为双向循环链表

### 哈希索引

对每行键值计算hash值，冲突时使用链表

哈希索引只支持等值比较，无法排序，但通常效率高于B+树

在MySQL中，Memory引擎支持哈希索引，但在InnoDB中支持自动哈希

## 索引分类

| 分类 | 含义             | 特点           | 关键字   |
| ---- | ---------------- | -------------- | -------- |
| 主键 | 主键索引         | 默认创建，唯一 | PRIMARY  |
| 唯一 | 避免列值重复     | 可以多个       | UNIQUE   |
| 常规 | 快速定位特定数据 | 可以多个       |          |
| 全文 | 查找文本关键字   | 可以多个       | FULLTEXT |

在InnoDB中

| 分类                        | 含义                                               | 特点         |
| --------------------------- | -------------------------------------------------- | ------------ |
| 聚集索引（Clustered Index） | 数据和索引存放在一起，索引结构的叶子节点保存行数据 | 必须有且唯一 |
| 二级索引（Secondary Index） | 数据与索引分开存放，索引结构的叶子节点关联数据     | 可以多个     |

如果存在主键，主键是聚集索引，不存在主键则使用第一个UNIQUE索引作为聚集索引

如果不存在合适的索引，InnoDB会自动生成rowid作为隐含的聚集索引

二级索引查找出主键值，再根据主键值在聚集索引中查找对应行数据

## 索引语法

```sql
-- 创建索引
CREATE [UNIQUE|FULLTEXT] INDEX index_name ON table_name (index_col_name);

-- 查看索引
SHOW INDEX FROM table_name;

-- 删除索引
DROP INDEX index_name ON table_name;
```

## SQL 性能分析

```sql
-- 查询SQL执行频率
SHOW GLOBAL STATUS LIKE 'Com_____';
```

### 慢查询日志

记录耗时超过指定值的查询语句

```sql
-- 查询是否开启慢查询
SHOW VARIABLES LIKE 'slow_query_log';
```

在 my.cnf 中配置 slow_query_log 和 long_query_time

慢日志文件 {host}-slow.log

### profile 详情

记录详细的执行用时

```sql
-- 开启profiles
SELECT @@PROFILING;
SET PROFILING=1;

-- 查看所有命令执行用时
SHOW PROFILES;

-- 查看具体命令的执行用时、cpu占用
SHOW PROFILE [CPU] FOR {QUERY id};
```
