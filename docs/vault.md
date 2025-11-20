# vault (加密工具)

`vault` 用于加密敏感内容（如密码），这样您就可以保护它，而不是让它以明文形式出现在公共场合。

要使用 `vault`，您需要另一个密码（称为 vault-pass）来加密和解密内容。

vault 密码可以通过 `-V, --auth.vault-pass-file` 标志提供，或者从命令行提示符输入。

`-V` 标志的值可以是一个包含明文 vault 密码的文本文件，或者是一个可执行文件，该文件可以从 REST API、数据库或其他安全的地方获取 vault 密码。

如果您不想每次运行 `gossh vault` 命令时都输入 `-V` 标志，您可以将此标志的值写入配置文件。

## encrypt (加密)

加密敏感内容（字符串）。

### 示例

#### 示例 1

```sh
$ gossh vault encrypt
```

输出:

```text
New Vault password: (输入新的 vault 密码)
Confirm new vault password: (确认新的 vault 密码)
Plaintext: (输入要加密的明文)
Confirm plaintext: (确认要加密的明文)

GOSSH-AES256:a40ab7109050cd20d06fc8e39412d5e605e7a1a1ecc84ff686fb82b88518dde0
```

上面输出的 `Plaintext` 是要加密的敏感字符串。

#### 示例 2

```sh
$ gossh vault encrypt -V ./vault-pass-file
```

输出:

```text
Plaintext: (输入要加密的明文)
Confirm plaintext: (确认要加密的明文)

GOSSH-AES256:349a1220bc8adbb6b784624e8f4e913b24cf0836c45b73e9ab16c66cec7c3adf
```

#### 示例 3

```sh
$ gossh vault encrypt "the-password" -V ./vault-pass-file
```

输出:

```text
GOSSH-AES256:1ef8a41af6f38046c7eabe5a5221274f084c0f3bf0fdb99c793b7c069139378e
```

## decrypt (解密)

解密由 `vault` 加密的内容（字符串）。

### 示例

```sh
$ gossh vault decrypt -V ./vault-pass-file GOSSH-AES256:1ef8a41af6f38046c7eabe5a5221274f084c0f3bf0fdb99c793b7c069139378e
```

输出:

```text
the-password
```

## encrypt-file (加密文件)

加密一个文件。

### 示例

```sh
$ gossh vault encrypt-file -V ./vault-pass-file foo.txt
```

输出:

```text
Encryption successful (加密成功)
```

```sh
cat foo.txt
```

输出:

```text
GOSSH-AES256:631c5a5ced3aecc2c34532cdb08339a130b3fe59ccc1154c526c30f452bb92e211277fdad30226d6897f5557700bd00d776f858562e3eff2fa40605fba5f9aa36cc9b33e842e941e1995761a38c8278b
```

## decrypt-file (解密文件)

解密由 `vault` 加密的文件。

### 示例

```sh
$ gossh vault decrypt-file foo.txt -V ./vault-pass-file
```

输出:

```text
Decryption successful (解密成功)
```

## view (查看)

查看由 `vault` 加密的文件内容。

### 示例

```sh
$ gossh vault view foo.txt -V ./vault-pass-file
```

输出:

```text
the sensitive content
...

(END)
```
