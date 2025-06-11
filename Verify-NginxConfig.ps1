# Nginx Configuration Validator
# This script validates the Nginx configuration and helps identify errors

<#
.SYNOPSIS
Validates Nginx configuration files for Docker deployment.

.DESCRIPTION
This script creates a temporary Docker container to verify the Nginx configuration
without actually starting the server. It helps identify configuration errors
before deploying the application.

.PARAMETER ConfigFile
The path to the Nginx configuration file to validate.
Default is "./nginx.conf".

.EXAMPLE
.\Verify-NginxConfig.ps1
.\Verify-NginxConfig.ps1 -ConfigFile "./custom-nginx.conf"
#>

param (
    [Parameter(Mandatory=$false)]
    [string]$ConfigFile = "./nginx.conf"
)

# Function to display formatted output
function Write-Colored {
    param (
        [Parameter(Mandatory=$true)]
        [string]$Message,
        
        [Parameter(Mandatory=$false)]
        [string]$ForegroundColor = "White"
    )
    
    Write-Host $Message -ForegroundColor $ForegroundColor
}

# Header
Write-Colored "=== Nginx Configuration Validator ===" -ForegroundColor Cyan
Write-Colored ""

# Check if Docker is running
try {
    $null = docker info 2>&1
    if ($LASTEXITCODE -ne 0) {
        Write-Colored "Docker is not running! Please start Docker Desktop and try again." -ForegroundColor Red
        exit 1
    }
} catch {
    Write-Colored "Docker is not available! Please install Docker Desktop and try again." -ForegroundColor Red
    exit 1
}

# Check if config file exists
if (-not (Test-Path $ConfigFile)) {
    Write-Colored "Configuration file not found: $ConfigFile" -ForegroundColor Red
    exit 1
}

# Create a temporary directory with the configuration
$tempDir = Join-Path $env:TEMP "nginx-config-test-$(Get-Random)"
New-Item -ItemType Directory -Force -Path $tempDir | Out-Null

# Copy the configuration file to the temporary directory
Copy-Item $ConfigFile -Destination (Join-Path $tempDir "default.conf") -Force

Write-Colored "Validating Nginx configuration..." -ForegroundColor Yellow

# Run a temporary Nginx container to validate the configuration
$result = docker run --rm -v "${tempDir}:/etc/nginx/conf.d" nginx:alpine nginx -t 2>&1

# Display the result
if ($LASTEXITCODE -eq 0) {
    Write-Colored "✓ Configuration is valid!" -ForegroundColor Green
    Write-Colored $result -ForegroundColor Gray
} else {
    Write-Colored "✗ Configuration has errors!" -ForegroundColor Red
    
    # Try to parse the error message in more detail
    $errorMessage = $result -join "`n"
    
    # Extract the line number if available
    if ($errorMessage -match "in\s+\/etc\/nginx\/conf\.d\/default\.conf:(\d+)") {
        $lineNum = $Matches[1]
        Write-Colored "Error on line $lineNum of the configuration file:" -ForegroundColor Yellow
        
        # Display the problematic line and its context
        $configContent = Get-Content $ConfigFile
        $startLine = [Math]::Max(1, [int]$lineNum - 3)
        $endLine = [Math]::Min($configContent.Count, [int]$lineNum + 3)
        
        for ($i = $startLine - 1; $i -lt $endLine; $i++) {
            if ($i + 1 -eq [int]$lineNum) {
                Write-Colored ("Line {0}: {1}" -f ($i + 1), $configContent[$i]) -ForegroundColor Red
            } else {
                Write-Colored ("Line {0}: {1}" -f ($i + 1), $configContent[$i]) -ForegroundColor Gray
            }
        }
    }
    
    Write-Colored "`nError details:" -ForegroundColor Yellow
    Write-Colored $errorMessage -ForegroundColor Gray
}

# Clean up temporary directory
Remove-Item -Path $tempDir -Recurse -Force -ErrorAction SilentlyContinue

Write-Colored "`nDone!" -ForegroundColor Cyan
