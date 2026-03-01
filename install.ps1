# ========================================
# Installation Script - install.ps1
# Purpose: Prepare project environment (idempotent)
# ========================================

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  Project Installation" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# ========================================
# 1. Check Prerequisites
# ========================================
Write-Host "[1/3] Checking prerequisites..." -ForegroundColor Yellow

$nodeExists = Get-Command node -ErrorAction SilentlyContinue
if (-not $nodeExists) {
    Write-Host "  [FAIL] Node.js not found. Please install from https://nodejs.org/" -ForegroundColor Red
    exit 1
}

Write-Host "  [OK] Node.js found: $(node --version)" -ForegroundColor Green
Write-Host ""

# ========================================
# 2. Create .env.example (if not exists)
# ========================================
Write-Host "[2/3] Creating .env.example..." -ForegroundColor Yellow

$envExamplePath = ".env.example"
if (Test-Path $envExamplePath) {
    Write-Host "  [SKIP] .env.example already exists" -ForegroundColor Cyan
} else {
    $envContent = @"
# Environment Variables Example
# Copy this file to .env and fill in your values

# Server Configuration
PORT=3001
HOST=localhost

# Application Settings
NODE_ENV=development

# Add your API keys and secrets here
# API_KEY=your_api_key_here
# DATABASE_URL=your_database_url_here
"@

    Set-Content -Path $envExamplePath -Value $envContent -Encoding UTF8
    Write-Host "  [OK] Created .env.example" -ForegroundColor Green
}
Write-Host ""

# ========================================
# 3. Verify Project Structure
# ========================================
Write-Host "[3/3] Verifying project structure..." -ForegroundColor Yellow

$requiredFiles = @(
    "my-first-backend/server.js",
    "README.md"
)

$allFilesExist = $true
foreach ($file in $requiredFiles) {
    if (Test-Path $file) {
        Write-Host "  [OK] $file" -ForegroundColor Green
    } else {
        Write-Host "  [FAIL] $file is missing" -ForegroundColor Red
        $allFilesExist = $false
    }
}

if (-not $allFilesExist) {
    Write-Host ""
    Write-Host "  [ERROR] Some required files are missing!" -ForegroundColor Red
    exit 1
}

Write-Host ""

# ========================================
# Installation Complete
# ========================================
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  Installation Complete!" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Next steps:" -ForegroundColor Cyan
Write-Host "  1. Run: .\run.ps1" -ForegroundColor White
Write-Host "  2. Open browser: http://localhost:3001" -ForegroundColor White
Write-Host ""
Write-Host "Note: This project uses Node.js core modules only." -ForegroundColor Yellow
Write-Host "      No npm install needed!" -ForegroundColor Yellow
Write-Host ""
