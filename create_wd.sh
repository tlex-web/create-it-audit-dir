#!/bin/bash

# Define global variables
cwd=$(dirname "$0")
jet_repo_link=https://github.com/tlex-web/journal-entry-tests

# Get project name and entity name from user
read -p "Enter client name: " client_name
read -p "Enter period under audit: " client_year
read -p "Enter prior year working directory (leave blank if not applicable): " prior_year_wd
echo "You are currently working in $cwd"
read -p "Please confirm that this is the right directory (Y|n): " project_wd

# Check if both variables are provided
if [[ -z "$client_name" ]]; then
    echo "client name is required."
    exit 1
fi
if [[ -z "$client_year" ]]; then
    echo "Entity name is required."
    exit 1
fi
if [[ "$project_wd" == "n" ]]; then
    echo "Please change the working directory to the right location."
    exit 1
fi

# Create the main client folder and update the cwd variable
mkdir "$client_name - $client_year"
cwd="$cwd/$client_name - $client_year"

# Make sure that the template files exist or the file location changed
if [[ ! -d "L:\IT Audit docs\IT External Audit\Templates" ]]; then
    echo "Template files not found - Please check the file path."
    exit 1
fi

# Make sure that the prior year working directory exists
if [[ ! -d "$prior_year_wd" ]]; then
    echo "Prior year working directory not found - Please check the file path."
    exit 1
fi

# Define the array of folder names
folders=("01 - Planning" "02 - Fieldwork" "02 - Fieldwork/01 - PBC" "02 - Fieldwork/02 - Understanding of the Entity" "02 - Fieldwork/03 - Testing" "02 - Fieldwork/03 - Testing/MA - Testing evidences" "02 - Fieldwork/03 - Testing/MC - Testing evidences" "02 - Fieldwork/03 - Testing/MO - Testing evidences" "03 - Reporting" "03 - Reporting/Client feedback" "04 - CAAT & Regulatory" "04 - CAAT & Regulatory/JET" "05 - ITAC")

if [[ -d "$prior_year_wd" ]]; then
    echo "Prior year audit found. Copying file structure..."

    cp -r "$prior_year_wd"/* "$cwd" || {
        echo "Error copying prior year audit files."
        exit 1
    }
else
    # Loop over the array and create folders
    cd "$cwd"

    for folder in "${folders[@]}"; do
        echo "Creating folder $folder ..."

        mkdir "$folder"

        # Copy template files into the client folders
        case "$folder" in
            "01 - Planning")
                cp -p "L:\IT Audit docs\IT External Audit\Templates\02- Docs Planning - 230 GL ITPM/"*docx "$folder"/ || {
                    echo "Error copying planning files."
                    exit 1
                }
                ;;
            "02 - Fieldwork")
                cp -p "L:\IT Audit docs\IT External Audit\Templates\03 - Template kickoff\Client- Kickoff_IT audit_ddmmyyyy.pptx" "$folder"/ || {
                    echo "Error copying kickoff files."
                    exit 1
                }
                ;;
            "02 - Fieldwork/01 - PBC")
                cp -p "L:\IT Audit docs\IT External Audit\Templates\04- Docs Understand the IT process\Client - PBC_ddmmyyyy.xlsx" "$folder"/ || {
                    echo "Error copying file Client - PBC_ddmmyyyy.xlsx."
                    exit 1
                }
                ;;
            "02 - Fieldwork/02 - Understanding of the Entity")
                cp -p "L:\IT Audit docs\IT External Audit\Templates\04- Docs Understand the IT process\Examples/"*docx "$folder"/ || {
                    echo "Error copying word files."
                    exit 1
                }
                ;;
            "02 - Fieldwork/03 - Testing")
                cp -p "L:\IT Audit docs\IT External Audit\Templates\05- Docs - ITGC Testing\ITGC Testing_v2.xlsm" "$folder"/ || {
                    echo "Error copying file ITGC Testing_v2.xlsm."
                    exit 1
                }
                ;;
            "03 - Reporting")
                cp -p "L:\IT Audit docs\IT External Audit\Templates\10- ITSRM - Audit conclusion\IT Report_ FY20yy.docx" "$folder"/ || {
                    echo "Error copying file IT Report_ FY20yy.docx."
                    exit 1
                }
                ;;
            "03 - Reporting/Client feedback")
                ;;
            "04 - CAAT & Regulatory")
                cp -p "L:\IT Audit docs\IT External Audit\Templates\09- Conclusion meeting\Conclusion meeting -  template AVEGA.pptx" "$folder"/ || {
                    echo "Error copying file Conclusion meeting -  template AVEGA.pptx."
                    exit 1
                }
                ;;
            "04 - CAAT & Regulatory/JET")
                cp -p "L:\IT Audit docs\IT External Audit\Templates\12 - JET\Final version/"*docx "$folder"/ || {
                    echo "Error copying JET client files."
                    exit 1
                }
                # Create text file with instructions to initiate the GitHub JET repository
                echo "Instructions to perform a journal entry test for the client: $client_name" > "$folder"/JET-Instructions.txt
                echo "1. Open the GitHub repository using this link: $jet_repo_link" >> "$folder"/JET-Instructions.txt
                echo "2. Follow the instructions in the README sections of the repository" >> "$folder"/JET-Instructions.txt
                ;;
            "05 - ITAC")
                ;;
            *)
                echo "Unknown folder name: $folder"
                exit 1
                ;;
        esac
    done
fi

# Create a text file and insert variables
echo "Client Name: $client_name" > "ClientInfo.txt"
echo "Entity Name: $client_year" >> "ClientInfo.txt"

echo "Project template created successfully!"