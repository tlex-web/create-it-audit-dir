@echo off
setlocal EnableDelayedExpansion

REM Define global variables
set cwd=%~f0
set jet_repo_link=https://github.com/tlex-web/journal-entry-tests

REM Get project name and entity name from user
set /p "client_name=Enter client name: "
set /p "client_year=Enter period under audit: "
set /p "prior_year_wd=Enter prior year working directory (leave blank if not applicable): "
echo "You are currently working in: "%cwd:~0,-4%
set /p "project_wd=Please confirm that this is the right directory (Y|n): "

REM Check if both variables are provided
if "!client_name!"=="" (
    echo client name is required.
    exit /b 1
)
if "!client_year!"=="" (
    echo Entity name is required.
    exit /b 1
)
if "!project_wd!"=="n" (
    echo Please change the working directory to the right location.
    exit /b 1
)

REM Make sure that the template files exist or the file location changed
if not exist "L:\IT Audit docs\IT External Audit\Templates\*" (
    echo Template files not found - Please check the file path.
    exit /b 1
)

REM Make sure that the prior year working directory exists if not blank
if not "!prior_year_wd!"=="" (
    if not exist "!prior_year_wd!" (
        echo Prior year working directory not found - Please check the file path.
        exit /b 1
    )
)

REM Define the array of folder names
set folders[0]="01 - Planning"
set folders[1]="02 - Fieldwork"
set folders[2]="02 - Fieldwork/01 - PBC"
set folders[3]="02 - Fieldwork/02 - Understanding of the Entity"
set folders[4]="02 - Fieldwork/03 - Testing"
set folders[5]="02 - Fieldwork/03 - Testing/MA - Testing evidences"
set folders[6]="02 - Fieldwork/03 - Testing/MC - Testing evidences"
set folders[7]="02 - Fieldwork/03 - Testing/MO - Testing evidences"
set folders[8]="03 - Reporting"
set folders[9]="03 - Reporting/Client feedback"
set folders[10]="04 - CAAT & Regulatory"
set folders[11]="04 - CAAT & Regulatory/JET"
set folders[12]="05 - ITAC"

REM Create the main client folder and update the cwd variable
mkdir "!client_name! - !client_year!"
if errorlevel 1 (
    echo Error creating client folder.
    exit /b 1
)
set cwd=!cwd:~0,-4!\!client_name! - !client_year!
echo Working directory: !cwd!
cd !cwd!

echo !cwd! !prior_year_wd!

if exist !prior_year_wd! (
    echo Prior year audit found. Copying file structure...
    echo !cwd!


    xcopy /E /I /Y "!prior_year_wd!" "!cwd!" || (
        echo Error copying prior year audit files.
        exit /b 1
    )
) else (
    REM Loop over the array and create folders

    for /L %%f in (0,1,12) do (
        echo Creating folder !folders[%%f]! ...

        mkdir !folders[%%f]!
        if errorlevel 1 (
            echo Error creating folder !folders[%%f]!.
            exit /b 1
        )

        REM Copy template files into the client folders

        if %%f==0 (
            COPY /B /D "L:\IT Audit docs\IT External Audit\Templates\02- Docs Planning - 230 GL ITPM\*docx" !folders[%%f]!"\" /Z || ( 
                echo Error copying planning files.
                exit /b 1
            )
        )

        if %%f==0 (
            COPY /B /D "L:\IT Audit docs\IT External Audit\Templates\03 - Template kickoff\Client- Kickoff_IT audit_ddmmyyyy.pptx" !folders[%%f]!"\" /Z || ( 
                echo Error copying planning files.
                exit /b 1
            )
        )

        if %%f==2 (
            COPY /B /D "L:\IT Audit docs\IT External Audit\Templates\04- Docs Understand the IT process\Client - PBC_ddmmyyyy.xlsx" !folders[%%f]!"\" /Z || ( 
                echo Error copying file Client - PBC_ddmmyyyy.xlsx.
                exit /b 1
            )
        )

        if %%f==3 (
            COPY /B /D "L:\IT Audit docs\IT External Audit\Templates\04- Docs Understand the IT process\Examples\*docx" !folders[%%f]!"\" /Z || ( 
                echo Error copying word files
                exit /b 1
            )
        )

        if %%f==4 (
            COPY /B /D "L:\IT Audit docs\IT External Audit\Templates\05- Docs - ITGC Testing\ITGC Testing_v2.xlsm" !folders[%%f]!"\" /Z || ( 
                echo Error copying file ITGC Testing_v2.xlsm.
                exit /b 1
            )
        )

        if %%f==8 (
            COPY /B /D "L:\IT Audit docs\IT External Audit\Templates\10- ITSRM - Audit conclusion\IT Report_ FY20yy.docx" !folders[%%f]!"\" /Z || ( 
                echo Error copying file IT Report_ FY20yy.docx.
                exit /b 1
            )
        )

        if %%f==8 (
            COPY /B /D "L:\IT Audit docs\IT External Audit\Templates\09- Conclusion meeting\Conclusion meeting -  template AVEGA.pptx" !folders[%%f]!"\" /Z || ( 
                echo Error copying file Conclusion meeting -  template AVEGA.pptx.
                exit /b 1
            )
        )

        if %%f==11 (
            COPY /B /D "L:\IT Audit docs\IT External Audit\Templates\12 - JET\Final version\*docx" !folders[%%f]!"\" /Z || ( 
                echo Error copying JET client files
                exit /b 1
            )
            REM Create text file with instructions to initiate the GitHub JET repository
            echo Instructions to perform a journal entry test for the client: !client_name! >> !folders[%%f]!\JET-Instructions.txt
            echo 1. Open the GitHub repository using this link: !jet_repo_link! >> !folders[%%f]!\JET-Instructions.txt
            echo 2. Follow the instructions in the README sections of the repository >> !folders[%%f]!\JET-Instructions.txt
            
        )
    )
)

REM Create a text file and insert variables
echo Client Name: %client_name% > "ClientInfo.txt"
echo Entity Name: %client_year% >> "ClientInfo.txt"

echo Project template created successfully!

endlocal