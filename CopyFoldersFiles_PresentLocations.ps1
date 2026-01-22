# Created:  12.31.25  
# Define paths
# Dynamic Source: Uses Get-Location so it always targets the folder where you run the script

$SourcePath = Get-Location
$DestinationPath = "C:\PCData"
$LogFolder = "C:\applog"
$LogFile = "$LogFolder\CopyLog.txt"

# 1. Ensure Log Folder exists
#    Safety Checks: It uses Test-Path to see if folders exist before attempting to create them
if (!(Test-Path -Path $LogFolder)) {
    New-Item -ItemType Directory -Path $LogFolder | Out-Null
}

# Helper function for logging with timestamp
function Write-Log {
    param([string]$Message)
    $TimeStamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $LogEntry = "[$TimeStamp] $Message"
    Add-Content -Path $LogFile -Value $LogEntry
    Write-Host $LogEntry # Also shows in console
}

Write-Log "--- Starting Copy Process ---"
Write-Log "Source: $SourcePath"

# 2. Ensure Destination Folder exists
if (!(Test-Path -Path $DestinationPath)) {
    Write-Log "Destination folder not found. Creating: $DestinationPath"
    New-Item -ItemType Directory -Path $DestinationPath | Out-Null
}

# 3. Perform the Copy
#    Error Handling: Includes a try/catch block so that if a file is locked 
#    or a permission error occurs, it is recorded in your log rather than just crashing

try {
    Write-Log "Copying files and folders..."
    
    # -Recurse copies subdirectories; -Force overwrites existing files
    Copy-Item -Path "$SourcePath\*" -Destination $DestinationPath -Recurse -Force -ErrorAction Stop
    
    Write-Log "Success: All items copied to $DestinationPath."
}
catch {
    Write-Log "ERROR: Failed to copy items. Details: $($_.Exception.Message)"
}

Write-Log "--- Process Finished ---"
