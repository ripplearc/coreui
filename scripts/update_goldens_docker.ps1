# Update golden files using Docker to match CI environment (ubuntu-24.04)
# Uses existing docker-compose.yaml setup
#
# Usage:
#   .\scripts\update_goldens_docker.ps1 test/components/tooltips/tooltip_golden_test.dart  # Update specific file
#   .\scripts\update_goldens_docker.ps1 --all                                              # Update all golden tests

param(
    [Parameter(Position=0)]
    [string]$TestPath,
    [switch]$All
)

$ErrorActionPreference = "Stop"

if (-not $TestPath -and -not $All) {
    Write-Host "Usage:" -ForegroundColor Yellow
    Write-Host "  .\scripts\update_goldens_docker.ps1 <test_file_path>   # Update specific file" -ForegroundColor White
    Write-Host "  .\scripts\update_goldens_docker.ps1 --all              # Update all golden tests" -ForegroundColor White
    Write-Host ""
    Write-Host "Example:" -ForegroundColor Yellow
    Write-Host "  .\scripts\update_goldens_docker.ps1 test/components/tooltips/tooltip_golden_test.dart" -ForegroundColor White
    exit 1
}

if ($All) {
    Write-Host "Updating ALL golden files..." -ForegroundColor Cyan
    $testCommand = "flutter test --update-goldens test/components/* ; flutter test --update-goldens test/theme/* ; flutter test --update-goldens test/notifications/*"
} else {
    # Convert Windows path separators to Linux
    $TestPath = $TestPath -replace '\\', '/'
    Write-Host "Updating golden files for: $TestPath" -ForegroundColor Cyan
    $testCommand = "flutter test --update-goldens $TestPath"
}

Write-Host "Using docker-compose (Ubuntu 24.04, Flutter 3.32.0)..." -ForegroundColor Cyan

# Build the image if needed and run the test command
docker compose run --rm flutter bash -c "$testCommand"

if ($LASTEXITCODE -eq 0) {
    Write-Host "`nGolden files updated successfully!" -ForegroundColor Green
    Write-Host "Don't forget to commit the updated golden images:" -ForegroundColor Yellow
    Write-Host "  git add test/**/goldens/*.png" -ForegroundColor White
    Write-Host "  git commit -m 'chore: update golden files from Docker (Linux)'" -ForegroundColor White
} else {
    Write-Host "`nDocker command failed. Make sure Docker Desktop is running." -ForegroundColor Red
}

