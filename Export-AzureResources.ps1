# Export-AzureResources.ps1
# Script to export all Azure resources from the active subscription
# Organizes resources by resource group folders with JSON definitions

param(
    [string]$OutputPath = ".\resources",
    [string]$SubscriptionId = "",
    [switch]$Verbose = $false
)

# Function to write colored output
function Write-ColorOutput {
    param(
        [string]$Message,
        [string]$Color = "White"
    )
    Write-Host $Message -ForegroundColor $Color
}

# Function to sanitize folder and file names
function Get-SafeName {
    param([string]$Name)
    
    # Remove or replace invalid characters for Windows file/folder names
    $safeName = $Name -replace '[<>:"/\\|?*]', '_'
    $safeName = $safeName -replace '\s+', '_'
    return $safeName
}

# Function to create directory if it doesn't exist
function Ensure-Directory {
    param([string]$Path)
    
    if (-not (Test-Path $Path)) {
        New-Item -ItemType Directory -Path $Path -Force | Out-Null
        Write-ColorOutput "Created directory: $Path" "Green"
    }
}

# Function to detect and log resource provider issues
function Test-ResourceProviderError {
    param(
        [string]$ErrorMessage,
        [string]$ResourceName,
        [string]$ResourceId,
        [string]$ResourceGroup,
        [string]$ResourceType,
        [string]$LogFilePath,
        [ref]$Counter
    )
    
    # Check for NoRegisteredProviderFound or similar API version errors
    if ($ErrorMessage -match "NoRegisteredProviderFound|No registered resource provider found|API version.*not supported|supported api-versions") {
        Write-ColorOutput "      DETECTED: Resource Provider API Version Issue" "Magenta"
        
        # Increment counter
        if ($Counter) {
            $Counter.Value++
        }
        
        # Extract API version information if available
        $apiVersionMatch = $ErrorMessage | Select-String -Pattern "API version '([^']+)'" -AllMatches
        $supportedVersionsMatch = $ErrorMessage | Select-String -Pattern "supported api-versions are '([^']+)'" -AllMatches
        $locationMatch = $ErrorMessage | Select-String -Pattern "location '([^']+)'" -AllMatches
        
        $currentApiVersion = if ($apiVersionMatch.Matches.Count -gt 0) { $apiVersionMatch.Matches[0].Groups[1].Value } else { "Unknown" }
        $supportedVersions = if ($supportedVersionsMatch.Matches.Count -gt 0) { $supportedVersionsMatch.Matches[0].Groups[1].Value } else { "Unknown" }
        $location = if ($locationMatch.Matches.Count -gt 0) { $locationMatch.Matches[0].Groups[1].Value } else { "Unknown" }
        
        # Create log entry
        $logEntry = [PSCustomObject]@{
            Timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
            ResourceName = $ResourceName
            ResourceId = $ResourceId
            ResourceGroup = $ResourceGroup
            ResourceType = $ResourceType
            Location = $location
            CurrentApiVersion = $currentApiVersion
            SupportedApiVersions = $supportedVersions
            ErrorMessage = $ErrorMessage.Trim()
            IssueType = "ResourceProviderApiVersion"
        }
        
        # Log to file (append mode)
        try {
            $logEntry | ConvertTo-Json -Compress | Add-Content -Path $LogFilePath -Encoding UTF8
            Write-ColorOutput "      Logged API version issue to: $LogFilePath" "Yellow"
        }
        catch {
            Write-ColorOutput "      WARNING: Failed to log API version issue - $($_.Exception.Message)" "Red"
        }
        
        return $true
    }
    
    return $false
}

# Function to initialize error log file
function Initialize-ErrorLogFile {
    param([string]$LogFilePath)
    
    # Create log file header if it doesn't exist
    if (-not (Test-Path $LogFilePath)) {
        $header = @"
# Azure Resource Export Issues Log
# Generated: $(Get-Date -Format "yyyy-MM-dd HH:mm:ss")
# This file contains resources that failed during export
# Each line is a JSON object with detailed error information

"@
        $header | Set-Content -Path $LogFilePath -Encoding UTF8
        Write-ColorOutput "Created error log file: $LogFilePath" "Green"
    }
}

# Function to log general resource failures
function Add-ResourceFailureLog {
    param(
        [string]$ResourceName,
        [string]$ResourceId,
        [string]$ResourceGroup,
        [string]$ResourceType,
        [string]$ErrorMessage,
        [string]$LogFilePath,
        [string]$IssueType = "GeneralFailure",
        [ref]$Counter
    )
    
    Write-ColorOutput "      LOGGING: Resource Export Failure" "Red"
    
    # Increment counter
    if ($Counter) {
        $Counter.Value++
    }
    
    # Create log entry
    $logEntry = [PSCustomObject]@{
        Timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
        ResourceName = $ResourceName
        ResourceId = $ResourceId
        ResourceGroup = $ResourceGroup
        ResourceType = $ResourceType
        ErrorMessage = $ErrorMessage.Trim()
        IssueType = $IssueType
    }
    
    # Log to file (append mode)
    try {
        $logEntry | ConvertTo-Json -Compress | Add-Content -Path $LogFilePath -Encoding UTF8
        Write-ColorOutput "      Logged failure to: $LogFilePath" "Yellow"
    }
    catch {
        Write-ColorOutput "      WARNING: Failed to log error - $($_.Exception.Message)" "Red"
    }
}

# Main script execution
try {
    Write-ColorOutput "=== Azure Resource Export Script ===" "Cyan"
    Write-ColorOutput "Starting export process..." "Yellow"
    
    # Check if Azure CLI is available and version
    try {
        Write-ColorOutput "Checking Azure CLI version..." "Yellow"
        $azVersionOutput = az version --output json 2>$null
        if ($LASTEXITCODE -ne 0) {
            throw "Azure CLI not found"
        }
        
        $azVersionInfo = $azVersionOutput | ConvertFrom-Json
        $currentVersion = $azVersionInfo.'azure-cli'
        Write-ColorOutput "Current Azure CLI version: $currentVersion" "Green"
        
        # Check for available updates
        Write-ColorOutput "Checking for Azure CLI updates..." "Yellow"
        $updateCheck = az upgrade --dry-run --output json 2>$null
        
        if ($LASTEXITCODE -eq 0 -and $updateCheck) {
            $updateInfo = $updateCheck | ConvertFrom-Json
            if ($updateInfo -and $updateInfo.PSObject.Properties.Count -gt 0) {
                # Updates are available
                Write-ColorOutput "`nWARNING: Azure CLI updates are available!" "Red"
                Write-ColorOutput "Current version: $currentVersion" "Yellow"
                Write-ColorOutput "Updates may resolve API version compatibility issues." "Yellow"
                Write-ColorOutput "Recommendation: Upgrade Azure CLI before proceeding." "Yellow"
                
                do {
                    Write-Host "`nChoose an option:" -ForegroundColor Cyan
                    Write-Host "[U] Upgrade Azure CLI now" -ForegroundColor Green
                    Write-Host "[C] Continue without upgrading" -ForegroundColor Yellow
                    Write-Host "[X] Cancel script execution" -ForegroundColor Red
                    $choice = Read-Host "Enter your choice (U/C/X)"
                    $choice = $choice.ToUpper()
                    
                    switch ($choice) {
                        "U" {
                            Write-ColorOutput "Upgrading Azure CLI..." "Yellow"
                            az upgrade --yes
                            if ($LASTEXITCODE -eq 0) {
                                Write-ColorOutput "Azure CLI upgraded successfully!" "Green"
                                # Get new version
                                $newVersionOutput = az version --output json 2>$null | ConvertFrom-Json
                                $newVersion = $newVersionOutput.'azure-cli'
                                Write-ColorOutput "New Azure CLI version: $newVersion" "Green"
                            } else {
                                Write-ColorOutput "WARNING: Azure CLI upgrade may have failed. Continuing with current version." "Red"
                            }
                            break
                        }
                        "C" {
                            Write-ColorOutput "Continuing with current Azure CLI version..." "Yellow"
                            Write-ColorOutput "Note: You may encounter API version compatibility issues." "Yellow"
                            break
                        }
                        "X" {
                            Write-ColorOutput "Script execution cancelled by user." "Red"
                            exit 0
                        }
                        default {
                            Write-ColorOutput "Invalid choice. Please enter U, C, or X." "Red"
                        }
                    }
                } while ($choice -notin @("U", "C", "X"))
            } else {
                Write-ColorOutput "Azure CLI is up to date." "Green"
            }
        } else {
            Write-ColorOutput "Could not check for updates, but Azure CLI is available." "Yellow"
        }
        
        Write-ColorOutput "Azure CLI ready for use." "Green"
    }
    catch {
        Write-ColorOutput "ERROR: Azure CLI is not installed or not in PATH" "Red"
        Write-ColorOutput "Please install Azure CLI from: https://docs.microsoft.com/en-us/cli/azure/install-azure-cli" "Yellow"
        exit 1
    }
    
    # Check authentication status and handle subscription
    Write-ColorOutput "Checking Azure authentication..." "Yellow"
    
    if ($SubscriptionId -ne "") {
        # Use provided subscription ID
        Write-ColorOutput "Setting subscription to: $SubscriptionId" "Yellow"
        az account set --subscription $SubscriptionId 2>$null
        if ($LASTEXITCODE -ne 0) {
            Write-ColorOutput "ERROR: Failed to set subscription to $SubscriptionId. Please check the subscription ID and your permissions." "Red"
            exit 1
        }
    }
    
    $accountInfo = az account show --output json 2>$null | ConvertFrom-Json
    if ($LASTEXITCODE -ne 0 -or $null -eq $accountInfo) {
        Write-ColorOutput "ERROR: Not logged in to Azure. Please run 'az login' first." "Red"
        exit 1
    }
    
    $subscriptionName = $accountInfo.name
    $subscriptionId = $accountInfo.id
    Write-ColorOutput "Active subscription: $subscriptionName ($subscriptionId)" "Green"
    
    # Create subscription-specific output directory
    $baseOutputPath = Resolve-Path $OutputPath -ErrorAction SilentlyContinue
    if (-not $baseOutputPath) {
        $baseOutputPath = Join-Path (Get-Location) $OutputPath
    }
    
    # Create subscription folder: <subscription name> (<subscription id>)
    $safeSubscriptionName = Get-SafeName $subscriptionName
    $subscriptionFolderName = "$safeSubscriptionName ($subscriptionId)"
    $subscriptionOutputPath = Join-Path $baseOutputPath $subscriptionFolderName
    Ensure-Directory $subscriptionOutputPath
    
    Write-ColorOutput "Output will be saved to: $subscriptionOutputPath" "Green"
    
    # Initialize error log file for resource provider issues
    $errorLogPath = Join-Path $subscriptionOutputPath "resource-provider-issues.log"
    Initialize-ErrorLogFile $errorLogPath
    
    # Get all resource groups
    Write-ColorOutput "Getting all resource groups..." "Yellow"
    $resourceGroups = az group list --output json | ConvertFrom-Json
    
    if ($resourceGroups.Count -eq 0) {
        Write-ColorOutput "No resource groups found in subscription." "Yellow"
        exit 0
    }
    
    Write-ColorOutput "Found $($resourceGroups.Count) resource groups" "Green"
    
    # Process each resource group
    $totalResources = 0
    $processedResources = 0
    $resourceProviderIssues = 0
    $otherFailedResources = 0
    
    foreach ($rg in $resourceGroups) {
        $rgName = $rg.name
        $safeRgName = Get-SafeName $rgName
        $rgFolderPath = Join-Path $subscriptionOutputPath $safeRgName
        
        Write-ColorOutput "`nProcessing Resource Group: $rgName" "Cyan"
        
        # Create resource group folder
        Ensure-Directory $rgFolderPath
        
        # Export resource group definition
        Write-ColorOutput "  Exporting resource group definition..." "Yellow"
        try {
            $rgDefinition = az group show --name $rgName --output json 2>&1
            if ($LASTEXITCODE -ne 0) {
                $errorMsg = $rgDefinition -join "`n"
                $isProviderIssue = Test-ResourceProviderError -ErrorMessage $errorMsg -ResourceName $rgName -ResourceId "/subscriptions/$subscriptionId/resourceGroups/$rgName" -ResourceGroup $rgName -ResourceType "Microsoft.Resources/resourceGroups" -LogFilePath $errorLogPath -Counter ([ref]$resourceProviderIssues)
                if (-not $isProviderIssue) {
                    Add-ResourceFailureLog -ResourceName $rgName -ResourceId "/subscriptions/$subscriptionId/resourceGroups/$rgName" -ResourceGroup $rgName -ResourceType "Microsoft.Resources/resourceGroups" -ErrorMessage $errorMsg -LogFilePath $errorLogPath -IssueType "ResourceGroupExportFailure" -Counter ([ref]$otherFailedResources)
                }
            } else {
                $rgFileName = "$(Get-SafeName $rgName).json"
                $rgFilePath = Join-Path $rgFolderPath $rgFileName
                $rgDefinition | Out-File -FilePath $rgFilePath -Encoding UTF8
                Write-ColorOutput "    Saved: $rgFileName" "Green"
            }
        }
        catch {
            $errorMsg = $_.Exception.Message
            $isProviderIssue = Test-ResourceProviderError -ErrorMessage $errorMsg -ResourceName $rgName -ResourceId "/subscriptions/$subscriptionId/resourceGroups/$rgName" -ResourceGroup $rgName -ResourceType "Microsoft.Resources/resourceGroups" -LogFilePath $errorLogPath -Counter ([ref]$resourceProviderIssues)
            if (-not $isProviderIssue) {
                Add-ResourceFailureLog -ResourceName $rgName -ResourceId "/subscriptions/$subscriptionId/resourceGroups/$rgName" -ResourceGroup $rgName -ResourceType "Microsoft.Resources/resourceGroups" -ErrorMessage $errorMsg -LogFilePath $errorLogPath -IssueType "ResourceGroupExportException" -Counter ([ref]$otherFailedResources)
            }
        }
        
        # Get all resources in this resource group
        Write-ColorOutput "  Getting resources in resource group..." "Yellow"
        try {
            $resources = az resource list --resource-group $rgName --output json 2>&1 | ConvertFrom-Json
            
            if ($resources.Count -eq 0) {
                Write-ColorOutput "    No resources found in $rgName" "Yellow"
                continue
            }
            
            Write-ColorOutput "    Found $($resources.Count) resources in $rgName" "Green"
            $totalResources += $resources.Count
            
            # Process each resource
            foreach ($resource in $resources) {
                try {
                    $resourceName = $resource.name
                    $resourceType = $resource.type
                    $safeResourceName = Get-SafeName $resourceName
                    
                    Write-ColorOutput "    Exporting: $resourceName ($resourceType)" "Yellow"
                    
                    # Get detailed resource definition
                    $resourceDefinition = az resource show --ids $resource.id --output json 2>&1
                    
                    if ($LASTEXITCODE -ne 0) {
                        $errorMsg = $resourceDefinition -join "`n"
                        $isProviderIssue = Test-ResourceProviderError -ErrorMessage $errorMsg -ResourceName $resourceName -ResourceId $resource.id -ResourceGroup $rgName -ResourceType $resourceType -LogFilePath $errorLogPath -Counter ([ref]$resourceProviderIssues)
                        if (-not $isProviderIssue) {
                            Add-ResourceFailureLog -ResourceName $resourceName -ResourceId $resource.id -ResourceGroup $rgName -ResourceType $resourceType -ErrorMessage $errorMsg -LogFilePath $errorLogPath -IssueType "ResourceExportFailure" -Counter ([ref]$otherFailedResources)
                        }
                        continue
                    }
                    
                    # Create filename
                    $resourceFileName = "$safeResourceName.json"
                    $resourceFilePath = Join-Path $rgFolderPath $resourceFileName
                    
                    # Save resource definition
                    $resourceDefinition | Out-File -FilePath $resourceFilePath -Encoding UTF8
                    
                    Write-ColorOutput "      Saved: $resourceFileName" "Green"
                    $processedResources++
                }
                catch {
                    $errorMsg = $_.Exception.Message
                    $isProviderIssue = Test-ResourceProviderError -ErrorMessage $errorMsg -ResourceName $resourceName -ResourceId $resource.id -ResourceGroup $rgName -ResourceType $resourceType -LogFilePath $errorLogPath -Counter ([ref]$resourceProviderIssues)
                    if (-not $isProviderIssue) {
                        Add-ResourceFailureLog -ResourceName $resourceName -ResourceId $resource.id -ResourceGroup $rgName -ResourceType $resourceType -ErrorMessage $errorMsg -LogFilePath $errorLogPath -IssueType "ResourceExportException" -Counter ([ref]$otherFailedResources)
                    }
                }
            }
        }
        catch {
            $errorMsg = $_.Exception.Message
            Write-ColorOutput "    ERROR: Failed to list resources in $rgName - $errorMsg" "Red"
            Add-ResourceFailureLog -ResourceName "ResourceListing" -ResourceId "/subscriptions/$subscriptionId/resourceGroups/$rgName/resources" -ResourceGroup $rgName -ResourceType "ResourceListing" -ErrorMessage $errorMsg -LogFilePath $errorLogPath -IssueType "ResourceListingFailure" -Counter ([ref]$otherFailedResources)
        }
    }
    
    # Summary
    Write-ColorOutput "`n=== Export Summary ===" "Cyan"
    Write-ColorOutput "Total Resource Groups: $($resourceGroups.Count)" "Green"
    Write-ColorOutput "Total Resources Found: $totalResources" "Green"
    Write-ColorOutput "Successfully Processed: $processedResources" "Green"
    Write-ColorOutput "Resource Provider Issues: $resourceProviderIssues" "Magenta"
    Write-ColorOutput "Other Failed Resources: $otherFailedResources" "Red"
    Write-ColorOutput "Output Directory: $subscriptionOutputPath" "Green"
    
    $totalIssues = $resourceProviderIssues + $otherFailedResources
    if ($totalIssues -gt 0) {
        Write-ColorOutput "All Issues Logged to: $errorLogPath" "Yellow"
        Write-ColorOutput "Note: Review the log file for detailed error information and troubleshooting guidance." "Yellow"
    }
    
    if ($processedResources -lt $totalResources) {
        $unprocessedResources = $totalResources - $processedResources
        if ($unprocessedResources -ne $totalIssues) {
            Write-ColorOutput "Warning: Some resources may not have been properly categorized." "Yellow"
        }
    }
    
    Write-ColorOutput "`nExport completed!" "Cyan"
}
catch {
    Write-ColorOutput "FATAL ERROR: $($_.Exception.Message)" "Red"
    exit 1
}