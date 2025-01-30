#!/bin/bash
set -eu

# 该脚本与 `run_trellis_demo_cn.bat` 功能相同。
# 该脚本是在开发阶段为兼容 Linux 上下文而写（TRELLIS 官方说仅在 Linux 上测试），
# 后经测试发现 bat 脚本也可正常运行，没必要麻烦用户，故将该脚本存档于此。

# 运行该脚本需安装 Git for Windows: https://git-scm.com/download/win
# 并在安装时选择 Git Bash（默认）
# 之后使用 Bash 运行

################################################################################
# 务必根据你的 GPU 型号配置！
export TORCH_CUDA_ARCH_LIST="6.1+PTX"

export CUDA_HOME="/c/Program Files/NVIDIA GPU Computing Toolkit/CUDA/v12.1"

################################################################################
# 性能优化（可选）

# 如果仅单次运行，使用 "native" 即可
# 如果长期运行，使用 "auto" 会有更好性能，但一开始会花时间进行性能测试。
export SPCONV_ALGO="native"

# 默认使用 "xformers" 以保证兼容性
# 如果需要高性能，尝试改为 "flash-attn"
# Flash Attention 只能用于 Ampere (RTX 30 系 / A100) 及更新的 GPU
export ATTN_BACKEND="flash-attn"

################################################################################

# 如需配置代理，取消注释并编辑以下部分
# (删除行首井号 # )
#export HTTP_PROXY=http://localhost:1081
#export HTTPS_PROXY=$HTTP_PROXY
#export http_proxy=$HTTP_PROXY
#export https_proxy=$HTTP_PROXY
#echo "[INFO] Proxy set to $HTTP_PROXY"

# 配置使用国内镜像站点
export PIP_INDEX_URL="https://mirrors.tuna.tsinghua.edu.cn/pypi/web/simple"
export HF_ENDPOINT="https://hf-mirror.com"

################################################################################

workdir="$(pwd)"

# 该环境变量指示 HuggingFace Hub 下载模型到"本目录\HuggingFaceHub"，而不是"用户\.cache"目录。
export HF_HUB_CACHE="$workdir/HuggingFaceHub"

# 该环境变量指示 Pytorch Hub 下载模型到"本目录\TorchHome"，而不是"用户\.cache"目录。
export TORCH_HOME="$workdir/TorchHome"

# 该命令配置 PATH 环境变量。
export PATH="${PATH}:$workdir/python_embeded/Scripts:${CUDA_HOME}/bin"

# 该环境变量使 .pyc 缓存文件集中保存在一个文件夹下，而不是随 .py 文件分布。
export PYTHONPYCACHEPREFIX="$workdir/pycache"

# 该命令会复制 u2net.onnx 到用户主目录下，以免启动时还需下载。
if [ ! -f "${HOME}/.u2net/u2net.onnx" ]; then
  if [ -f "./extras/u2net.onnx" ]; then
    mkdir -p "${HOME}/.u2net"
    cp "./extras/u2net.onnx" "${HOME}/.u2net/u2net.onnx"
  fi
fi

# 下载 TRELLIS 模型（不会重复下载）
if [ ! -f "$workdir/python_embeded/Scripts/.hf-hub-reinstalled" ] ; then
    $workdir/python_embeded/python.exe -s -m pip uninstall --yes huggingface-hub
    $workdir/python_embeded/python.exe -s -m pip install huggingface-hub
    touch "$workdir/python_embeded/Scripts/.hf-hub-reinstalled"
fi ;

echo "########################################"
echo "[INFO] Checking TRELLIS model..."
echo "########################################"

$workdir/python_embeded/Scripts/huggingface-cli.exe download JeffreyXiang/TRELLIS-image-large

# 运行 TRELLIS 官方 Gradio demo

echo "########################################"
echo "[INFO] Starting TRELLIS demo..."
echo "########################################"

cd TRELLIS
../python_embeded/python.exe -s app.py
