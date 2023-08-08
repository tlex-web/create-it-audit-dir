#!/bin/bash

# Define global variables
cwd="$(dirname "$(readlink -f "$0")")"
jet_repo_link="https://github.com/tlex-web/journal-entry-tests"

# Get project name and entity name from user
read -p "Enter client name: " client_name
read -p "Enter entity name: " entity_name
echo "You are currently working in $cwd"
read -p "Please confirm that this is the right directory (Y|n): " project_wd

# Check if both variables are provided
if [ -z "$client_name" ]; then
    echo "Client name is required."
    exit 1
fi
if [ -z "$entity_name" ]; then
    echo "Entity name is required."
    exit 1
fi
if [ "$project_wd" = "n" ]; then
    echo "Please change the working directory to the right location."
    exit 1
fi

# Create the main client folder
mkdir "IT Audit - $client_name"
cd "IT Audit - $client_name" || exit

# Make sure that the template files exist or the file location changed
if [ ! -e "L:/IT Audit docs/IT External Audit/Templates/*" ]; then
    echo "Template files not found - Please check the file path."
    exit 1
fi

# Define the array of folder names
folders=("01 - Planning" "02 - Fieldwork" "02 - Fieldwork/01 - PBC" "02 - Fieldwork/02 - Understanding of the Entity" "02 - Fieldwork/03 - Testing" "02 - Fieldwork/03 - Testing/MA - Testing evidences" "02 - Fieldwork/03 - Testing/MC - Testing evidences" "02 - Fieldwork/03 - Testing/MO - Testing evidences" "03 - Reporting" "03 - Reporting/Client feedback" "04 - CAAT & Regulatory" "04 - CAAT & Regulatory/JET" "05 - ITAC")

# Loop over the array and create folders
for f in "${folders[@]}"; do
    echo "Creating folder $f ..."

    mkdir "$f"

    # Copy template files into the client folders
    case $f in
        "01 - Planning")
            cp -a "L:/IT Audit docs/IT External Audit/Templates/02- Docs Planning - 230 GL ITPM/"*.docx "$f/" || { 
                echo "Error copying planning files."
                exit 1
            }
            cp -a "L:/IT Audit docs/IT External Audit/Templates/03 - Template kickoff/Client- Kickoff_IT audit_ddmmyyyy.pptx" "$f/" || { 
                echo "Error copying kickoff files."
                exit 1
            }
            ;;
        "02 - Fieldwork/01 - PBC")
            cp -a "L:/IT Audit docs/IT External Audit/Templates/04- Docs Understand the IT process/Client - PBC_ddmmyyyy.xlsx" "$f/" || { 
                echo "Error copying file Client - PBC_ddmmyyyy.xlsx."
                exit 1
            }
            ;;
        "02 - Fieldwork/02 - Understanding of the Entity")
            cp -a "L:/IT Audit docs/IT External Audit/Templates/04- Docs Understand the IT process/Examples/"*docx "$f/" || { 
                echo "Error copying word files."
                exit 1
            }
            ;;
        "02 - Fieldwork/03 - Testing")
            cp -a "L:/IT Audit docs/IT External Audit/Templates/05- Docs - ITGC Testing/ITGC Testing_v2.xlsm" "$f/" || { 
                echo "Error copying file ITGC Testing_v2.xlsm."
                exit 1
            }
            ;;
        "03 - Reporting")
            cp -a "L:/IT Audit docs/IT External Audit/Templates/10- ITSRM - Audit conclusion/IT Report_ FY20yy.docx" "$f/" || { 
                echo "Error copying file IT Report_ FY20yy.docx."
                exit 1
            }
            cp -a "L:/IT Audit docs/IT External Audit/Templates/09- Conclusion meeting/Conclusion meeting -  template AVEGA.pptx" "$f/" || { 
                echo "Error copying file Conclusion meeting -  template AVEGA.pptx."
                exit 1
            }
            ;;
        "04 - CAAT & Regulatory/JET")
            cp -a "L:/IT Audit docs/IT External Audit/Templates/12 - JET/Final version/"*docx "$f/" || { 
                echo "Error copying JET client files."
                exit 1
            }
            # Create text file with instructions to initiate the GitHub JET repository
            echo "Instructions to perform a journal entry test for the client: $client_name" > "$f/JET-Instructions.txt"
            echo "1. Open the GitHub repository using this link: $jet_repo_link" >> "$f/JET-Instructions.txt"
            echo "2. Follow the instructions in the README sections of the repository" >> "$f/JET-Instructions.txt"
            ;;
    esac
done

# Create a text file and insert variables
{
    echo "Client Name: $client_name"
    echo "Entity Name: $entity_name"
} > "ClientInfo.txt"

echo "Project template created successfully!"

