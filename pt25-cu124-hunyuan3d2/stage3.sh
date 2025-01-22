#!/bin/bash
set -eux

ls -lahF

du -hd1 Hunyuan3D2_WinPortable

"C:\Program Files\7-Zip\7z.exe" a -t7z -m0=lzma2 -mx=5 -mfb=32 -md=32m -ms=on -mf=BCJ2 -v2140000000b Hunyuan3D2_WinPortable.7z Hunyuan3D2_WinPortable

ls -lahF
