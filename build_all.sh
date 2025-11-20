#!/bin/bash

# 此脚本用于为 Windows, macOS, 和 Linux 编译 gossh 可执行文件。

set -e

# 定义需要编译的目标平台
# 格式为: <操作系统>_<架构>
#
# 常见平台:
# - darwin_amd64 (macOS Intel)
# - darwin_arm64 (macOS Apple Silicon)
# - linux_amd64 (Linux x86_64)
# - linux_arm64 (Linux ARM64)
# - windows_amd64 (Windows x86_64)
PLATFORMS="darwin_amd64 darwin_arm64 linux_amd64 linux_arm64 windows_amd64"

echo "==> 开始编译, 目标平台: ${PLATFORMS}"

# 调用 make 命令进行交叉编译
make build.multiarch PLATFORMS="${PLATFORMS}"

echo ""
echo "==> 编译完成!"
echo "==> 可执行文件位于 _output/bins/ 目录下。"
ls -l _output/bins/