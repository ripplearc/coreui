# Check if gh CLI is installed
if (!(Get-Command gh -ErrorAction SilentlyContinue)) {
    Write-Host "GitHub CLI (gh) is not installed. Please install it first:"
    Write-Host "https://cli.github.com/"
    exit 1
}

# Check if user is authenticated
try {
    gh auth status | Out-Null
} catch {
    Write-Host "Please login to GitHub first using: gh auth login"
    exit 1
}

# Get the latest workflow run ID for the Golden Tests workflow
Write-Host "Finding latest golden test workflow run..."
$runId = gh run list --workflow=golden_test.yml --limit=1 --json databaseId --jq ".[0].databaseId"

if (!$runId) {
    Write-Host "No workflow runs found"
    exit 1
}

# Create goldens directory if it doesn't exist
New-Item -ItemType Directory -Force -Path "test\goldens" | Out-Null

# Download the artifacts
Write-Host "Downloading golden images from run ID: $runId"
gh run download $runId --name golden-images

# Move files to the correct location
Write-Host "Moving files to test/goldens directory..."
Get-ChildItem -Recurse -Filter "*.png" | ForEach-Object {
    Move-Item $_.FullName -Destination "test\goldens\" -Force
}

# Clean up
Remove-Item -Recurse -Force "golden-images" -ErrorAction SilentlyContinue

Write-Host "Golden images have been downloaded to test\goldens\" 