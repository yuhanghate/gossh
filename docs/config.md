# config (配置文件)

为了方便使用，您可以使用配置文件。
您可以将不经常更改的标志写入配置文件，这样就不需要在命令行上费力地指定这些标志。
如果同一个标志同时出现在命令行和配置文件中，命令行的标志将优先于配置文件中的设置。

默认的配置文件是 `$PWD/.gossh.yaml` 或 `$HOME/.gossh.yaml`，其中 `$PWD/.gossh.yaml` 的优先级更高。

请注意，配置文件是可选的，也就是说，没有配置文件 `gossh` 也能正常工作。

## 配置文件内容示例

示例文件可以在 Git 仓库的 `configs/gossh.yaml` 位置找到，或者使用 `gossh config` 命令生成。

```yaml
auth:
  # 登录用户。
  # 默认值: $USER (当前系统用户)
  user:

  # 登录用户的密码。
  # 默认值: ""
  password:

  # 交互式地询问登录用户的密码。
  # 默认值: false
  ask-pass: false

  # 存放登录用户默认密码的文件。
  # 默认值: ""
  file:

  # 用于公钥认证的私钥文件。
  # 默认值: [~/.ssh/id_rsa]
  identity-files: [~/.ssh/id_rsa]

  # 私钥文件的密码。
  # 默认值: ""
  passphrase:

  # 存放用于加密和解密的 vault 密码的文件。
  # 默认值: ""
  vault-pass-file:

hosts:
  # 存放目标主机的默认清单文件。
  # 文件内容格式可以参考:
  # https://github.com/windvalley/gossh/blob/main/docs/inventory.md
  # 默认值: ""
  inventory:

  # 目标主机的默认端口。
  # 默认值: 22
  port: 22

run:
  # 使用 sudo 执行任务。
  # 默认值: false
  sudo: false

  # 以此用户身份通过 sudo 运行。
  # 默认值: root
  as-user: root

  # 执行命令/脚本时，将系统的环境变量 LANG/LC_ALL/LANGUAGE
  # 导出为此值。
  # 可用值: zh_CN.UTF-8, en_US.UTF-8, 等。
  # 默认值: "" (空值表示不导出)
  lang:

  # 并发连接数。
  # 默认值: 1
  concurrency: 1

  # 针对 gossh 子命令 'command' 和 'script' 的 Linux 命令黑名单。
  # 出于安全原因，此黑名单中列出的命令将被禁止在远程主机上执行。
  # 您可以添加 '-n, --no-safe-check' 标志来禁用此功能。
  # 默认值: [rm, reboot, halt, shutdown, init, mkfs, mkfs.*, umount, dd]
  command-blacklist:
    [rm, reboot, halt, shutdown, init, mkfs, mkfs.*, umount, dd]

output:
  # 将消息输出到的文件。
  # 默认值: ""
  file:

  # 以 json 格式输出消息。
  # 默认值: false
  json: false

  # 精简输出并禁用颜色。
  # 默认值: false
  condense: false

  # 显示调试消息。
  # 默认值: false
  verbose: false

  # 不将消息输出到屏幕。
  # 默认值: false
  quite: false

timeout:
  # 连接每个目标主机的超时秒数。
  # 默认值: 10 (秒)
  conn: 10

  # 在每个目标主机上执行命令/脚本的超时秒数。
  # 注意: 此命令超时包括连接超时 (timeout.conn)。
  # 默认值: 0 (0 表示不限制)
  command: 0

  # 运行整个 gossh 任务的超时秒数。
  # 默认值: 0 (0 表示不限制)
  task: 0

proxy:
  # 代理服务器地址。如果非空，将启用代理。
  # 默认值: ""
  server:

  # 代理服务器端口。
  # 默认值: 22
  port: 22

  # 代理服务器用户。
  # 默认值: 与 'auth.user' 相同
  user:

  # 代理服务器的密码。
  # 默认值: 与 'auth.password' 相同
  password:

  # 用于代理的私钥文件。
  # 默认值: 与 'auth.identity-files' 相同
  identity-files:

  # 用于代理的私钥文件的密码。
  # 默认值: 与 'auth.passphrase' 相同
  passphrase:
```

## 示例

通过 `config` 子命令生成配置文件：

```sh
$ gossh config --hosts.inventory=/path/to/hosts.txt > ~/.gossh.yaml
```
