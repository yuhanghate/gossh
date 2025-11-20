# GoSSH Windows 工具包

本目录包含在 Windows 环境下使用 `gossh` 的相关工具和配置文件。



## 快速开始：一键上传与发布


### 第一步：上传文件

此命令会将本地的 `yunwei.zip` 文件上传到服务器。

**注意**: 请将命令中的 `"C:\path\to\your\yunwei.zip"` 替换为文件的真实路径。

```batch
gossh.exe --config config\gossh.yaml push -f "C:\path\to\your\yunwei.zip" -d /root/biaokao/vue -F
```

### 第二步：执行远程命令

文件上传成功后，执行此命令来进行发布。

```batch
gossh.exe --config config\gossh.yaml command -e "cd /root/biaokao/vue && sh 8802.sh"
```