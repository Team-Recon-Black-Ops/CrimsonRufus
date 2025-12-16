# Build CrimsonRufus project
$ErrorActionPreference = "Stop"

$solutionPath = "$PSScriptRoot\CrimsonRufus.sln"
$outputPath = "$PSScriptRoot\CrimsonRufus\bin\Debug\CrimsonRufus.exe"

Write-Host "Building CrimsonRufus..." -ForegroundColor Cyan

try {
    dotnet build $solutionPath
    
    if ($LASTEXITCODE -eq 0) {
        Write-Host "`nBuild succeeded!" -ForegroundColor Green
        Write-Host "Output: $outputPath" -ForegroundColor Green
    }
    else {
        Write-Host "`nBuild failed with exit code $LASTEXITCODE" -ForegroundColor Red
        exit $LASTEXITCODE
    }
}
catch {
    Write-Host "`nBuild failed: $_" -ForegroundColor Red
    exit 1
}
