# command (执行命令)

在目标主机上执行 Shell 命令。

## 示例

```sh
# 为在每台目标主机上执行的命令设置超时时间（秒）
$ gossh command host[1-3] -e "uptime" -t 20

# 通过代理服务器 10.16.0.1 连接目标主机
$ gossh command host[1-3] -e "uptime" -X 10.16.0.1

# 指定并发连接数
$ gossh command host[1-3] -e "uptime" -c 10
```


