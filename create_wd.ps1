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

# Get project name and entity name from user
$client_name = Read-Host "Enter client name"
$client_year = Read-Host "Enter period under audit"
$prior_year_wd = Read-Host "Enter prior year working directory (leave blank if not applicable)"

# Check if both variables are provided
if ([string]::IsNullOrWhiteSpace($client_name)) {
    Write-Error "Client name is required."
    exit 1
}
if ([string]::IsNullOrWhiteSpace($client_year)) {
    Write-Error "Entity name is required."
    exit 1
}

# Make sure that the template files exist or the file location changed
if (-not (Test-Path "L:\IT Audit docs\IT External Audit\Templates\*")) {
    Write-Error "Template files not found - Please check the file path."
    exit 1
}

# Make sure that the prior year working directory exists if not blank
if (-not [string]::IsNullOrWhiteSpace($prior_year_wd)) {
    if (-not (Test-Path $prior_year_wd)) {
        Write-Error "Prior year working directory not found - Please check the file path."
        exit 1
    }
}

# Create the main client folder and update the cwd variable
mkdir "$client_name - $client_year" | Out-Null
if ($LASTEXITCODE -ne 0) {
    Write-Error "Error creating client folder."
    exit 1
}
$cwd = "$((Get-Location).Path)\$client_name - $client_year"
Write-Host "Working directory: $cwd"
Set-Location $cwd

if (Test-Path $prior_year_wd) {
    Write-Host "Prior year audit found. Copying file structure..."
    Copy-Item $prior_year_wd\* -Destination $cwd -Recurse -Force -ErrorAction Stop
}
else {
    # Loop over the array and create folders
    foreach ($folder in $folders) {
        Write-Host "Creating folder $folder ..."
        mkdir $folder | Out-Null
        if ($LASTEXITCODE -ne 0) {
            Write-Error "Error creating folder $folder."
            exit 1
        }

        # Copy template files into the client folders
        if ($folder -eq "01 - Planning") {
            Copy-Item "L:\IT Audit docs\IT External Audit\Templates\02- Docs Planning - 230 GL ITPM\*docx" -Destination "$folder\" -Force -ErrorAction Stop
            Copy-Item "L:\IT Audit docs\IT External Audit\Templates\03 - Template kickoff\Client- Kickoff_IT audit_ddmmyyyy.pptx" -Destination "$folder\" -Force -ErrorAction Stop
        }
        if ($folder -eq "02 - Fieldwork/01 - PBC") {
            Copy-Item "L:\IT Audit docs\IT External Audit\Templates\04- Docs Understand the IT process\Client - PBC_ddmmyyyy.xlsx" -Destination "$folder\" -Force -ErrorAction Stop
        }
        if ($folder -eq "02 - Fieldwork/02 - Understanding of the Entity") {
            Copy-Item "L:\IT Audit docs\IT External Audit\Templates\04- Docs Understand the IT process\Examples\*docx" -Destination "$folder\" -Force -ErrorAction Stop
        }
        if ($folder -eq "02 - Fieldwork/03 - Testing") {
            Copy-Item "L:\IT Audit docs\IT External Audit\Templates\05- Docs - ITGC Testing\ITGC Testing_v2.xlsm" -Destination "$folder\" -Force -ErrorAction Stop
        }
        if ($folder -eq "03 - Reporting") {
            Copy-Item "L:\IT Audit docs\IT External Audit\Templates\10- ITSRM - Audit conclusion\IT Report_ FY20yy.docx" -Destination "$folder\" -Force -ErrorAction Stop
            Copy-Item "L:\IT Audit docs\IT External Audit\Templates\09- Conclusion meeting\Conclusion meeting -  template AVEGA.pptx" -Destination "$folder\" -Force -ErrorAction Stop
        }
        if ($folder -eq "04 - CAAT & Regulatory/JET") {
            Copy-Item "L:\IT Audit docs\IT External Audit\Templates\12 - JET\Final version\*docx" -Destination "$folder\" -Force -ErrorAction Stop
            # Create text file with instructions to initiate the GitHub JET repository
            $jet_repo_link = "https://github.com/tlex-web/journal-entry-tests"
            $jet_instructions = "Instructions to perform a journal entry test for the client: $client_name`n1. Open the GitHub repository using this link: $jet_repo_link`n2. Follow the instructions in the README sections of the repository"
            $jet_instructions | Out-File "$folder\JET-Instructions.txt" -Encoding utf8
        }
    }
}

# Create a text file and insert variables
Set-Content -Path "ClientInfo.txt" -Value "Client Name: $client_name`nEntity Name: $client_year"

Write-Host "Project template created successfully!"