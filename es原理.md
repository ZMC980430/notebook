# ElasticSearch 原理

es 集群中每个节点都会包含多个 shard，一个节点内或多个节点中的 shard 可以组成一个es索引，一个shard就是一个Lucene Index

## lucene

lucene 里面有很多段，每个段可以看作一个mini index，

### segment

一个segment内部包含许多结构

#### inverted index

倒排索引是最重要的结构，包含

- 有序的数据字典，包括单词 term 和出现频率
- 与单词对应的 postings，即包含单词的文件

搜索时，首先分解搜索内容，然后寻找对应 term，从而找到内容。要查找以某个字母开头的单词，可以直接使用二分查找。但如果要查找包含某个字段的单词，就需要扫描所有索引，优化方式是生成合适的 term

##### 优化方式

- 对 term 做反向处理，可以按后缀搜索
- 将地理信息保存为 hash
- 对于简单数字，可以生成多重形式的 term，如 123 -> 1-hundred 12-twelve 123 等

##### 解决拼写错误

可以使用一个包含可能的错误的树形状态机，解决拼写错误。

#### stored field

当需要查找包含某个特定内容的文件时，倒排索引不够解决。本质上 stored field 是一个 k-v 键值对。

#### ducument values

使用以上结构会在查找时读取大量不需要的信息，document values 保存列式存储，优化具有相同类型的数据的存储结构

### 搜索时

lucene 搜索所有 segment，将所有结果返回。lucene 的特性：

- segments 不可变，删除只做标记，修改只会删除原 segments，并重新索引
- 随处可见的压缩
- 缓存所有信息

### 缓存

当 es 索引一个文件时会建立索引，并每秒刷新数据，随着时间增加，会产生大量 segments，es 会合并 segments，并删除原有的 segment。因此增加文件可能会使索引占用空间变小，会触发 segment merge，从而压缩时节省更多空间。新的 segment 在缓存中处于 cold 状态，但大多数 segment 还处于 warm 状态。

在 es 中，搜索发生在 shard 中，与 lucene 类似。但搜索可能发生在多个节点中。
