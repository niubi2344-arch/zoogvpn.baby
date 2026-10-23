# ==============================================================================
# IndexNow 搜索引擎极速收录自动提交脚本 (PowerShell 原生版)
# 专为 Windows 系统打造，无需安装 Python 环境，开箱即用！
# 支持搜索引擎: Bing (必应), Yandex, Naver, Seznam 等
# ==============================================================================

[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
$OutputEncoding = [System.Text.Encoding]::UTF8

Write-Host "==========================================================" -ForegroundColor Cyan
Write-Host "       zoogvpn.baby - IndexNow 搜索引擎推送工具         " -ForegroundColor Yellow
Write-Host "==========================================================" -ForegroundColor Cyan

$hostName = "zoogvpn.baby"
$apiKey = "e4f1a98c0b2d45e69738c82f10b7a65d"
$keyLocation = "https://$hostName/$apiKey.txt"

$urlList = @(
    "https://$hostName/",
    "https://$hostName/insights.html",
    "https://$hostName/about.html",
    "https://$hostName/terms.html",
    "https://$hostName/privacy.html",
    "https://$hostName/sitemap.html"
)

Write-Host ""
Write-Host "[1/3] 准备推送数据..." -ForegroundColor White
Write-Host "目标域名: $hostName" -ForegroundColor Gray
Write-Host "API 密钥: $apiKey" -ForegroundColor Gray
Write-Host "密钥验证路径: $keyLocation" -ForegroundColor Gray
Write-Host "待提交 URL 数量: $($urlList.Count) 个" -ForegroundColor Gray

$payloadObj = @{
    host = $hostName
    key = $apiKey
    keyLocation = $keyLocation
    urlList = $urlList
}

$jsonPayload = $payloadObj | ConvertTo-Json -Depth 5

Write-Host ""
Write-Host "[2/3] 正在向 IndexNow 网关发送推送请求..." -ForegroundColor White

$endpoints = @(
    @{ Name = "IndexNow 官方中央网关"; Uri = "https://api.indexnow.org/indexnow" },
    @{ Name = "Bing (微软必应) 网关"; Uri = "https://www.bing.com/indexnow" }
)

foreach ($ep in $endpoints) {
    Write-Host "正在请求: $($ep.Name)... " -NoNewline
    try {
        $bodyBytes = [System.Text.Encoding]::UTF8.GetBytes($jsonPayload)
        $request = [System.Net.WebRequest]::Create($ep.Uri)
        $request.Method = "POST"
        $request.ContentType = "application/json; charset=utf-8"
        $request.ContentLength = $bodyBytes.Length
        
        $reqStream = $request.GetRequestStream()
        $reqStream.Write($bodyBytes, 0, $bodyBytes.Length)
        $reqStream.Close()

        $response = $request.GetResponse()
        $statusCode = [int]$response.StatusCode
        $response.Close()

        if ($statusCode -eq 200) {
            Write-Host "[成功 200 OK] URL 提交成功！" -ForegroundColor Green
        } elseif ($statusCode -eq 202) {
            Write-Host "[已接受 202 Accepted] 请求排队等待处理！" -ForegroundColor Green
        } else {
            Write-Host "[状态码 $statusCode]" -ForegroundColor Yellow
        }
    } catch [System.Net.WebException] {
        $exResp = $_.Exception.Response
        if ($exResp) {
            $code = [int]$exResp.StatusCode
            Write-Host "[响应状态: $code - $($_.Exception.Message)]" -ForegroundColor Yellow
        } else {
            Write-Host "[连接异常: $($_.Exception.Message)]" -ForegroundColor Red
        }
    } catch {
        Write-Host "[执行错误: $($_.Exception.Message)]" -ForegroundColor Red
    }
}

Write-Host ""
Write-Host "[3/3] 任务执行总结" -ForegroundColor White
Write-Host "已向各大搜索引擎发出实时收录信号。" -ForegroundColor Green
Write-Host "请确保网站根目录下的验证密钥文件可通过以下链接公开访问:" -ForegroundColor Gray
Write-Host "  -> $keyLocation" -ForegroundColor Cyan
Write-Host "==========================================================" -ForegroundColor Cyan