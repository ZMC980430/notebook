# Flume

监控本地磁盘文件，监控网络端口数据

flume 包含三个组件 source channel sink

- source 负责接收数据到 flume agent，可以处理各种类型格式的日志数据 source 接受事件输入，可以存储到一个或多个 channel 中
- channel 被动存储所有事件，知道被sink消费，channel 是线程安全的。基于内存的 memory channel 和基于磁盘的 memory channel
- sink 负责从 channel 中去除 event 并送至 kafka 或 HDFS
