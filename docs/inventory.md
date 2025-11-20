# inventory (主机清单)

主机清单（Inventory file）是一个存储目标主机信息的文件。默认情况下，`gossh` 不会使用清单文件。
如果您希望 `gossh` 默认使用某个清单文件，您可以在配置文件中通过 `hosts.inventory` 指定它。否则，您必须通过命令标志 `-i, --hosts.inventory` 来使用它。

如果您不使用清单文件，您必须将目标主机作为位置参数（positional arguments）提供，并用空格分隔。

## 清单文件格式

```ini
# 这是一个用于 gossh 的主机清单文件

# 未分组的主机
alias_name_node1 host=node1.sre.im
node100.sre.im

# 主机组
[webserver]
# 主机条目
alias_name_node2 host=192.168.33.12 port=8022 user=vagrant password=123456 keys=~/.ssh/id_rsa passphrase=xxx
node[06-07].sre.im port=9022 user=lisi password=654321
node08.sre.im

# 针对 webserver 主机组的变量组
[webserver:vars]
port=8033
user=wangwu

[dbserver]
192.168.1.10

[dbserver:vars]
user=vagrant2
password=abcdefg

# project1 主机组包含了 dbserver 组和 webserver 组中定义的所有主机
[project1:children]
dbserver
webserver
```

可用的变量包括: `host`, `port`, `user`, `password`, `keys`, `passphrase`。

主机变量的优先级顺序为：`主机条目中定义的变量` > `变量组中的变量` > `命令行标志中的变量`。

主机模式（Host patterns）将被自动扩展为主机列表，支持的主机模式示例如下：

```text
10.16.0.[1-10]
foo[01-03].bar.com
foo[01-03,06,12-16].idc[1-3].[beijing,wuhan].bar.com
```

以下示例均使用上述清单文件。

## 示例

### 通过命令行标志指定清单文件

```sh
# 默认获取清单中的所有主机
$ gossh command -i /path/to/hosts.txt -l
```

输出:

```text
alias_name_node1
node100.sre.im
alias_name_node2
node06.sre.im
node07.sre.im
node08.sre.im
192.168.1.10

hosts (7)
```

### 在配置文件中指定清单文件

修改 `~/.gossh.yaml` 或 `./.gossh.yaml` 文件，内容如下：

```yaml
hosts:
  # 存放目标主机的默认清单文件
  # 默认值: ""
  inventory: "/path/to/hosts.txt"
```

```sh
# 默认获取清单中的所有主机
$ gossh command -l
```

输出:

```text
alias_name_node1
node100.sre.im
alias_name_node2
node06.sre.im
node07.sre.im
node08.sre.im
192.168.1.10

hosts (7)
```

### 通过主机名或主机组名筛选主机

```sh
# 按组名筛选
$ gossh command webserver -l
```

输出:

```text
alias_name_node2
node06.sre.im
node07.sre.im
node08.sre.im

hosts (4)
```

```sh
# 按主机名筛选
$ gossh command 192.168.1.10 -l
```

输出:

```text
192.168.1.10

hosts (1)
```

```sh
# 同时按组名和主机名筛选
$ gossh command webserver 192.168.1.10 -l
```

输出:

```text
alias_name_node2
node06.sre.im
node07.sre.im
node08.sre.im
192.168.1.10

hosts (5)
```

### 指定不在清单文件中的目标主机

```sh
# 按组名和主机名筛选，并添加其他不在清单文件中的主机
$ gossh command webserver 192.168.1.10 "not-in-inventory-[1-3].sre.im" -l
```

输出:

```text
alias_name_node2
node06.sre.im
node07.sre.im
node08.sre.im
192.168.1.10
not-in-inventory-1.sre.im
not-in-inventory-2.sre.im
not-in-inventory-3.sre.im

hosts (8)
```

```sh
# 指定不在清单文件中的目标主机
$ gossh command "not-in-inventory[1-3].sre.im" -l
```

输出:

```text
not-in-inventory-1.sre.im
not-in-inventory-2.sre.im
not-in-inventory-3.sre.im

hosts (3)
```

### 目标主机的去重

如果发现重复的主机，默认会进行去重。

```sh
$ gossh command webserver "node0[6-7].sre.im" -l
```

输出:

```text
alias_name_node2
node06.sre.im
node07.sre.im
node08.sre.im

hosts (4)
```
