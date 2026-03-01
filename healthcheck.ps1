# ========================================
# Health Check Script - healthcheck.ps1
# Purpose: Verify server is running correctly
# ========================================

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  Server Health Check" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

$baseUrl = "http://localhost:3001"
$allPassed = $true

# ========================================
# 1. Check if port is listening
# ========================================
Write-Host "[1/4] Checking if server is running..." -ForegroundColor Yellow
$portInUse = Get-NetTCPConnection -LocalPort 3001 -State Listen -ErrorAction SilentlyContinue
if ($portInUse) {
    Write-Host "  [OK] Server is listening on port 3001" -ForegroundColor Green
} else {
    Write-Host "  [FAIL] Server is not running on port 3001" -ForegroundColor Red
    Write-Host "  Please start the server with: .\run.ps1" -ForegroundColor Yellow
    $allPassed = $false
}
Write-Host ""

# ========================================
# 2. Test root endpoint
# ========================================
Write-Host "[2/4] Testing root endpoint (/)..." -ForegroundColor Yellow
try {
    $response = Invoke-WebRequest -Uri "$baseUrl/" -UseBasicParsing -TimeoutSec 5
    if ($response.StatusCode -eq 200) {
        Write-Host "  [OK] Root endpoint responded with 200" -ForegroundColor Green
    } else {
        Write-Host "  [WARN] Unexpected status code: $($response.StatusCode)" -ForegroundColor Yellow
    }
} catch {
    Write-Host "  [FAIL] Cannot reach root endpoint" -ForegroundColor Red
    Write-Host "  Error: $($_.Exception.Message)" -ForegroundColor Red
    $allPassed = $false
}
Write-Host ""

# ========================================
# 3. Test /api/time endpoint
# ========================================
Write-Host "[3/4] Testing /api/time endpoint..." -ForegroundColor Yellow
try {
    $response = Invoke-WebRequest -Uri "$baseUrl/api/time" -UseBasicParsing -TimeoutSec 5
    if ($response.StatusCode -eq 200) {
        $json = $response.Content | ConvertFrom-Json
        if ($json.ok -eq $true -and $json.now) {
            Write-Host "  [OK] /api/time returned valid JSON" -ForegroundColor Green
            Write-Host "  Server time: $($json.iso)" -ForegroundColor Cyan
        } else {
            Write-Host "  [WARN] Response format unexpected" -ForegroundColor Yellow
        }
    }
} catch {
    Write-Host "  [FAIL] Cannot reach /api/time" -ForegroundColor Red
    $allPassed = $false
}
Write-Host ""

# ========================================
# 4. Test /api/echo endpoint
# ========================================
Write-Host "[4/4] Testing /api/echo endpoint..." -ForegroundColor Yellow
try {
    $response = Invoke-WebRequest -Uri "$baseUrl/api/echo?test=hello" -UseBasicParsing -TimeoutSec 5
    if ($response.StatusCode -eq 200) {
        $json = $response.Content | ConvertFrom-Json
        if ($json.ok -eq $true -and $json.query.test -eq "hello") {
            Write-Host "  [OK] /api/echo returned correct query params" -ForegroundColor Green
        } else {
            Write-Host "  [WARN] Response format unexpected" -ForegroundColor Yellow
        }
    }
} catch {
    Write-Host "  [FAIL] Cannot reach /api/echo" -ForegroundColor Red
    $allPassed = $false
}
Write-Host ""

# ========================================
# Summary
# ========================================
Write-Host "========================================" -ForegroundColor Cyan
if ($allPassed) {
    Write-Host "  Health Check: PASSED" -ForegroundColor Green
    Write-Host "  Server is running correctly!" -ForegroundColor Green
} else {
    Write-Host "  Health Check: FAILED" -ForegroundColor Red
    Write-Host "  Please check the errors above" -ForegroundColor Yellow
}
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""
