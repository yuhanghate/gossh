# 认证方式

`Gossh` 支持三种 SSH 认证方式：`SSH-Agent`、`公钥认证(Pubkey)` 和 `密码认证(Password)`。

它会自动检测上述三种认证方式以登录用户。如果未指定，默认的登录用户是当前系统的 `$USER` 变量。

`密码(Password)` 可以来自多种来源：
1.  清单文件 (inventory file) 中为特定主机设置的 `password` 变量。
2.  命令行标志：`-k`/`--auth.ask-pass` (交互式输入密码)、`-p`/`--auth.password` (直接提供密码)、`-a`/`--auth.pass-file` (从文件读取密码)。
3.  配置文件中 `auth` 部分的相关设置。

`公钥认证(Pubkey Authentication)` 默认启用，它会使用身份认证文件（如果未指定，默认为 `~/.ssh/id_rsa`）。`Gossh` 也支持带密码的私钥文件，您可以使用 `-K, --auth.passphrase` 标志来指定私钥的密码。

如果系统环境变量 `$SSH_AUTH_SOCK` 存在，`SSH-Agent 认证` 将被自动启用。

如果这三种认证方式同时有效，它们的优先级顺序是：`SSH-Agent` > `公钥认证` > `密码认证`。

## 示例

### 使用密码认证

```sh
# 交互式输入密码
$ gossh command target_host -e "uptime" -k

# 通过 '-p' 标志直接提供明文密码
$ gossh command target_host -e "uptime" -p "your-plain-password"

# 提供由 `gossh vault encrypt` 加密后的密码
$ gossh command target_host -e "uptime" -p "your-cipher-password" -V /path/to/vault-pass-file

# 通过密码文件提供密码
$ gossh command target_host -e "uptime" -a /path/to/password-file

# 在配置文件中设置了密码 (auth.password/auth.file)
$ gossh command target_host -e "uptime"
```

### 使用无密码的公钥认证

```sh
# 生成一个没有密码的密钥对
$ ssh-keygen -t rsa -f /path/to/id_rsa -N ""

# 将公钥复制到目标主机
$ ssh-copy-id -i /path/to/id_rsa target_host

# 如果您的私钥路径是默认的 '~/.ssh/id_rsa', 则可以省略 '-I /path/to/id_rsa' 标志
$ gossh command target_host -e "uptime" -I /path/to/id_rsa
```

### 使用带密码的公钥认证

```sh
# 生成一个带密码的密钥对
$ ssh-keygen -t rsa -f /path/to/id_rsa -N "your-passphrase"

# 将公钥复制到目标主机
$ ssh-copy-id -i /path/to/id_rsa target_host

# 如果您的私钥路径是默认的 '~/.ssh/id_rsa', 则可以省略 '-I /path/to/id_rsa' 标志
# 注意: "your-passphrase" 可以通过 `gossh vault encrypt` 命令加密，
# 加密后，您必须额外添加 `-V /path/to/vault-pass-file` 标志。
$ gossh command target_host -e "uptime" -I /path/to/id_rsa -K "your-passphrase"
```

### 使用 SSH-Agent 认证

以下步骤基于您已完成公钥认证的设置。

```sh
# 启动 ssh-agent
$ ssh-agent
```

输出:

```text
SSH_AUTH_SOCK=/var/folders/42/nh6v60h917x69c1mtczc_g300000gn/T//ssh-9VvFRZMFXiJc/agent.53250; export SSH_AUTH_SOCK;
SSH_AGENT_PID=53251; export SSH_AGENT_PID;
echo Agent pid 53251;
```

```sh
# 导出环境变量
$ SSH_AUTH_SOCK=/var/folders/42/nh6v60h917x69c1mtczc_g300000gn/T//ssh-9VvFRZMFXiJc/agent.53250; export SSH_AUTH_SOCK;
$ SSH_AGENT_PID=53251; export SSH_AGENT_PID;

# 列出 agent 当前管理的所有身份的指纹
$ ssh-add -l

# 将您的私钥添加到 ssh-agent
$ ssh-add ~/.ssh/id_rsa

# 再次列出 agent 管理的身份，确认已添加成功
$ ssh-add -l
```

```sh
# 测试连接
$ gossh command target_host -e "uptime" -v
```

### 检查连接到目标主机时使用了哪种认证方式

```sh
# 首先，登录到您的目标主机
$ ssh target_host

# 在目标主机上，实时查看安全日志
$ tail -f /var/log/secure
```
