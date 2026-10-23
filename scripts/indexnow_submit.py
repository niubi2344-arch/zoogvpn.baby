#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
zoogvpn.baby - IndexNow 搜索引擎推送脚本 (Python 3 原生版)
使用 Python 标准库 urllib 构建，无需 pip 安装任何第三方依赖库即可直接运行。
"""

import sys
import json
import urllib.request
import urllib.error

HOST = "zoogvpn.baby"
KEY = "e4f1a98c0b2d45e69738c82f10b7a65d"
KEY_LOCATION = f"https://{HOST}/{KEY}.txt"

URL_LIST = [
    f"https://{HOST}/",
    f"https://{HOST}/insights.html",
    f"https://{HOST}/about.html",
    f"https://{HOST}/terms.html",
    f"https://{HOST}/privacy.html",
    f"https://{HOST}/sitemap.html",
]

ENDPOINTS = [
    ("IndexNow 官方中央网关", "https://api.indexnow.org/indexnow"),
    ("Bing (微软必增) 网关", "https://www.bing.com/indexnow"),
]

def submit_indexnow():
    print("=" * 60)
    print("       zoogvpn.baby - IndexNow URL 推送工具 (Python 版)     ")
    print("=" * 60)
    print(f"站点域名: {HOST}")
    print(f"API 密钥: {KEY}")
    print(f"密钥路径: {KEY_LOCATION}")
    print(f"待提交 URL 数量: {len(URL_LIST)} 条\n")

    payload = {
        "host": HOST,
        "key": KEY,
        "keyLocation": KEY_LOCATION,
        "urlList": URL_LIST,
    }
    json_data = json.dumps(payload, ensure_ascii=False).encode("utf-8")
    headers = {
        "Content-Type": "application/json; charset=utf-8",
        "User-Agent": "IndexNow-AutoPusher/2.0",
    }

    for name, endpoint in ENDPOINTS:
        print(f"正在推送至: {name} ({endpoint}) ... ", end="", flush=True)
        try:
            req = urllib.request.Request(endpoint, data=json_data, headers=headers, method="POST")
            with urllib.request.urlopen(req, timeout=15) as resp:
                code = resp.getcode()
                if code in (200, 202):
                    print(f"[成功 {code}] 提交成功！")
                else:
                    print(f"[响应状态: {code}]")
        except urllib.error.HTTPError as e:
            print(f"[HTTP 状态: {e.code}] {e.reason}")
        except Exception as e:
            print(f"[失败] {str(e)}")

    print("\n提交流程完毕。请确保网站根目录的密钥验证文件可正常访问。")

if __name__ == "__main__":
    submit_indexnow()