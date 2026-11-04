# Exam Tracker - Lightweight PowerShell Local Server
# Runs natively on all modern Windows installations without needing Node.js or admin rights.

param(
    [int]$Port = 3000
)

$ErrorActionPreference = "SilentlyContinue"
$root = $PSScriptRoot
if (-not $root) { $root = Get-Location }
$dataFile = Join-Path $root "data.json"

$mimeTypes = @{
    ".html"  = "text/html; charset=utf-8"
    ".js"    = "text/javascript"
    ".css"   = "text/css"
    ".json"  = "application/json"
    ".woff2" = "font/woff2"
    ".svg"   = "image/svg+xml"
    ".ico"   = "image/x-icon"
    ".png"   = "image/png"
}

$listener = New-Object System.Net.HttpListener
$prefix = "http://127.0.0.1:$Port/"
$listener.Prefixes.Add($prefix)

try {
    $listener.Start()
} catch {
    Write-Error "Failed to start listener on $($prefix): $_"
    exit 1
}

$lastPing = [DateTime]::UtcNow
$byeReceived = $false
$byeTime = [DateTime]::MinValue

while ($listener.IsListening) {
    # Check timeout: Auto-stop if inactive for 150 seconds
    $now = [DateTime]::UtcNow
    if (($now - $lastPing).TotalSeconds -gt 150) {
        break
    }
    # If app window sent bye, exit after 4 second grace period
    if ($byeReceived -and ($now - $byeTime).TotalSeconds -gt 4) {
        break
    }

    $asyncResult = $listener.BeginGetContext($null, $null)
    $waitHandles = @($asyncResult.AsyncWaitHandle)
    $index = [System.Threading.WaitHandle]::WaitAny($waitHandles, 1000)

    if ($index -ne 0) {
        continue
    }

    try {
        $context = $listener.EndGetContext($asyncResult)
    } catch {
        continue
    }

    $request = $context.Request
    $response = $context.Response

    $urlPath = [System.Uri]::UnescapeDataString($request.Url.AbsolutePath)

    try {
        # Ping endpoint
        if ($urlPath -eq "/api/ping") {
            $lastPing = [DateTime]::UtcNow
            $buf = [System.Text.Encoding]::UTF8.GetBytes("ok")
            $response.ContentType = "text/plain"
            $response.ContentLength64 = $buf.Length
            $response.OutputStream.Write($buf, 0, $buf.Length)
            $response.OutputStream.Flush()
            $response.Close()
            continue
        }

        # Bye endpoint (when browser window closes)
        if ($urlPath -eq "/api/bye") {
            $byeReceived = $true
            $byeTime = [DateTime]::UtcNow
            $buf = [System.Text.Encoding]::UTF8.GetBytes("ok")
            $response.ContentType = "text/plain"
            $response.ContentLength64 = $buf.Length
            $response.OutputStream.Write($buf, 0, $buf.Length)
            $response.OutputStream.Flush()
            $response.Close()
            continue
        }

        # Data endpoint: GET / PUT / POST
        if ($urlPath -eq "/api/data") {
            if ($request.HttpMethod -eq "GET") {
                $content = if (Test-Path $dataFile) { [System.IO.File]::ReadAllText($dataFile) } else { '{"items":null}' }
                $buf = [System.Text.Encoding]::UTF8.GetBytes($content)
                $response.ContentType = "application/json"
                $response.ContentLength64 = $buf.Length
                $response.OutputStream.Write($buf, 0, $buf.Length)
                $response.OutputStream.Flush()
                $response.Close()
                continue
            }
            if ($request.HttpMethod -in @("PUT", "POST")) {
                $reader = New-Object System.IO.StreamReader($request.InputStream, $request.ContentEncoding)
                $body = $reader.ReadToEnd()
                $reader.Close()

                $isValid = $false
                try {
                    $json = $body | ConvertFrom-Json
                    if ($json.items -ne $null) { $isValid = $true }
                } catch { $isValid = $false }

                if ($isValid) {
                    $tmp = "$dataFile.tmp"
                    [System.IO.File]::WriteAllText($tmp, $body)
                    Move-Item -Path $tmp -Destination $dataFile -Force
                    $buf = [System.Text.Encoding]::UTF8.GetBytes('{"ok":true}')
                    $response.ContentType = "application/json"
                    $response.ContentLength64 = $buf.Length
                    $response.OutputStream.Write($buf, 0, $buf.Length)
                } else {
                    $response.StatusCode = 400
                    $buf = [System.Text.Encoding]::UTF8.GetBytes('{"ok":false}')
                    $response.ContentType = "application/json"
                    $response.ContentLength64 = $buf.Length
                    $response.OutputStream.Write($buf, 0, $buf.Length)
                }
                $response.OutputStream.Flush()
                $response.Close()
                continue
            }
        }

        # Static files
        $relPath = if ($urlPath -eq "/" -or [string]::IsNullOrWhiteSpace($urlPath)) { "index.html" } else { $urlPath.TrimStart("/") }
        $filePath = [System.IO.Path]::GetFullPath((Join-Path $root $relPath))

        if (-not $filePath.StartsWith($root, [System.StringComparison]::OrdinalIgnoreCase) -or
            (Split-Path $filePath -Leaf) -in @("server.js", "server.ps1") -or
            -not (Test-Path $filePath -PathType Leaf)) {
            $response.StatusCode = 404
            $buf = [System.Text.Encoding]::UTF8.GetBytes("Not found")
            $response.ContentType = "text/plain"
            $response.ContentLength64 = $buf.Length
            $response.OutputStream.Write($buf, 0, $buf.Length)
            $response.OutputStream.Flush()
            $response.Close()
            continue
        }

        $ext = [System.IO.Path]::GetExtension($filePath).ToLower()
        $contentType = if ($mimeTypes.ContainsKey($ext)) { $mimeTypes[$ext] } else { "application/octet-stream" }
        $bytes = [System.IO.File]::ReadAllBytes($filePath)
        $response.ContentType = $contentType
        $response.ContentLength64 = $bytes.Length
        $response.OutputStream.Write($bytes, 0, $bytes.Length)
        $response.OutputStream.Flush()
        $response.Close()
    } catch {
        try {
            $response.StatusCode = 500
            $response.Close()
        } catch {}
    }
}

try {
    $listener.Stop()
    $listener.Close()
} catch {}
