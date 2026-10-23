# zoogvpn.baby - 脚本工具包说明

本目录包含两组关键运维脚本：

## 1. IndexNow 搜索引擎极速推送 (`indexnow_submit.bat` / `.ps1` / `.py`)
- 用于向 Bing (微软必应)、Yandex 等搜索引擎主动提交全站 URL，加速新站收录。
- Windows 用户可直接双击运行 **`indexnow_submit.bat`**。

## 2. GitHub 一键云端上传 (`github_upload.bat` / `.ps1`)
- 基于 GitHub 官方 REST API 开发，Windows 原生 PowerShell 驱动，无需安装 Git 即可直传。
- 双击运行 **`github_upload.bat`**，输入 GitHub Token 即可全自动创建仓库 `zoogvpn.baby` 并开通 GitHub Pages。