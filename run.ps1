# ========================================
# Run Script - run.ps1
# Purpose: Start the backend server
# ========================================

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  Starting Backend Server" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Check if Node.js is available
$nodeExists = Get-Command node -ErrorAction SilentlyContinue
if (-not $nodeExists) {
    Write-Host "[FAIL] Node.js not found. Please run .\doctor.ps1 first." -ForegroundColor Red
    exit 1
}

# Check if server.js exists
if (-not (Test-Path "my-first-backend/server.js")) {
    Write-Host "[FAIL] server.js not found in my-first-backend/" -ForegroundColor Red
    exit 1
}

# Check if port 3001 is in use
$portInUse = Get-NetTCPConnection -LocalPort 3001 -ErrorAction SilentlyContinue
if ($portInUse) {
    Write-Host "[WARN] Port 3001 is already in use!" -ForegroundColor Yellow
    Write-Host "Process using port 3001:" -ForegroundColor Cyan
    $portInUse | ForEach-Object {
        $process = Get-Process -Id $_.OwningProcess -ErrorAction SilentlyContinue
        if ($process) {
            Write-Host "  - PID: $($_.OwningProcess) | Process: $($process.ProcessName)" -ForegroundColor Cyan
        }
    }
    Write-Host ""
    Write-Host "Please stop the process or change the port in server.js" -ForegroundColor Yellow
    exit 1
}

Write-Host "[INFO] Starting server on http://localhost:3001" -ForegroundColor Green
Write-Host ""
Write-Host "Available endpoints:" -ForegroundColor Cyan
Write-Host "  - http://localhost:3001/" -ForegroundColor White
Write-Host "  - http://localhost:3001/hello" -ForegroundColor White
Write-Host "  - http://localhost:3001/api/time" -ForegroundColor White
Write-Host "  - http://localhost:3001/api/echo?name=test" -ForegroundColor White
Write-Host ""
Write-Host "Press Ctrl+C to stop the server" -ForegroundColor Yellow
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Start the server
node my-first-backend/server.js
