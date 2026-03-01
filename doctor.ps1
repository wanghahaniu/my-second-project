# ========================================
# Environment Check Script - doctor.ps1
# Purpose: Check environment and tools for project
# ========================================

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  Environment Check Started" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

$allChecks = @()

# ========================================
# 1. Git Version Check
# ========================================
Write-Host "[1/6] Checking Git..." -ForegroundColor Yellow
try {
    $gitVersion = git --version 2>&1
    if ($LASTEXITCODE -eq 0) {
        Write-Host "  [OK] Git installed: $gitVersion" -ForegroundColor Green
        $allChecks += @{Name="Git"; Status="OK"; Info=$gitVersion}
    } else {
        throw "Git not found"
    }
} catch {
    Write-Host "  [FAIL] Git not installed or not in PATH" -ForegroundColor Red
    $allChecks += @{Name="Git"; Status="FAIL"; Info="Not installed"}
}
Write-Host ""

# ========================================
# 2. Node.js Version Check
# ========================================
Write-Host "[2/6] Checking Node.js..." -ForegroundColor Yellow
try {
    $nodeVersion = node --version 2>&1
    if ($LASTEXITCODE -eq 0) {
        Write-Host "  [OK] Node.js installed: $nodeVersion" -ForegroundColor Green
        $allChecks += @{Name="Node.js"; Status="OK"; Info=$nodeVersion}
    } else {
        throw "Node.js not found"
    }
} catch {
    Write-Host "  [FAIL] Node.js not installed or not in PATH" -ForegroundColor Red
    Write-Host "  Download: https://nodejs.org/" -ForegroundColor Cyan
    $allChecks += @{Name="Node.js"; Status="FAIL"; Info="Not installed"}
}
Write-Host ""

# ========================================
# 3. npm Version Check
# ========================================
Write-Host "[3/6] Checking npm..." -ForegroundColor Yellow
try {
    $npmVersion = npm --version 2>&1
    if ($LASTEXITCODE -eq 0) {
        Write-Host "  [OK] npm installed: $npmVersion" -ForegroundColor Green
        $allChecks += @{Name="npm"; Status="OK"; Info=$npmVersion}
    } else {
        throw "npm not found"
    }
} catch {
    Write-Host "  [FAIL] npm not installed or not in PATH" -ForegroundColor Red
    $allChecks += @{Name="npm"; Status="FAIL"; Info="Not installed"}
}
Write-Host ""

# ========================================
# 4. Port 3001 Check
# ========================================
Write-Host "[4/6] Checking port 3001..." -ForegroundColor Yellow
$targetPort = 3001
try {
    $portInUse = Get-NetTCPConnection -LocalPort $targetPort -ErrorAction SilentlyContinue
    if ($portInUse) {
        Write-Host "  [WARN] Port $targetPort is in use" -ForegroundColor Yellow
        Write-Host "  Process info:" -ForegroundColor Cyan
        $portInUse | ForEach-Object {
            $process = Get-Process -Id $_.OwningProcess -ErrorAction SilentlyContinue
            if ($process) {
                Write-Host "    - PID: $($_.OwningProcess) | Process: $($process.ProcessName)" -ForegroundColor Cyan
            }
        }
        $allChecks += @{Name="Port $targetPort"; Status="WARN"; Info="In use"}
    } else {
        Write-Host "  [OK] Port $targetPort is available" -ForegroundColor Green
        $allChecks += @{Name="Port $targetPort"; Status="OK"; Info="Available"}
    }
} catch {
    Write-Host "  [WARN] Cannot check port (may need admin rights)" -ForegroundColor Yellow
    $allChecks += @{Name="Port $targetPort"; Status="WARN"; Info="Cannot check"}
}
Write-Host ""

# ========================================
# 5. Network Connectivity Check
# ========================================
Write-Host "[5/6] Checking network..." -ForegroundColor Yellow
try {
    $testConnection = Test-Connection -ComputerName "www.baidu.com" -Count 1 -Quiet -ErrorAction SilentlyContinue
    if ($testConnection) {
        Write-Host "  [OK] Network connection is working" -ForegroundColor Green
        $allChecks += @{Name="Network"; Status="OK"; Info="Working"}
    } else {
        Write-Host "  [WARN] Network connection issue" -ForegroundColor Yellow
        $allChecks += @{Name="Network"; Status="WARN"; Info="Issue"}
    }
} catch {
    Write-Host "  [WARN] Cannot test network" -ForegroundColor Yellow
    $allChecks += @{Name="Network"; Status="WARN"; Info="Cannot test"}
}
Write-Host ""

# ========================================
# 6. Project Files Check
# ========================================
Write-Host "[6/6] Checking project files..." -ForegroundColor Yellow
$requiredFiles = @(
    "my-first-backend/server.js",
    "README.md"
)

$missingFiles = @()
foreach ($file in $requiredFiles) {
    if (Test-Path $file) {
        Write-Host "  [OK] $file" -ForegroundColor Green
    } else {
        Write-Host "  [FAIL] $file (missing)" -ForegroundColor Red
        $missingFiles += $file
    }
}

if ($missingFiles.Count -eq 0) {
    $allChecks += @{Name="Project Files"; Status="OK"; Info="Complete"}
} else {
    $allChecks += @{Name="Project Files"; Status="FAIL"; Info="Missing $($missingFiles.Count) files"}
}
Write-Host ""

# ========================================
# Summary Report
# ========================================
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  Check Results Summary" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan

$okCount = ($allChecks | Where-Object { $_.Status -eq "OK" }).Count
$warnCount = ($allChecks | Where-Object { $_.Status -eq "WARN" }).Count
$failCount = ($allChecks | Where-Object { $_.Status -eq "FAIL" }).Count

Write-Host ""
Write-Host "[OK] Passed: $okCount items" -ForegroundColor Green
Write-Host "[WARN] Warning: $warnCount items" -ForegroundColor Yellow
Write-Host "[FAIL] Failed: $failCount items" -ForegroundColor Red
Write-Host ""

if ($failCount -eq 0) {
    Write-Host "Environment check passed! Ready to proceed." -ForegroundColor Green
} else {
    Write-Host "Environment issues found. Please fix failed items." -ForegroundColor Yellow
}

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
