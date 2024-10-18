@echo off

setlocal enabledelayedexpansion

@REM ###########################################################################
@REM ######### batch file to get apps required for openmw / runme.bat ##########
@REM ###################### requires windows 10 or above #######################
@REM ###########################################################################

@REM version: 1.1
@REM by: https://github.com/jmashuque
@REM only run this batch file if you downloaded it from:
@REM https://github.com/jmashuque/openmw-batch-script-android-windows

@REM this batch file will automatically download the apps necessary to run the
@REM commands for runme.bat and unzip them to the same folder as this script,
@REM you may select which apps to download or download them all, running this
@REM script by double-clicking it or calling it without arguments will download
@REM all the apps, or you could pass this script arguments to download specific
@REM apps when called from command prompt or another script, arguments must be
@REM in the form of:

@REM downloader.bat vcpod

@REM where "vcpod" are the specific apps you'd like to download and unzip, such
@REM as:

@REM v = validator
@REM c = tes3cmd
@REM p = trpatcher
@REM o = omwllf
@REM d = delta

@REM for example, the following command and arguments:

@REM downloader.bat vd

@REM will only download and extract validator and delta, this script only needs
@REM to be run once unless you need further apps later, tes3cmd.exe will be
@REM downloaded to Data Files folder if found, otherwise it will be downloaded
@REM to this folder 

@REM note: the version for delta might need to be changed manually as it is the
@REM only one of these apps still in development, so you can enter a different
@REM version here and it will be used:

set deltaversion=0.22.0

@REM you can manually change the following download links too, or contact me to
@REM report that dead links need to be updated

set namevalidator=https://mw.moddinghall.com/file/28-openmw-validator/?do=download
set nametes3cmd=https://github.com/john-moonsugar/tes3cmd/releases/download/v0.40-pre-release-2/tes3cmd.exe
set nametrpatcher=https://gitlab.com/bmwinger/tr-patcher/uploads/d014a589fc4c12f6ac77f531f392e32e/tr-patcher.zip
set nameomwllf=https://github.com/jmelesky/omwllf/archive/refs/tags/v1.0.zip
set namedelta=https://gitlab.com/bmwinger/delta-plugin/-/releases/!deltaversion!/downloads/delta-plugin-!deltaversion!-windows-amd64.zip

@REM if you're the creator of one of the above applications and for whatever
@REM reason you'd like to have your application omitted from this code please
@REM contact me, link at bottom of GitHub page

@REM note: its normal for the downloads to be very slow using invoke-webrequest

echo: & echo arguments: [%1]

set args=vcpod
if not "%~1" == "" set args=%~1
if not "!args:v=!" == "!args!" call :download_paradigm "openmw-validator-1.7" "!namevalidator!"
if not "!args:c=!" == "!args!" call :download_tes3cmd "!nametes3cmd!"
if not "!args:p=!" == "!args!" call :download_paradigm "tr-patcher" "!nametrpatcher!"
if not "!args:o=!" == "!args!" call :download_paradigm "omwllf-1.0" "!nameomwllf!"
if not "!args:d=!" == "!args!" call :download_paradigm "delta-plugin-!deltaversion!-windows-amd64" "!namedelta!" 1

echo: & echo process finished

exit /b 0

@REM ################################ functions ################################

:download_paradigm
@REM download_paradigm parameters:
@REM %1 - name of app
@REM %2 - link to download
@REM %3 - flag: unzip to own folder

set pathmod=.
if "%~3" == "1" set pathmod=%~1

echo: & echo downloading %~1...

powershell -command "Invoke-WebRequest '%~2' -OutFile '%~1.zip'"

echo extracting %~1.zip...

powershell Expand-Archive "%~1.zip" -DestinationPath "!pathmod!"
if exist "%~1.zip" del "%~1.zip"

echo done, %~1.zip deleted

exit /b

:download_tes3cmd
@REM downloads tes3cmd.exe and puts it in Data Files folder if Morrowind
@REM installation is found otherwise it puts it in this script's folder

set datapath=tes3cmd.exe
for /f "usebackq tokens=*" %%i in (`powershell -command "Get-ItemPropertyValue -Path 'HKLM:\SOFTWARE\WOW6432Node\Bethesda Softworks\Morrowind' -Name 'Installed Path'"`) do (
    set newpath=%%i
)

echo: & echo downloading tes3cmd.exe...

if defined newpath (
    set datapath=!newpath!\Data Files\!datapath!
) else echo morrowind installation not found, tes3cmd.exe will be downloaded here, it must be placed in the data files folder
powershell -command "Invoke-WebRequest '%~1' -OutFile '!datapath!'"

echo done

exit /b
