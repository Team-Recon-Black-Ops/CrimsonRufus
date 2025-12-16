# PowerShell Script to rename CrimsonRufus to CrimsonRufus throughout the project
# This script will:
# 1. Replace all text occurrences in files
# 2. Rename files containing "CrimsonRufus" in their name
# 3. Rename the CrimsonRufus directory to CrimsonRufus

$ErrorActionPreference = "Continue"
$rootPath = "C:\Tools\CrimsonRufus"

Write-Host "Starting CrimsonRufus to CrimsonRufus conversion..." -ForegroundColor Green
Write-Host ""

# Step 1: Replace text in all relevant files
Write-Host "Step 1: Replacing text occurrences in files..." -ForegroundColor Yellow

$fileExtensions = @("*.cs", "*.csproj", "*.sln", "*.config", "*.md", "*.yar", "*.ps1")
$allFiles = @()

foreach ($ext in $fileExtensions) {
    $allFiles += Get-ChildItem -Path $rootPath -Recurse -Filter $ext -File -ErrorAction SilentlyContinue
}

Write-Host "Found $($allFiles.Count) files to process"

$filesChanged = 0
$failedFiles = @()

foreach ($file in $allFiles) {
    try {
        $content = Get-Content $file.FullName -Raw -Encoding UTF8
        
        if ($content -match "CrimsonRufus") {
            Write-Host "  Processing: $($file.Name)" -ForegroundColor Cyan
            
            # Replace all occurrences of CrimsonRufus with CrimsonRufus
            $newContent = $content -replace "CrimsonRufus", "CrimsonRufus"
            
            # Try to save with UTF8 encoding (try-catch for locked files)
            try {
                $fileStream = [System.IO.File]::Open($file.FullName, [System.IO.FileMode]::Create, [System.IO.FileAccess]::Write, [System.IO.FileShare]::None)
                $writer = New-Object System.IO.StreamWriter($fileStream, [System.Text.Encoding]::UTF8)
                $writer.Write($newContent)
                $writer.Close()
                $fileStream.Close()
                $filesChanged++
            }
            catch {
                Write-Host "    LOCKED: File is in use" -ForegroundColor Yellow
                $failedFiles += $file.FullName
            }
        }
    }
    catch {
        Write-Host "  ERROR: $($file.Name) - $($_.Exception.Message)" -ForegroundColor Red
    }
}

Write-Host ""
Write-Host "Modified $filesChanged files" -ForegroundColor Green
if ($failedFiles.Count -gt 0) {
    Write-Host "Failed to modify $($failedFiles.Count) files (locked by editor):" -ForegroundColor Yellow
    foreach ($failed in $failedFiles) {
        Write-Host "  - $($failed -replace [regex]::Escape($rootPath), '.')" -ForegroundColor Yellow
    }
}
Write-Host ""

# Step 2: Rename files containing "CrimsonRufus" in their name
Write-Host "Step 2: Renaming files..." -ForegroundColor Yellow

$filesToRename = Get-ChildItem -Path $rootPath -Recurse -File | Where-Object { $_.Name -match "CrimsonRufus" }
$renamedCount = 0

foreach ($file in $filesToRename) {
    try {
        $newName = $file.Name -replace "CrimsonRufus", "CrimsonRufus"
        $newPath = Join-Path $file.DirectoryName $newName
        
        Write-Host "  Renaming: $($file.Name) -> $newName" -ForegroundColor Cyan
        Rename-Item -Path $file.FullName -NewName $newName -Force
        $renamedCount++
    }
    catch {
        Write-Host "  FAILED: $($file.Name) - File may be in use" -ForegroundColor Yellow
    }
}

Write-Host "Renamed $renamedCount files" -ForegroundColor Green
Write-Host ""

# Step 3: Rename the CrimsonRufus directory to CrimsonRufus
Write-Host "Step 3: Renaming CrimsonRufus directory..." -ForegroundColor Yellow

$CrimsonRufusDir = Join-Path $rootPath "CrimsonRufus"
$CrimsonRufusDir = Join-Path $rootPath "CrimsonRufus"

if (Test-Path $CrimsonRufusDir) {
    try {
        Write-Host "  Renaming: CrimsonRufus -> CrimsonRufus" -ForegroundColor Cyan
        Rename-Item -Path $CrimsonRufusDir -NewName "CrimsonRufus" -Force
        Write-Host "  Directory renamed successfully" -ForegroundColor Green
    }
    catch {
        Write-Host "  FAILED: Cannot rename directory - files may be in use" -ForegroundColor Yellow
    }
} else {
    Write-Host "  CrimsonRufus directory not found (may already be renamed)" -ForegroundColor Yellow
}

Write-Host ""
Write-Host "========================================" -ForegroundColor Green
Write-Host "Conversion complete!" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green
Write-Host ""
Write-Host "Summary:" -ForegroundColor Cyan
Write-Host "  - $filesChanged files modified"
Write-Host "  - $renamedCount files renamed"
if (Test-Path $CrimsonRufusDir) {
    Write-Host "  - Main directory renamed to CrimsonRufus"
}
Write-Host ""

if ($failedFiles.Count -gt 0) {
    Write-Host "========================================" -ForegroundColor Yellow
    Write-Host "IMPORTANT:" -ForegroundColor Yellow
    Write-Host "========================================" -ForegroundColor Yellow
    Write-Host "Some files could not be modified because they are locked by the editor." -ForegroundColor Yellow
    Write-Host ""
    Write-Host "Please:" -ForegroundColor Yellow
    Write-Host "  1. Close VS Code completely" -ForegroundColor White
    Write-Host "  2. Run this script again" -ForegroundColor White
    Write-Host "  3. Reopen VS Code" -ForegroundColor White
    Write-Host ""
}
else {
    Write-Host "Next steps:" -ForegroundColor Cyan
    Write-Host "  1. Close and reopen Visual Studio/VS Code"
    Write-Host "  2. Build the solution to verify everything works"
    Write-Host ""
}
