# Define global variables
$cwd = Split-Path -Parent $MyInvocation.MyCommand.Path
$jet_repo_link = "https://github.com/tlex-web/journal-entry-tests"

# Get project name and entity name from user
$client_name = Read-Host "Enter client name"
$client_year = Read-Host "Enter period under audit"
$prior_year_wd = Read-Host "Enter prior year working directory (leave blank if not applicable)"
$project_wd = Read-Host "Please confirm that this is the right directory (Y|n)"

# Check if both variables are provided
if ([string]::IsNullOrEmpty($client_name)) {
    Write-Host "client name is required."
    exit 1
}
if ([string]::IsNullOrEmpty($client_year)) {
    Write-Host "Entity name is required."
    exit 1
}
if ($project_wd -eq "n") {
    Write-Host "Please change the working directory to the right location."
    exit 1
}

# Create the main client folder and update the cwd variable
New-Item -ItemType Directory -Path "$client_name - $client_year" | Out-Null
$cwd = Join-Path $cwd "$client_name - $client_year"

# Make sure that the template files exist or the file location changed
if (-not (Test-Path "L:\IT Audit docs\IT External Audit\Templates\*")) {
    Write-Host "Template files not found - Please check the file path."
    exit 1
}

# Make sure that the prior year working directory exists
if (-not (Test-Path $prior_year_wd)) {
    Write-Host "Prior year working directory not found - Please check the file path."
    exit 1
}

# Define the array of folder names
$folders = @(
    "01 - Planning",
    "02 - Fieldwork",
    "02 - Fieldwork/01 - PBC",
    "02 - Fieldwork/02 - Understanding of the Entity",
    "02 - Fieldwork/03 - Testing",
    "02 - Fieldwork/03 - Testing/MA - Testing evidences",
    "02 - Fieldwork/03 - Testing/MC - Testing evidences",
    "02 - Fieldwork/03 - Testing/MO - Testing evidences",
    "03 - Reporting",
    "03 - Reporting/Client feedback",
    "04 - CAAT & Regulatory",
    "04 - CAAT & Regulatory/JET",
    "05 - ITAC"
)

if (Test-Path $prior_year_wd) {
    Write-Host "Prior year audit found. Copying file structure..."

    Copy-Item -Path "$prior_year_wd\*" -Destination $cwd -Recurse -Force -ErrorAction Stop
} else {
    # Loop over the array and create folders
    Set-Location $cwd

    foreach ($folder in $folders) {
        Write-Host "Creating folder $folder ..."

        New-Item -ItemType Directory -Path $folder | Out-Null

        # Copy template files into the client folders
        switch ($folder) {
            "01 - Planning" {
                Copy-Item -Path "L:\IT Audit docs\IT External Audit\Templates\02- Docs Planning - 230 GL ITPM\*docx" -Destination $folder -Force -ErrorAction Stop
            }
            "02 - Fieldwork" {
                Copy-Item -Path "L:\IT Audit docs\IT External Audit\Templates\03 - Template kickoff\Client- Kickoff_IT audit_ddmmyyyy.pptx" -Destination $folder -Force -ErrorAction Stop
            }
            "02 - Fieldwork/01 - PBC" {
                Copy-Item -Path "L:\IT Audit docs\IT External Audit\Templates\04- Docs Understand the IT process\Client - PBC_ddmmyyyy.xlsx" -Destination $folder -Force -ErrorAction Stop
            }
            "02 - Fieldwork/02 - Understanding of the Entity" {
                Copy-Item -Path "L:\IT Audit docs\IT External Audit\Templates\04- Docs Understand the IT process\Examples\*docx" -Destination $folder -Force -ErrorAction Stop
            }
            "02 - Fieldwork/03 - Testing" {
                Copy-Item -Path "L:\IT Audit docs\IT External Audit\Templates\05- Docs - ITGC Testing\ITGC Testing_v2.xlsm" -Destination $folder -Force -ErrorAction Stop
            }
            "03 - Reporting" {
                Copy-Item -Path "L:\IT Audit docs\IT External Audit\Templates\10- ITSRM - Audit conclusion\IT Report_ FY20yy.docx" -Destination $folder -Force -ErrorAction Stop
            }
            "03 - Reporting/Client feedback" {
                # Do nothing
            }
            "04 - CAAT & Regulatory" {
                Copy-Item -Path "L:\IT Audit docs\IT External Audit\Templates\09- Conclusion meeting\Conclusion meeting -  template AVEGA.pptx" -Destination $folder -Force -ErrorAction Stop
            }
            "04 - CAAT & Regulatory/JET" {
                Copy-Item -Path "L:\IT Audit docs\IT External Audit\Templates\12 - JET\Final version\*docx" -Destination $folder -Force -ErrorAction Stop

                # Create text file with instructions to initiate the GitHub JET repository
                $jet_instructions = "Instructions to perform a journal entry test for the client: $client_name`n"
                $jet_instructions += "1. Open the GitHub repository using this link: $jet_repo_link`n"
                $jet_instructions += "2. Follow the instructions in the README sections of the repository"
                Set-Content -Path "$folder\JET-Instructions.txt" -Value $jet_instructions
            }
            "05 - ITAC" {
                # Do nothing
            }
            default {
                Write-Host "Unknown folder name: $folder"
                exit 1
            }
        }
    }
}

# Create a text file and insert variables
$client_info = "Client Name: $client_name`r`nEntity Name: $client_year"
Set-Content -Path "ClientInfo.txt" -Value $client_info

Write-Host "Project template created successfully!"