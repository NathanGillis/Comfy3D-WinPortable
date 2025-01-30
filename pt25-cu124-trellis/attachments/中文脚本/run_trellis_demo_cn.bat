@REM 务必根据你的 GPU 型号配置！
set TORCH_CUDA_ARCH_LIST=8.6

@REM 如将 CUDA Toolkit 安装到其他路径，注意修改
set CUDA_HOME=C:\Program Files\NVIDIA GPU Computing Toolkit\CUDA\v12.4

@REM 性能优化 1
@REM "native" 启动更快
@REM "auto" 性能更好，但一开始要跑性能测试
set SPCONV_ALGO=native

@REM 性能优化 2
@REM "xformers" 兼容性更好
@REM "flash-attn" 性能更好 (需要 RTX 30/A100 或更新的 GPU)
set ATTN_BACKEND=xformers

@REM 如需配置代理，取消注释（移除行首的 'rem '）并编辑下两行环境变量。
rem set HTTP_PROXY=http://localhost:1081
rem set HTTPS_PROXY=http://localhost:1081

@REM 如需配置 HuggingFace Access Token（访问令牌），取消注释并编辑。
@REM 管理令牌： https://huggingface.co/settings/tokens
rem set HF_TOKEN=

@REM 如需启用 HF Hub 实验性高速传输，取消该行注释。仅在千兆比特以上网速有意义。
@REM https://huggingface.co/docs/huggingface_hub/hf_transfer
rem set HF_HUB_ENABLE_HF_TRANSFER=1

@REM ===========================================================================

@REM 该环境变量配置 PIP 使用国内镜像站点。
set PIP_INDEX_URL=https://mirrors.tuna.tsinghua.edu.cn/pypi/web/simple

@REM 该环境变量配置 HuggingFace Hub 使用国内镜像站点。
set HF_ENDPOINT=https://hf-mirror.com

@REM 该环境变量指示 HuggingFace Hub 下载模型到"本目录\HuggingFaceHub"，而不是"用户\.cache"目录。
set HF_HUB_CACHE=%~dp0\HuggingFaceHub

@REM 该环境变量指示 Pytorch Hub 下载模型到"本目录\TorchHome"，而不是"用户\.cache"目录。
set TORCH_HOME=%~dp0\TorchHome

@REM 该命令配置 PATH 环境变量。
set PATH=%PATH%;%~dp0\python_embeded\Scripts
set PATH=%PATH%;%CUDA_HOME%\bin

@REM 该环境变量使 .pyc 缓存文件集中保存在一个文件夹下，而不是随 .py 文件分布。
set PYTHONPYCACHEPREFIX=%~dp0\pycache

@REM ===========================================================================

@REM 启动 TRELLIS demo
cd TRELLIS
..\python_embeded\python.exe -s app.py

pause
