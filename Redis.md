# Redis

## Redis 用处

基于内存，可持久化，键值对形式，包含String，List，Set，Sorted Set，Hash，Stream，LogLog，Bitmap

根据2-8原则，将20%的热点数据存储到Redis，对于一些实时性要求高的场景更优，比如点赞，排行。

## 数据类型

| 数据类型    | 描述                                                                 | col3 |
| ----------- | -------------------------------------------------------------------- | ---- |
| String      | 二进制安全的字符串                                                   |      |
| List        | 双向链表                                                             |      |
| Set         | 无序集合，底层是intset或hashtable                                    |      |
| Hash        | 键值对                                                               |      |
| Zset        | 有序集合                                                             |      |
| geo         | 地理空间                                                             |      |
| HyperLogLog | 基数统计，输入元素数量或体积非常大，<br />计算基数（去重数据量）较小 |      |
| bitmap      | 位图                                                                 |      |
| bitfield    | 一次性操作多个比特位                                                 |      |
| stream      | 流                                                                   |      |

## 键操作

16个库，默认使用第一个，select dbindex查看，move key dbindex 2 移动数据，select 3 切换至3号库

set 设置string，keys *查看所有键，dbsize查看key数量

flushdb 清空当前库，flushall 清空所有

命令不区分大小写，但key区分

### String

最大512M，set key value，get key

set 参数

- NX 键不存在时设置
- XX 键存在时设置
- GET 返回值改为原始值
- 过期时间 PX毫秒 EX秒 EXAT unix时间戳（秒）PXAT unix时间戳（毫秒）KEEPTTL
- TTL 修改时保留原过期时间（默认修改值时会重置过期时间）

mset mget，可批量添加获取键。msetnx，当键不存在时批量插入，原子操作，当部分键存在会导致所有插入失效

getrange：相当于substring，setrange，修改部分字符串，只需指定起始位置

incr|decr key [offset] 只能修改整型，浮点不行

setex key time value 设置键和过期时间，是原子操作，set 和 expire的结合

### List

最多2e23-1个元素，用于栈，队列，消息队列

lpush，rpush，lpop，rpop，lrange，没有rrange

lindex key index 获取指定元素 llen 获取长度

lrem key value num，从左删除等于指定值的num个元素

ltrim key start end，截取列表

lpoprpush source target 从source中弹出一个加入到target中

lset key index value，修改指定位置，没有rset

linsert key before|after prev new 在已有值的前后插入新值

### Hash

hset，hget，mhset，mhget，hlen

hgetall 获取所有键值对 hdel

hexists 判断是否存在键 hkeys hvals 获取键和值

hincrby hincrbyfloat 修改值

hsetnx 不存在时设置

### Set

sadd 添加 smembers 所有元素 srem 删除元素 scard 元素个数

srandmember 随机返回一个元素

spop 随机弹出一个元素

smove set1 set2 value 将存在于set1中的value存放到set2中

差集 sdiff 并集 sunion 交集 sinter 交集元素数 sintercard（用于去重统计）

### Zset

zadd key score value score相同时按value字母顺序排列

zrange start end [withscores] 输出全部 zrevrange 反转输出

 zrangebyscore key (score1 score2 [withscores] [limit num offset] 根据分数范围输出，左圆括号表示开区间（无论上限和下限），limit用法和mysql类似

zincrby 递增 zcount 分数范围计数

zrank 输出下标（正序）

### Bitmap

场景：链接有没有点击过，有没有签到

bitmap相当于string类型的子类，因为string底层就是二进制，bitmap是直接操纵bit位

setbit key offset 1|0  或 getbit key pos

strlen key 统计bitmap占了几个字节，超过8位后按字节扩容

bitcount 计数bitmap中1的个数

bitop operation

### HyperLogLog

统计UV (unique visiti)  每个HyperLogLog只要12KB内存，可以存2^64个不同基数，主要用于去重统计，误差为0.81%

PFADD key element 添加元素，常用为ip地址

pfcount 计数 pfmerge new hll1 hll2 将两个HyperLogLog合并

### GEO

geoadd key latitude1 longtitude1 name1 ...  添加经纬度，地理位置名称 ，相当于zset子类

geopos key name1 name2 返回经纬度

geohash key name1 name2 可生成base32编码值，将经纬度合并

geodist key name1 name2 km 返回两个位置的距离

georadius key latitude longtitude dist km [withdist] [withcoord] [withhash] [count n] [desc]

georadiusbymember 可将上述的经纬度替换为geo对象内的位置

### Stream

![](https://pdai.tech/images/db/redis/db-redis-stream-2.png)

特殊符号： - + 最小和最大的ID，$ 消费新的消息，可用于将要到来的信息，> 用于xreadgroup，表示未发送给使用者的消息，会更新消费者组的最后ID， *用于xadd，让系统生成默认ID

| col1       | col2                                                        | col3                                                                                                                     |
| ---------- | ----------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------ |
| xadd       | xadd key * k1 v1 k2 v2                                      | 向队列中添加消息，由多组键值对组成，ID需要递增                                                                           |
| xrange     | xrange key - +                                              | 显示队列中消息的范围                                                                                                     |
| xtrim      | xtrim key maxlen\|minid                                    | 根据最大长度或最小id截断stream，总是舍弃旧消息                                                                           |
| xread      | xread count num srteams key ID                              | 0, 0-0 表示最小id，\$表示当前最大id，可用于读取新消息，阻塞等待读                                                        |
| xgroup     | xgroup create key 0\|$                                      | 创建消费者组，0表示从头开始消费，\$表示从尾开始，即只消费后续新消息                                                      |
| xreadgroup | xreadgroup group gkey consumer1 streams skey [>\|count num] | 消费者读取消息，不限制时会读取全部消息，已读取的信息<br />不能被同组其他消费者读取，但可被其他组消费者读取 >表示读取全部 |
| xpending   | xpending gkey xkey [from to] [consumerkey]                  | 查询已读未签收                                                                                                           |
| xack       | xack xkey gkey ID                                           | 消费者组签收                                                                                                             |

已读未处理的消息：

```
xpending streamkey groupkey
1) (integer) 4        // 已读消息数
2) "1694147905046-0"  // 已读最小id
3) "1694147908682-0"  // 已读最大id
4) 1) 1) "cc1"
      2) "4"
```

### Bitfield

## 持久化

### RDB (Redis Database)

在经过指定时间间隔后将某一时刻的数据和状态作为快照记录到磁盘上 dump.rdb，恢复时直接读取至内存，备份文件应与redis服务器分开存储，恢复时只需要将rdb文件放在redis目录下

- 7之前保存频率为 save seconds changes 表示多少秒内发生多少次修改就保存
- 7之后可以设置多对 secondes changes，满足一个就保存
- 手动保存：save 和 bgsave，save会阻塞服务器，bgsave不会阻塞，原理是fork()一个子进程
- 优点：单文件单时间节点备份，恢复速度快，适合大规模数据恢复
- 缺点：IO大，Redis意外停止会丢失部分数据，fork会导致内存用量翻倍
- 破损rdb文件修复：redis-check-rdb

### AOF（Append Only File）

将Redis的所有写命令以日志方式记录下来，只可追加不可修改，可根据日志文件appendonly.aof重新构建数据

- 当AOF文件过大时，会根据规则将命令合并即AOF重写
- 命令首先写入缓存，之后会写入AOF文件，有三种写回策略：always（IO过于频繁），everysec（默认），no（只写入缓存，由操作系统决定何时写入文件）
- 损坏aof文件修复：redis-check-aof --fix，一般只修改incr文件
- 优点：更持久，可以灵活设定，写入性能更好，因为是仅附加日志，不会出现严重的文件损坏
- 缺点：AOF通常比同等的RDB更大，恢复速度更慢，AOF可能更慢

#### AOF重写

当文件达到所设峰值时，自动重写AOF，只保留能恢复数据的最小指令集。直接读取服务器现有键值对，然后用一条命令代替之前记录的多条数据，生成新文件并替换原文件

### AOF + RDB

同时开启时，优先加载AOF文件。AOF负责增量持久化，RDB负责全量持久化

开启混合模式后，会同时读取两个文件。

## 事务

开启事务：multi

没有隔离级别的概念，不保证原子性，只有是否开始执行全部指令，保证所有指令顺序执行，且中间不会插入别的指令。即使客户端在事务执行期间断开，事务也会执行

| command    | col2                                                                   | col3   |
| ---------- | ---------------------------------------------------------------------- | ------ |
| multi      | 开启事务，接下来的命令只会记录不会执行                                 | queued |
| exec       | 执行前面记录的指令                                                     | ok     |
| discard    | 放弃执行前面的指令                                                     |        |
| watch keys | 添加乐观锁CAS，若加锁的键值在watch和exec之间发生了变化，则事务拒绝执行 |        |
| unwatch    | 解锁所有键值，在执行exec后，原加锁的也会自动解锁                       |        |

- 若记录的命令有错，即在exec前就检查出错误，exec会放弃执行所有命令
- 若在执行期间发生错误，redis事务不可回滚，会执行所有命令，即使是在错误发生后

## Redis底层结构

![1694499424102](image/Redis/1694499424102.png)

- type 包含对象类型，string list set zset hash
- encoding 是具体的编码信息，即对象具体保存的值的类型
- lru 是最后一次访问时间，或者lfu 最少使用的数据，当前时间减lru就是空转时间
- refcount 引用计数，为0时会被回收
- ptr 底层数据结构

![1694499505674](image/Redis/1694499505674.png)

### sds

![1694502773174](image/Redis/1694502773174.png)

头部sdshdr：len 字符串长度；alloc 除去\0后剩余的字节数，可以用uint8，uint16，uint32，uint64表示；flags 占一个字节，低三位表示头部类型

数据buf：buf数组以二进制保存数据，但不以\0判断末尾，而是以存储的长度。
