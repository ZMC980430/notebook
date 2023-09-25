docker run -d -p 6380:6380 -p 16380:16380 --name redis01 redis:latest
docker run -d -p 6380:6381 -p 16380:16381 --name redis02 redis:latest
docker run -d -p 6380:6382 -p 16380:16382 --name redis03 redis:latest
docker run -d -p 6380:6383 -p 16380:16383 --name redis04 redis:latest
docker run -d -p 6380:6384 -p 16380:16384 --name redis05 redis:latest
docker run -d -p 6380:6385 -p 16380:16385 --name redis06 redis:latest

docker create --name redis-node1 --net host -v /data/redis-data/node2:/data redis:latest --cluster-enabled yes --cluster-config-file nodes-node-2.conf --port 6380

docker create --name redis-node1 --net host redis:latest -v redis01.conf:/etc/redis/redis.conf --port 6380
docker create --name redis-node1 --net host redis:latest --cluster-enabled yes --cluster-config-file redis01.conf --port 6380
docker create --name redis-node1 --net host redis:latest --cluster-enabled yes --cluster-config-file redis01.conf --port 6380
docker create --name redis-node1 --net host redis:latest --cluster-enabled yes --cluster-config-file redis01.conf --port 6380
docker create --name redis-node1 --net host redis:latest --cluster-enabled yes --cluster-config-file redis01.conf --port 6380
docker create --name redis-node1 --net host redis:latest --cluster-enabled yes --cluster-config-file redis01.conf --port 6380

docker run -p 6371:6379 -p 16371:16379 --name redis-1 -v D:\redis_conf\node6380\redis.conf:/etc/redis/redis.conf -d --net redis-network --ip 172.28.0.11 redis:latest redis-server /etc/redis/redis.conf
docker run -p 6372:6379 -p 16372:16379 --name redis-2 -v D:\redis_conf\node6381\redis.conf:/etc/redis/redis.conf -d --net redis-network --ip 172.28.0.12 redis:latest redis-server /etc/redis/redis.conf
docker run -p 6373:6379 -p 16373:16379 --name redis-3 -v D:\redis_conf\node6382\redis.conf:/etc/redis/redis.conf -d --net redis-network --ip 172.28.0.13 redis:latest redis-server /etc/redis/redis.conf
docker run -p 6374:6379 -p 16374:16379 --name redis-4 -v D:\redis_conf\node6383\redis.conf:/etc/redis/redis.conf -d --net redis-network --ip 172.28.0.14 redis:latest redis-server /etc/redis/redis.conf
docker run -p 6375:6379 -p 16375:16379 --name redis-5 -v D:\redis_conf\node6384\redis.conf:/etc/redis/redis.conf -d --net redis-network --ip 172.28.0.15 redis:latest redis-server /etc/redis/redis.conf
docker run -p 6376:6379 -p 16376:16379 --name redis-6 -v D:\redis_conf\node6385\redis.conf:/etc/redis/redis.conf -d --net redis-network --ip 172.28.0.16 redis:latest redis-server /etc/redis/redis.conf

redis-cli --cluster create 172.28.0.11:6379 172.28.0.12:6379 172.28.0.13:6379 172.28.0.14:6379 172.28.0.15:6379 172.28.0.16:6379 --cluster-replicas 1
