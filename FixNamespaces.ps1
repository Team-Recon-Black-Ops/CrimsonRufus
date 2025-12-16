# Fix Rubeus to CrimsonRufus namespace conversion
$ErrorActionPreference = "Stop"
$rootPath = "C:\Tools\CrimsonRufus\Rubeus"

Write-Host "Fixing namespaces: Rubeus -> CrimsonRufus" -ForegroundColor Green

$files = Get-ChildItem -Path $rootPath -Recurse -Filter "*.cs" -File
$successCount = 0
$errorCount = 0

foreach ($file in $files) {
    try {
        $content = [System.IO.File]::ReadAllText($file.FullName, [System.Text.UTF8Encoding]::new($false))
        $originalContent = $content
        
        # Replace namespace declarations
        $content = $content -replace '\bnamespace Rubeus\b', 'namespace CrimsonRufus'
        
        # Replace using statements (including static)
        $content = $content -replace '\busing Rubeus\b', 'using CrimsonRufus'
        $content = $content -replace '\busing static Rubeus\.', 'using static CrimsonRufus.'
        
        # Replace qualified type references (Rubeus.Something)
        $content = $content -replace '\bRubeus\.', 'CrimsonRufus.'
        
        if ($content -ne $originalContent) {
            # Try to write, handle locked files
            $retries = 0
            $written = $false
            while (-not $written -and $retries -lt 5) {
                try {
                    [System.IO.File]::WriteAllText($file.FullName, $content, [System.Text.UTF8Encoding]::new($false))
                    $written = $true
                    $successCount++
                    Write-Host "  ✓ $($file.Name)" -ForegroundColor Green
                }
                catch {
                    $retries++
                    if ($retries -lt 5) {
                        Start-Sleep -Milliseconds 100
                    }
                    else {
                        Write-Host "  ✗ $($file.Name) - Locked" -ForegroundColor Yellow
                        $errorCount++
                    }
                }
            }
        }
    }
    catch {
        Write-Host "  ✗ $($file.Name) - Error: $_" -ForegroundColor Red
        $errorCount++
    }
}

Write-Host "`nSummary:" -ForegroundColor Cyan
Write-Host "  Success: $successCount files" -ForegroundColor Green
Write-Host "  Errors:  $errorCount files" -ForegroundColor Yellow

if ($errorCount -gt 0) {
    Write-Host "`nNote: Some files may be locked. Please close all editors and run this script again." -ForegroundColor Yellow
}
