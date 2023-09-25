# ElasticSearch

支持 RESTful（Representational State Transfer）的全文搜索引擎。基于倒排索引。

## 索引

- 创建 put 请求 `http://127.0.0.1:9200/{index}`
- 查询索引 get `http://127.0.0.1:9200/{index}`
- 删除索引 delete `http://127.0.0.1:9200/{index}`
- 向索引添加数据 post/put `http://127.0.0.1:9200/{index}/_doc/{id}`，并在请求体中添加数据。可使用 id 自定义。
- 查询数据 get `http://127.0.0.1:9200/{index}/_doc/{id}` 查询所有数据：`http://127.0.0.1:9200/{index}/_search`
- 修改
  - 全量修改 post/put `http://127.0.0.1:9200/{index}/_doc/{id}` + 请求体 1
  - 局部修改 post `http://127.0.0.1:9200/{index}/_doc/{id}` + 请求体 2

```json
{
    "title": "啊啊",
    "category": "test",
    "number": 13479341
}
```

```json
{
    "doc": {
        "category": "test"
	}
}
```

返回值的 result 字段包含操作的结果状态。

按具体字段搜索 get  `http://127.0.0.1:9200/{index}/_search?q=category:test` 或者在请求体中发送

```json
"query": {
    "match": {
          "category": "test"
    }
}
```

- 分页查询：在请求体中添加 from 和 size 字段
- 指定字段查询：_source
- 结果排序：sort : {"field": {"order": "desc"}}
- 条件查询：

```json
// 唯一条件
{
    "query": {
        "bool": {
            "must" :{
                "match" :{
                    "_id": 10
                }
            }
        }
    }
}
```

```json
// 多条件
{
    "query": {
        "bool": {
            "should" :[
                {
                    "match":{
                        "_id": 10
                    }
                },
                {
                    "match": {
                        "_id": 11
                    }
                }
            ]
        }
    }
}
```

query的结果会返回 score，作为匹配程度的分数。filter 会直接过滤不符合的结果。查询时字段会做拆分，match_phrase 则是全文匹配，不会拆分。

- 聚合查询：根据 field 分组，包括组内数据数。

```json
{// 分组返回
    "aggs": {
        "some_name": {
            "terms": {
                "field": "some_field"
            }
        }
    }
}

{// 计算均值
    "aggs": {
        "some_name": {
            "avg": {
                "field": "some_field"
            }
        }
    }
}
```
