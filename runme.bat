@echo off

setlocal enabledelayedexpansion

@REM ###########################################################################
@REM ############ openmw batch script for android and windows users ############
@REM ###########################################################################

@REM version: 0.6.0 (2023-12-02)
@REM by: https://github.com/jmashuque
@REM only run this batch file if you downloaded it from:
@REM https://github.com/jmashuque/openmw-batch-script-android-windows

@REM place the android openmw.cfg (if applicable) as well as the folders of the
@REM applications you want to use (if applicable), excluding tes3cmd, in the
@REM same folder as this batch file, or use the included script called
@REM downloader.bat to automatically download and unzip all the apps, and then
@REM open up variables.txt and change it according to your needs and run this
@REM file like any other file, by default the android openmw.cfg will be in
@REM "/sdcard/omw_nightly/config/", your folder name might be a bit different
@REM depending on your OpenMW build, use "/sdcard" instead of
@REM "/storage/emulated/0", the default windows copy is in
@REM "Documents\My Games\OpenMW\", you can modify the input/output folders and
@REM the name of the .cfg as well as folders for the apps, and you can choose
@REM the output folder and names of the .omwaddon files, but all the apps will
@REM always look for openmw.cfg in the default windows location

@REM this script tries to correct for some errors and checks for some files but
@REM also makes many assumptions, including assuming the .cfg file is formatted
@REM in the correct way and does not contain the following special characters
@REM (!, <, >, |, &, ^, =, :, ", `, *, ?), all values are case-sensitive, enter
@REM values immediately after the equal signs, do not change the variable names

@REM this script disables mods by adding "# " at the beginning of a line but it
@REM can enable lines that have a combination of "#" and "# " disabling the
@REM lines

@REM this script creates .tmp files and may leave some behind if it doesn't end
@REM successfully, these files can safely be deleted, they are all timestamped
@REM for easy identification

@REM if you have large mod lists or disable/enable/exclude many mods it may seem
@REM like the script has frozen but it can take over a minute depending on the
@REM number of lines being processed and the specs of your PC

@REM openmw will rewrite the windows openmw.cfg when you run the game from the
@REM launcher, which may change the formatting and line placement, such as
@REM placing all content lines at the bottom

@REM the file names of the applications used by this script are hard-coded and
@REM will not be recognised if the file names have been changed, only folder
@REM names can be modified

@REM the option below is for users who are using file or folder names containing
@REM non-Latin characters, modify just the number in the line below with the
@REM correct codepage identifier for your language, the default value covers
@REM latin letters, if you are seeing errors in names then your letters aren't
@REM being recognised and you must use a custom codepage identifier, changing
@REM this value may show some errors but the script should execute fine, check
@REM the following link for the correct identifier number for your language:
@REM https://learn.microsoft.com/en-us/windows/win32/intl/code-page-identifiers
chcp 1252 > NUL

@REM name of a variable file to use to load variables for this script, you can
@REM enter values for variables below in the user variables section or you can
@REM import them from a file, this batch file comes with a variables.txt file
@REM that contains all user variable names and default values, the file can be
@REM modified like the openmw.cfg file, variable definitions below will only be
@REM used if this value is made blank, you can also run this script through a
@REM command prompt and provide the name of a variable file as an argument
set varFile=variables.txt

if not "%~1" == "" set varFile=%~1
if defined varFile goto skipVar

@REM ############################# user variables ##############################

@REM location of android version of openmw.cfg on windows, can be a folder, if
@REM file name not provided then openmw.cfg will be used, if left blank will
@REM assume file name is openmw.cfg and located in the same folder as this
@REM batch file, can be relative or absolute path
set fileAnd=

@REM location of windows version of openmw.cfg, all the apps will look for
@REM openmw.cfg where windows openmw usually puts it, so leave this blank unless
@REM you want to override the default, if file name not provided then openmw.cfg
@REM will be used, and if folder not provided but file name is provided then
@REM will output file to the same folder as this batch file
set fileWin=

@REM location of data files folder on android, must match paths in openmw.cfg,
@REM no default value
set folderAndData=

@REM location of data files folder on windows, must already contain all base
@REM game and expansion .bsa and .esm files, no default value
set folderWinData=

@REM location of mods folder on android, must match paths in openmw.cfg, no
@REM default value
set folderAndMods=

@REM location of mods folder on windows, must already contain all mods from the
@REM android openmw.cfg in the same folder structure, including all .esm and
@REM .esp files, no default value
set folderWinMods=

@REM name of folder for .omwaddon files generated by omwllf and delta, must
@REM match paths in openmw.cfg and be inside Mods folder, can include
@REM subfolders, if the omwaddon files are in the base Mods folder then just
@REM leave blank, if folder doesn't exist and either omwllf or delta is enabled
@REM it will be created, if folder not listed in openmw.cfg enable autoRewrite
@REM to automatically append openmw.cfg with the data line, no default value
set folderOmwaddon=

@REM set value to 1 to backup .cfg and .omwaddon files before overwriting, will
@REM ovewrite previous backup copy, only one backup operation is performed on
@REM .cfg file if both conversion and rewriting functions are enabled
set enableBackup=

@REM set value to 1 to clear the command prompt screen before running the file
set enableCls=

@REM set value to 1 to pause after each step to allow reading output
set enableDelay=

@REM set value to 1 to run openmw at the end of execution if errors were not
@REM raised, note this involves accessing the registry but does not require
@REM administrative privileges, if multiple versions of openmw are found then
@REM the first one alphanumerically will be used, if validator is also run and
@REM reports an error this value will be disabled
set runOpenmw=

@REM set value to 1 to quickly disable all below applications regardless of
@REM their individual settings
set disableApps=

@REM set value to 1 to enable conversion of openmw.cfg, set the variables below
@REM to choose which paths to convert to and which direction to perform the
@REM conversion, the apps will not work with an openmw.cfg containing android
@REM paths
set enableConvert=

@REM set to either "windows" or "android" to convert paths to that format, when
@REM using windows mode, fileAnd is used as input and fileWin is used as output
@REM and vice versa for android mode, this setting is also used for converting
@REM mod lists
set convertTo=

@REM set value to 1 to disable every line matching each mod or folder listed in
@REM the next variable, reads and writes to output file
set enableDisabler=

@REM list names of mods or folders to disable, only works if above variable is
@REM enabled, uses partial matching, mod names should contain file extension if
@REM you want just a mod disabled and not its folder, matches with any line if
@REM containing the entire name provided, folder paths can be fragments,
@REM relative or absolute and can be either android or windows, use a question
@REM mark (?) between each file or folder name and do not put more than one
@REM space before or after the (?), do not include names of the generated
@REM .omwaddon files or their folder as those can be disabled automatically
@REM using the exlcude options
set modsDisabler=

@REM set value to 1 to enable every line matching each mod or folder listed in
@REM the next variable, reads and writes to output file
set enableEnabler=

@REM list names of mods or folders to enable, only works if above variable is
@REM enabled, uses partial matching, mod names should contain file extension if
@REM you want just a mod disabled and not its folder, matches with any line
@REM containing the entire name provided, folder paths can be fragments,
@REM relative or absolute and can be either android or windows, use a question
@REM mark (?) between each file or folder name and do not put more than one
@REM space before or after the (?)
set modsEnabler=

@REM set value to 1 to check disabled/enabled lines once file has been converted
@REM or modified disabled data paths are checked for active mods and enabled
@REM data paths are checked to see if they exist, this option will only find
@REM invalid entries that were caused by this script and not all invalid entries
@REM inside openmw.cfg
set enableCheck=

@REM set value to 1 to add a comment at the bottom of openmw.cfg with the date
@REM and time stamp of when the batch file ran, any lines matching this format
@REM will be deleted every write regardless of this setting
set enableLastModified=

@REM set value to 1 to match phrases in mod lists out of order, each mod is
@REM broken down by spaces and each term is searched separately within the same
@REM line, this will match any line containing all terms in a mod name in any
@REM order, don't use this option if you're providing exact mod or folder names,
@REM this option will somewhat slow down file conversion depending on how many
@REM terms are provided
set disableSearchExact=

@REM set value to 1 to reverse input and output, so a convertTo value of windows
@REM will use fileWin as input and fileAnd as output and vice versa for android
set enableReverse=

@REM set value to 1 to output every line that is disabled/enabled/rewritten,
@REM including line number, this doesn't include excluding generated .omwaddon
@REM files/folder, this does slow down the output process
set enableVerbose=

@REM set value to 1 to overwrite output instead of using a separate input file,
@REM reverse option still applies
set ignoreInput=

@REM set value to 1 to run openmw-validator, if errors are detected runOpenmw
@REM will be disasbled
set enableValidator=

@REM set value to 1 to delete the generated validator log file at end of
@REM execution, note that if other apps aren't enabled and you enable open log,
@REM the validator log might be deleted before it finishes loading on your text
@REM editor, you will have to disable this to be able to read the log
set deleteLog=

@REM set value to 1 to open the generated validator log file after executing
@REM openmw-validator command
set openLog=

@REM location of openmw-validator.exe, can be relative or absolute, this app
@REM does not output to screen so check log for errors with your openmw.cfg
set validatorDir=

@REM set value to 1 to enable running tes3cmd, this option will take the list
@REM below and match any that exist in the data paths inside openmw.cfg and if
@REM any do then run the clean command on them, tes3cmd.exe must be located in
@REM the data files folder
set enableTes3cmd=

@REM list names of mods to run cleaning on, mod names should contain file
@REM extension, use a question mark (?) between each file name and do not put
@REM more than one space before or after the (?)
set modsTes3cmd=

@REM set value to 1 to enable running tr-patcher, this option will take the list
@REM below and match any that exist in the data paths inside openmw.cfg and if
@REM any do then run tr-patcher on them
set enableTrpatch=

@REM location of tr-patcher folder or the lib folder or tr-patcher.jar, can be
@REM relative or absolute path
set trpatchDir=

@REM list names of mods to run tr-patcher on, mod names should contain file
@REM extension, use a question mark (?) between each file name and do not put
@REM more than one space before or after the (?)
set modsTrpatch=

@REM set value to 1 to run omwllf
set enableOmwllf=

@REM python must be installed for omwllf, set a custom path for python.exe here
@REM if it is not inside the windows path variable, leave blank otherwise
set pythonFolder=

@REM location of omwllf.py, can be relative or absolute path
set omwllfDir=

@REM name of .omwaddon file generated by omwllf.py, outputs to folderOmwaddon,
@REM name must match name in your openmw.cfg, if using date and time stamp the
@REM stamp will be applied at the end of file name before the file extension
set omwllfOut=

@REM set value to 1 to disable the mods or folders listed below before running
@REM omwllf
set enableOmwllfExcluder=

@REM list names of mods or folders to disable before running omwllf.py, only
@REM works if above variable is enabled, same rules as modsDisabler variable
set modsOmwllfExcluder=

@REM set value to 1 to run DeltaPlugin
set enableDelta=

@REM location of delta_plugin.exe, can be relative or absolute path
set deltaDir=

@REM name of .omwaddon file generated by delta_plugin.exe, outputs to
@REM folderOmwaddon, name must match name in your openmw.cfg, if using date and
@REM time stamp the stamp will be applied at the end of file name before the
@REM file extension
set deltaOut=

@REM set value to 1 to disable the mods or folders listed below before running
@REM delta
set enableDeltaExcluder=

@REM list names of mods or folders to disable before running delta_plugin.exe,
@REM only works if above variable is enabled, same rules as modsDisabler
@REM variable
set modsDeltaExcluder=

@REM set value to 1 to rewrite openmw.cfg after running tes3cmd or enabling
@REM timestamp for omwllf/delta to add or change any lines to reflect names
set autoRewrite=

@REM set value to 1 to enable continuing to next step even if an error is raised
@REM by one of the apps
set enableContinue=

@REM set value to 1 to run omwllf.py and delta_plugin.exe in silent mode,
@REM neither will output anything to screen including errors
set enableSilent=

@REM set value to 1 to add a date and time stamp to the end of the file name for
@REM both the omwllf and delta output files, added before the extension, format
@REM is not region-specific
set enableTimestamp=

@REM set value to 1 to disable the .omwaddon files containing the names of the
@REM generated files by omwllf/delta defined below before running omwllf or
@REM delta, make sure to enable this to not cause issues with the apps trying to
@REM read them as regular mods, names that partially match and are .omwaddon
@REM files will also be disabled so timestamped entries are fine
set excludeOmwaddons=

@REM set value to 1 to disable the .omwaddon folder as well, use this if you
@REM don't store other mod files in this folder, implies above option so files
@REM will also be disabled, will not disable base Mods folder even if base mods
@REM folder is output for .omwaddon files, will cause errors in the apps if
@REM folder contains other mod files that haven't been disabled manually or
@REM added to the exclusion lists
set excludeOmwaddonsFolder=

:skipVar

@REM ################################## main ###################################

if defined varFile (
	if exist !varFile! (
		for /f "usebackq tokens=1,2 eol=# delims==" %%i in ("!varFile!") do (set %%i=%%j)
	) else (
		set "t=!time: =0!" & echo: & echo [!t:~0,-3!] varFile not found
		set f_error=1
		goto end
	)
)
if defined enableCls cls
if defined varFile (
	set "t=!time: =0!" & echo: & echo [!t:~0,-3!] variables read from !varFile!
) else set "t=!time: =0!" & echo: & echo [!t:~0,-3!] variables read from runme.bat
set f_error=
set f_temp=
if /i "!convertTo:android=!" == "!convertTo!" if /i "!convertTo:windows=!" == "!convertTo!" (
	set "t=!time: =0!" & echo: & echo [!t:~0,-3!] convertTo value not recognised, use either windows or android
	set f_error=1
	goto end
)
for /f "usebackq tokens=*" %%i in (`powershell -command "Join-Path ([environment]::GetFolderPath('mydocuments')) 'My Games\OpenMW'"`) do (
	set omwdir=%%i
)

if not exist "!omwdir!" md "!omwdir!"
set omw=openmw.cfg
set omwdir=!omwdir!\!omw!
if not defined fileAnd set fileAnd=!omw!
if not "!fileAnd:~-4!" == ".cfg" set fileAnd=!fileAnd!\!omw!
if not defined fileWin set fileWin=!omwdir!
if not "!fileWin:~-4!" == ".cfg" set fileWin=!fileWin!\!omw!
set folderAndData=!folderAndData:\=/!
if not "!folderAndData:~0,1!" == "/" set folderAndData=/!folderAndData!
if not "!folderAndData:~-1!" == "/" set folderAndData=!folderAndData!/
set folderAndMods=!folderAndMods:\=/!
if not "!folderAndMods:~0,1!" == "/" set folderAndMods=/!folderAndMods!
if not "!folderAndMods:~-1!" == "/" set folderAndMods=!folderAndMods!/
set folderWinData=!folderWinData:/=\!
if not "!folderWinData:~-1!" == "\" set folderWinData=!folderWinData!\
set folderWinMods=!folderWinMods:/=\!
if not "!folderWinMods:~-1!" == "\" set folderWinMods=!folderWinMods!\
set winpath=!folderWinMods!!folderOmwaddon!
set winpath=!winpath:/=\!
set winpath=!winpath:\\=\!
if "!winpath:~-1!" == "\" set winpath=!winpath:~0,-1!
set andpath=!folderAndMods!!folderOmwaddon!
set andpath=!andpath:\=/!
set andpath=!andpath://=/!
if "!andpath:~-1!" == "/" set andpath=!andpath:~0,-1!
if not defined folderOmwaddon set folderOmwaddon=\
if not "!omwllfOut:.omwaddon=!" == "!omwllfOut!" set omwllfOut=!omwllfOut:.omwaddon=!
if not "!deltaOut:.omwaddon=!" == "!deltaOut!" set deltaOut=!deltaOut:.omwaddon=!
if defined excludeOmwaddonsFolder set excludeOmwaddons=1

if /i "!convertTo:a=!" == "!convertTo!" (
	set input=!fileAnd!
	set output=!fileWin!
	set "t=!time: =0!" & echo: & echo [!t:~0,-3!] paths will be converted to windows
) else (
	set input=!fileWin!
	set output=!fileAnd!
	set "t=!time: =0!" & echo: & echo [!t:~0,-3!] paths will be converted to android
)
if defined enableReverse (
	set var=!input!
	set input=!output!
	set output=!var!
)
set f_change=
set f_backup=
if defined enableConvert set f_change=1
if defined enableDisabler set f_change=1
if defined enableEnabler set f_change=1
if defined f_change if defined ignoreInput (
	set input=!output!.tmp
	call :backup "!output!" 1
)
set ceedee=!cd!
set rewriteList[length]=0
set writeList=
set "t=!time: =0!" & echo: & echo [!t:~0,-3!] input: !input!
set "t=!time: =0!" & echo: & echo [!t:~0,-3!] output: !output!
for /f "tokens=*" %%i in ('powershell Get-Date -Format "yyyy-MM-dd-HHmmss"') do (set dt=%%i)

if not defined f_change goto beginValidator

call :existence "!input!"
if defined f_error goto end
set "t=!time: =0!" & echo: & echo [!t:~0,-3!] !input! found
if defined enableBackup if exist "!output!" (
	call :backup "!output!"
	set f_backup=1
)
call :changer "134"
if defined f_temp call :restore 1

if defined enableDelay pause

:beginValidator

if defined disableApps (
	set "t=!time: =0!" & echo: & echo [!t:~0,-3!] apps have been disabled
	goto end
)

if not "!fileWin!" == "!omwdir!" set fileWin=!omwdir!
call :existence "!fileWin!"
if defined f_error goto end
set input=!fileWin!.tmp
set output=!fileWin!

if not defined enableValidator goto beginTes3cmd

call :appParser validatorDir "openmw-validator.exe"
if defined f_error goto end
set validatorRun="!validatorDir!" --cfg "!omwdir!" --out "!omwdir:~0,-10!validator-!dt!.log"
set "t=!time: =0!" & echo: & echo [!t:~0,-3!] running openmw-validator.exe...
for /f "usebackq tokens=*" %%i in (`"!validatorRun!"`) do (set validatorLog=%%i)
set validatorLog=!validatorLog:Validation completed, log written to: =!
if not "!validatorLog:~-4!" == ".log" (
	set "t=!time: =0!" & echo: & echo [!t:~0,-3!] error returned by openmw-validator.exe
	if not defined enableContinue (
		set f_error=1
		goto end
	) else goto beginTes3cmd
)
for /f "usebackq" %%c in (`type "!validatorLog!" ^| find /v /c ""`) do (set validatorCount=%%c)
set /a "validatorCount=!validatorCount!-4"
set skipline=usebackq skip=!validatorCount! delims=
for /f "%skipline%" %%i in ("!validatorLog!") do (
	set toProcess=%%i
	goto beginValidatorTwo
)

:beginValidatorTwo

if not "!toProcess:No problems detected=!" == "!toProcess!" (
	set "t=!time: =0!" & echo: & echo [!t:~0,-3!] openmw-validator.exe finished, no errors reported
) else (
	set "t=!time: =0!" & echo: & echo [!t:~0,-3!] openmw-validator.exe finished, reported some errors were found
	if defined outputWarning call :readWarning
	if defined runOpenmw (
		set runOpenmw=
		set "t=!time: =0!" & echo: & echo [!t:~0,-3!] openmw.exe will not be executed
	)
)
set "t=!time: =0!" & echo: & echo [!t:~0,-3!] log saved to !validatorLog!
if defined openLog start "" "!validatorLog!"

if defined enableDelay pause

:beginTes3cmd

if not defined enableTes3cmd goto beginTrpatch

set tes3cmdDir=!folderWinData!tes3cmd.exe
call :existence "!tes3cmdDir!"
if defined f_error goto end
set "t=!time: =0!" & echo: & echo [!t:~0,-3!] running tes3cmd.exe...
if defined modsTes3cmd (
	set patcherLog=
	for %%i in ("!folderWinData!") do (set varfolder=%%~dpi)
	pushd "!varfolder!"
	call :patcherMain "!modsTes3cmd!" "!tes3cmdDir!" "tes3cmd clean"
	popd
	if defined f_error (
		set "t=!time: =0!" & echo: & echo [!t:~0,-3!] error returned by tes3cmd.exe
		if not defined enableContinue goto end
	)
)
set "t=!time: =0!" & echo: & echo [!t:~0,-3!] tes3cmd.exe finished

if defined enableDelay pause

:beginTrpatch

if not defined enableTrpatch goto beginOmwllf

set trpatchDir2=!trpatchDir!\lib\jsqlparser-0.9.6.jar;!trpatchDir!\lib\jep-2.24.jar;!trpatchDir!\lib\tr-patcher.jar
call :appParser trpatchDir "lib\tr-patcher.jar"
if defined f_error if not defined enableContinue goto end
set "t=!time: =0!" & echo: & echo [!t:~0,-3!] running tr-patcher.jar...
if defined modsTrpatch call :patcherMain "!modsTrpatch!" "!trpatchDir2!" "java -classpath ""^!usepath^!"" IdPatchCli"
set "t=!time: =0!" & echo: & echo [!t:~0,-3!] tr-patcher.jar finished

if defined enableDelay pause

:beginOmwllf

set f_omw=
if defined enableOmwllf set f_omw=1
if defined enableDelta set f_omw=1
if defined f_omw (
	if defined enableSilent set "t=!time: =0!" & echo: & echo [!t:~0,-3!] silent enabled, no output from omwllf/delta
	set omwllfOut=!omwllfOut:.omwaddon=!
	set deltaOut=!deltaOut:.omwaddon=!
	if defined enableTimestamp (
		set omwllfoutput=!omwllfOut!-!dt!.omwaddon
		set deltaoutput=!deltaOut!-!dt!.omwaddon
		if defined enableBackup (
			set enableBackup=
			set "t=!time: =0!" & echo: & echo [!t:~0,-3!] timestamp enabled, .omwaddon files will not be backed up
		)
	) else (
		set omwllfoutput=!omwllfOut!.omwaddon
		set deltaoutput=!deltaOut!.omwaddon
	)
)

if not defined enableOmwllf goto beginDelta

if not defined pythonFolder set pythonFolder=python
call :appParser omwllfDir "omwllf.py"
if defined f_error goto end
if defined enableBackup if exist "!winpath!\!omwllfoutput!" call :backup "!winpath!\!omwllfoutput!"
set f_exomwllf=
if defined excludeOmwaddons set f_exomwllf=1
if defined enableOmwllfExcluder if defined modsOmwllfExcluder set f_exomwllf=1
if defined f_exomwllf call :changer "2o"
set "t=!time: =0!" & echo: & echo [!t:~0,-3!] omwllf writing to !winpath!\!omwllfoutput!
set "t=!time: =0!" & echo: & echo [!t:~0,-3!] running omwllf.py... & echo:
if defined enableSilent (
	"!pythonFolder!" "!omwllfDir!" -m "!omwllfoutput!" -d "!winpath!" > NUL 2>&1
) else (
	"!pythonFolder!" "!omwllfDir!" -m "!omwllfoutput!" -d "!winpath!"
)
if not !errorlevel! == 0 (
	set "t=!time: =0!" & echo: & echo: & echo [!t:~0,-3!] error returned by omwllf.py
	if not defined enableContinue (
		set f_error=1
		goto end
	)
)
if defined autoRewrite (
	set writeList=!omwllfOut!
	set rewriteList[!rewriteList[length]!]=!omwllfoutput!:*!omwllfOut!
	set /a rewriteList[length]=!rewriteList[length]!+1
)
set "t=!time: =0!" & echo: & echo [!t:~0,-3!] !omwllfoutput! written to !winpath!
if defined f_exomwllf call :restore

if defined enableDelay pause

:beginDelta

if not defined enableDelta goto end

call :appParser deltaDir "delta_plugin.exe"
if defined f_error goto end
if not exist "!winpath!" md "!winpath!"
if defined enableBackup if exist "!winpath!\!deltaoutput!" call :backup "!winpath!\!deltaoutput!"
set f_exdelta=
if defined excludeOmwaddons set f_exdelta=1
if defined enableDeltaExcluder if defined modsDeltaExcluder set f_exdelta=1
if defined f_exdelta call :changer "2d"
set "t=!time: =0!" & echo: & echo [!t:~0,-3!] delta writing to !winpath!\!deltaoutput!
set "t=!time: =0!" & echo: & echo [!t:~0,-3!] running delta_plugin.exe... & echo:
if defined enableSilent (
	"!deltaDir!" -q merge "!winpath!\!deltaoutput!" > NUL 2>&1
) else (
	"!deltaDir!" merge "!winpath!\!deltaoutput!"
)
if not !errorlevel! == 0 (
	set "t=!time: =0!" & echo: & echo: & echo [!t:~0,-3!] error returned by delta_plugin.exe
	set f_error=1
	goto end
)
if defined autoRewrite (
	set writeList=!writeList!!deltaOut!
	set rewriteList[!rewriteList[length]!]=!deltaoutput!:*!deltaOut!
	set /a rewriteList[length]=!rewriteList[length]!+1
)
set "t=!time: =0!" & echo: & echo [!t:~0,-3!] !deltaoutput! written to !winpath!

:end

if defined f_temp call :restore
set f_changer=
if !rewriteList[length]! GTR 0 set f_changer=1
if defined writeList set f_changer=1
if defined autoRewrite if defined f_changer (
	if not defined f_backup if defined enableBackup if exist "!output!" call :backup "!output!"
	set "t=!time: =0!" & echo: & echo [!t:~0,-3!] rewriting mod references...
	call :changer_re
	set "t=!time: =0!" & echo: & echo [!t:~0,-3!] mod references rewritten in !output!
	call :restore 1
)
if defined deleteLog if defined enableValidator if exist "!validatorLog!" (
	del "!validatorLog!"
	set "t=!time: =0!" & echo: & echo [!t:~0,-3!] validator log deleted
)
if defined runOpenmw if not defined f_error (
	for /f "usebackq tokens=*" %%i in (`powershell -command "Get-ItemPropertyValue -Path HKLM:\SOFTWARE\WOW6432Node\OpenMW.org\OpenMW* -Name '(Default)'"`) do (
		set omwexe=%%i
	)
	if defined omwexe (
		set "t=!time: =0!" & echo: & echo [!t:~0,-3!] running openmw.exe
		set omwexe=!omwexe!\openmw.exe
		start "" "!omwexe!"
	) else set "t=!time: =0!" & echo: & echo [!t:~0,-3!] openmw installation not found, cannot run
) else set "t=!time: =0!" & echo: & echo [!t:~0,-3!] error detected, openmw will not run
set "t=!time: =0!" & echo: & echo [!t:~0,-3!] process finished & echo:
pause
if not defined f_error (
	endlocal
	exit /b 0
) else (
	endlocal
	exit /b 1
)

@REM ################################ functions ################################

:backup
@REM no flag:	create .bak of %1
@REM flag %2:	create .tmp of %1

if "%~2" == "1" (
	copy "%~1" "%~1.tmp" > NUL
	set f_temp=1
) else (
	copy "%~1" "%~1.bak" > NUL
	set "t=!time: =0!" & echo: & echo [!t:~0,-3!] backed up %~1
)
exit /b

:restore
@REM no flag:	delete fileWin and replace with .tmp version
@REM flag %1:	delete fileWin.tmp

if "%~1" == "1" (
	if exist "!fileWin!.tmp" del "!fileWin!.tmp"
) else (
	if exist "!fileWin!.tmp" (
		if exist "!fileWin!" del "!fileWin!"
		ren "!fileWin!.tmp" "!omw!"
		set "t=!time: =0!" & echo: & echo [!t:~0,-3!] !omw! restored
	) else set "t=!time: =0!" & echo: & echo [!t:~0,-3!] !fileWin! could not be restored, temp file not found
)
set f_temp=
exit /b

:existence
@REM check if file %1 exists

if not exist "%~1" (
	set "t=!time: =0!" & echo: & echo [!t:~0,-3!] %~1 not found at expected location
	set f_error=1
)
exit /b

:appParser
@REM format app directory and check for existence
@REM flag %3:	app is in subdirectory, dir name has to be 3 characters

set varname=%~1
set appname=%~2
set varvalue=!%varname%!
set varvalue=!varvalue:/=\!
if "!varvalue:~0,1!" == "\" set varvalue=!varvalue:~1!
if "!varvalue:~-1!" == "\" set varvalue=!varvalue:~0,-1!
if "%~3" == "1" if "!varvalue:~-3!" == "!appname:~0,3!" set varvalue=!varvalue:~0,-4!
if "!varvalue:%appname%=!" == "!varvalue!" set varvalue=!varvalue!\%~2
set !varname!=!varvalue!
call :existence "!%varname%!"
exit /b

:changer
@REM changes function depending on %1, functions can be combined except for 2
@REM 1	converter
@REM 2o	omwllf excluder
@REM 2d	delta excluder
@REM 3	disabler
@REM 4	enabler

set mode=%~1
set modList=?
set fileList[length]=0
set modsToDisable=?
set f_change=
set f_disable=
set f_msg=
set counter_d=0
set counter_e=0
if not "!mode:1=!" == "!mode!" (
	if defined enableConvert set f_msg=1
) else if not "!mode:2=!" == "!mode!" (
	call :backup "!fileWin!" 1
	if not "!mode:2o=!" == "!mode!" (
		if defined enableOmwllfExcluder if defined modsOmwllfExcluder (
			set modsToDisable=!modsOmwllfExcluder!
			set "t=!time: =0!" & echo: & echo [!t:~0,-3!] excluding mods before running omwllf
			set f_disable=1
		)
	) else (
		if not "!mode:2d=!" == "!mode!" if defined enableDeltaExcluder if defined modsDeltaExcluder (
			set modsToDisable=!modsDeltaExcluder!
			set "t=!time: =0!" & echo: & echo [!t:~0,-3!] excluding mods before running delta
			set f_disable=1
		)
	)
	if defined excludeOmwaddonsFolder set "t=!time: =0!" & echo: & echo [!t:~0,-3!] excluding .omwaddon folder
	if defined excludeOmwaddons set "t=!time: =0!" & echo: & echo [!t:~0,-3!] excluding generated .omwaddon files
	set f_msg=1
)
if not "!mode:3=!" == "!mode!" if defined enableDisabler if defined modsDisabler (
	if "!modsToDisable!" == "?" (set modsToDisable=!modsDisabler!
	) else set modsToDisable=!modsToDisable!?!modsDisabler!
	set f_disable=1
)
if defined f_disable (
	set modsToDisable=!modsToDisable:? =?!
	set modsToDisable=!modsToDisable: ?=?!
	set modsToDisable=!modsToDisable:?=?-!
	set modList=-!modsToDisable!
	set f_change=1
)
if not "!mode:4=!" == "!mode!" if defined enableEnabler if defined modsEnabler (
	set modsEnabler=!modsEnabler:? =?!
	set modsEnabler=!modsEnabler: ?=?!
	set modsEnabler=!modsEnabler:?=?+!
	if "!modList!" == "?" (set modList=+!modsEnabler!
	) else set modList=!modList!?+!modsEnabler!
	set f_change=1
)
if not "!mode:2=!" == "!mode!" if defined excludeOmwaddonsFolder set f_checkTemp=1
if defined f_change (
	set f_msg=1
	set f_checkTemp=1
)
if defined enableCheck if defined f_checkTemp (
	set checkTemp=runme-!dt!.tmp
	break > !checkTemp!
)
if not "!modList!" == "?" (
	call :listParser "!modList!" "fileList"
	set /a fileListLen=!fileList[length]!-1
)
if defined disableSearchExact if !fileList[length]! GTR 0 (
	set /a len=!fileList[length]!-1
	for /l %%a in (0,1,!len!) do (
		set fileList[%%a][length]=0
		call :listParserDeluxe "!fileList[%%a]!" %%a
		set fileList[%%a][0]=!fileList[%%a][0]:~1!
	)
)
if defined f_msg set "t=!time: =0!" & echo: & echo [!t:~0,-3!] modifying !input!...
for /f "usebackq" %%f in (`type "!input!" ^| find /v /c ""`) do (set numoflines=%%f)
if "!numoflines!" == "0" (
	set "t=!time: =0!" & echo: & echo [!t:~0,-3!] !input! is zero bytes, no action will be taken
	goto :eof
)
set linenumber=
set line=
for /f "usebackq tokens=1* delims=]" %%i in (`type "!input!" ^| find /v /n "" ^& break ^> "!output!"`) do (
	set linenumber=%%i
	set line=%%j
	if defined line (
		if not "!mode:1=!" == "!mode!" (
			if defined enableConvert (
				if /i "!convertTo:a=!" == "!convertTo!" (
					if "!line:~0,4!" == "data" (
						if not "!line:~-2,1!" == "/" set line=!line:~0,-1!/"
						if not "!line:~6,1!" == "/" set line=!line:~0,6!/!line:~6!
					)
					if "!line:~0,6!" == "# data" (
						if not "!line:~-2,1!" == "/" set line=!line:~0,-1!/"
						if not "!line:~8,1!" == "/" set line=!line:~0,8!/!line:~8!
					)
					set line=!line:%folderAndData%=%folderWinData%!
					set line=!line:%folderAndMods%=%folderWinMods%!
					set line=!line:/=\!
					set line=!line:\\=\!
				) else (
					if "!line:~0,4!" == "data" if not "!line:~-2,1!" == "\" set line=!line:~0,-1!\"
					if "!line:~0,6!" == "# data" if not "!line:~-2,1!" == "\" set line=!line:~0,-1!\"
					set line=!line:%folderWinData%=%folderAndData%!
					set line=!line:%folderWinMods%=%folderAndMods%!
					set line=!line:\=/!
					set line=!line://=/!
				)
			)
		) else if not "!mode:2=!" == "!mode!" if not "!line:~0,1!" == "#" (
			if "!line:~0,7!" == "content" (
				if defined excludeOmwaddons (
					if not "!line:%omwllfOut%=!" == "!line!" if "!line:~-9!" == ".omwaddon" set line=# !line!
					if not "!line:%deltaOut%=!" == "!line!" if "!line:~-9!" == ".omwaddon" set line=# !line!
				)
			) else if "!line:~0,4!" == "data" if defined excludeOmwaddonsFolder if not "!folderOmwaddon!" == "\" (
				set pathtodirlist=
				if /i "!convertTo:a=!" == "!convertTo!" (
					if not "!line:%winpath%=!" == "!line!" (
						set line=# !line!
						set pathtodirlist=!winpath!
					)
				) else if not "!line:%andpath%=!" == "!line!" (
					set line=# !line!
					set pathtodirlist=!andpath!
				)
				if defined pathtodirlist if defined enableCheck (
					for /f "usebackq" %%f in (`type "!checkTemp!" ^| find /c "!pathtodirlist!"`) do (
						if "%%f" == "0" echo !pathtodirlist!>> !checkTemp!
					)
				)
			)
		)
		if defined f_change (
			for /l %%a in (0,1,!fileListLen!) do (
				set mod=!fileList[%%a]!
				set f_match=
				if defined disableSearchExact (
					set f_match=1
					set /a len2=!fileList[%%a][length]!-1
					for /l %%x in (0,1,!len2!) do (
						for /f "delims=" %%f in ("!fileList[%%a][%%x]!") do (set linereplace=!line:%%f=!)
						if "!linereplace!" == "!line!" set f_match=
					)
				) else (
					for /f "delims=" %%f in ("!mod:~1!") do (set linereplace=!line:%%f=!)
					if not "!linereplace!" == "!line!" set f_match=1
				)
				if defined f_match (
					if "!mod:~0,1!" == "-" (
						if not "!line:~0,1!" == "#" (
							if defined enableVerbose set "t=!time: =0!" & echo: & echo [!t:~0,-3!] disabling !linenumber!] !line!
							set line=# !line!
							set /a counter_d=!counter_d!+1
							if "!line:~2,4!" == "data" if defined enableCheck (
								for /f "usebackq" %%f in (`type "!checkTemp!" ^| find /c "!line:~8,-1!"`) do (
									if "%%f" == "0" echo !line:~8,-1!>> !checkTemp!
								)
							)
						)
					) else if "!mod:~0,1!" == "+" if "!line:~0,1!" == "#" (
						set templine=!line!
						set templine=!templine:# =#!
						set templine=!templine:#=!
						set f_mod=
						if "!templine:~0,5!" == "data=" set f_mod=1
						if "!templine:~0,8!" == "content=" set f_mod=1
						if "!templine:~0,9!" == "fallback=" set f_mod=1
						if "!templine:~0,17!" == "fallback-archive=" set f_mod=1
						if "!templine:~0,12!" == "groundcover=" set f_mod=1
						if defined f_mod (
							if defined enableVerbose set "t=!time: =0!" & echo: & echo [!t:~0,-3!] enabling !linenumber!] !line!
							set line=!templine!
							set /a counter_e=!counter_e!+1
							if defined enableCheck (
								for /f "tokens=1,2 delims==" %%f in ("!line!") do (
									set value=%%g
									if "%%f" == "data" (set value=!value:~1,-1!*!linenumber!
									) else set value=?!value!*!linenumber!
								)
								for /f "usebackq" %%f in (`type "!checkTemp!" ^| find /c "!value!"`) do (
									if "%%f" == "0" echo ?!value!>> !checkTemp!
								)
							)
						)
					)
				)
			)
		)
		if "!line:# Last modified on=!" == "!line!" echo !line!>> "!output!"
	) else echo:>> "!output!"
)
if "!mode:2=!" == "!mode!" if defined enableLastModified (
	set f_linechange=
	if defined enableConvert set f_linechange=1
	if !counter_d! GTR 0 set f_linechange=1
	if !counter_e! GTR 0 set f_linechange=1
	if defined f_linechange echo | set /p unused="# Last modified on !dt:~0,10! @ !dt:~11,2!:!dt:~13,2!:!dt:~15,2!">> "!output!"
)
if defined f_change set "t=!time: =0!" & echo: & echo [!t:~0,-3!] disabled !counter_d! lines, enabled !counter_e! lines
if defined enableCheck if defined f_checkTemp (
	set "t=!time: =0!" & echo: & echo [!t:~0,-3!] checking disabled/enabled lines...
	call :createRef "!output!"
	call :checker
	call :delRef
	set "t=!time: =0!" & echo: & echo [!t:~0,-3!] checked disabled/enabled lines
	if exist "!checkTemp!" del "!checkTemp!"
)
if defined f_msg set "t=!time: =0!" & echo: & echo [!t:~0,-3!] modified file saved to !output!
exit /b

:changer_re
@REM rewrites openmw.cfg, will write lines for the .omwaddon folder and the
@REM generated .omwaddon files if they're missing, and rewrite lines for the
@REM generated .omwaddon files if they're timestamped or mods if they're renamed
@REM by tes3cmd

set counter_r=0
call :backup "!fileWin!" 1
set /a rewriteListLen=!rewriteList[length]!-1
set f_omwfolder=
for /f "usebackq tokens=1* delims=]" %%i in (`type "!input!" ^| find /v /n "" ^& break ^> "!output!"`) do (
	set linenumber=%%i
	set line=%%j
	if defined line (
		if not "!line:~0,1!" == "#" (
			if /i "!convertTo:a=!" == "!convertTo!" (
				if not "!line:%winpath%=!" == "!line!" set f_omwfolder=1
			) else if not "!line:%andpath%=!" == "!line!" set f_omwfolder=1
			if not "!line:%omwllfOut%=!" == "!line!" if "!line:~-9!" == ".omwaddon" (
				if defined writeList for /f "delims=" %%f in ("!omwllfOut!") do (set writeList=!writeList:%%f=!)
			)
			if not "!line:%deltaOut%=!" == "!line!" if "!line:~-9!" == ".omwaddon" (
				if defined writeList for /f "delims=" %%f in ("!deltaOut!") do (set writeList=!writeList:%%f=!)
			)
			for /l %%a in (0,1,!rewriteListLen!) do (
				for /f "tokens=1,2 delims=:" %%x in ("!rewriteList[%%a]!") do (
					set modnew=%%x
					set modold=%%y
				)
				for /f "tokens=1,2 delims==" %%x in ("!line!") do (
					set f_write=
					if "!modold:~0,1!" == "*" (
						set linepost=%%y
						for /f "delims=" %%f in ("!modold:~1!") do (set linereplace=!linepost:%%f=!)
						if not "!linereplace!" == "!linepost!" if "!linepost:~-9!" == ".omwaddon" if not "!linepost!" == "!modnew!" set f_write=1
					) else if "%%y" == "!modold!" set f_write=1
					if defined f_write (
						if defined enableVerbose set "t=!time: =0!" & echo: & echo [!t:~0,-3!] rewriting !linenumber!] !line!
						set line=%%x=!modnew!
						set /a counter_r=!counter_r!+1
					)
				)
			)
		)
		if "!line:# Last modified on=!" == "!line!" echo !line!>> "!output!"
	) else echo:>> "!output!"
)
if not defined f_omwfolder (
	if defined line echo:>> "!output!"
	if /i "!convertTo:a=!" == "!convertTo!" (set pathtowrite=!winpath!
	) else set pathtowrite=!andpath!
	if defined enableVerbose set "t=!time: =0!" & echo: & echo [!t:~0,-3!] writing data="!pathtowrite!"
	echo data="!pathtowrite!">> "!output!"
	set /a counter_r=!counter_r!+1
)
if defined writeList (
	if defined line echo:>> "!output!"
	if not "!writeList:%omwllfOut%=!" == "!writeList!" (
		if defined enableVerbose set "t=!time: =0!" & echo: & echo [!t:~0,-3!] writing content=!omwllfoutput!
		echo content=!omwllfoutput!>> "!output!"
		set /a counter_r=!counter_r!+1
	)
	if not "!writeList:%deltaOut%=!" == "!writeList!" (
		if defined enableVerbose set "t=!time: =0!" & echo: & echo [!t:~0,-3!] writing content=!deltaoutput!
		echo content=!deltaoutput!>> "!output!"
		set /a counter_r=!counter_r!+1
	)
)
if !counter_r! GTR 0 if defined enableLastModified echo | set /p unused="# Last modified on !dt:~0,10! @ !dt:~11,2!:!dt:~13,2!:!dt:~15,2!">> "!output!"
set "t=!time: =0!" & echo: & echo [!t:~0,-3!] rewrote !counter_r! lines
exit /b

:listParser
@REM parses list %1 to recreate as an array using %2 as array name

for /f "tokens=1* delims=?" %%x in ("%~1") do (
	set var=%%x
	set var=!var:~1!
	if not "!var!" == "" (
		set var=!var: =!
		if not "!var!" == "" (
			set %~2[!%~2[length]!]=%%x
			set /a %~2[length]=!%~2[length]!+1
		)
	)
	if not "%%y" == "" call :listParser "%%y" "%~2"
)
exit /b

:listParserDeluxe
@REM parses list %1 to recreate as an 2d array where each array's value is the
@REM whole value and all sub-indexed values are the original value split by
@REM spaces, %2 is current index position

for /f "tokens=1* delims= " %%x in ("%~1") do (
	set fileList[%~2][!fileList[%~2][length]!]=%%x
	set /a fileList[%~2][length]=!fileList[%~2][length]!+1
	if not "%%y" == "" call :listParserDeluxe "%%y" %~2
)
exit /b

:checker
@REM reads temporary file checkTemp for any mods that have been enabled or
@REM disabled, checking disabled data paths for the existence of active mods and
@REM checking enabled mods and data paths to see if they exist

set enabledList[length]=0
set disabledList[length]=0
for /f "usebackq tokens=*" %%a in ("!checkTemp!") do (
	set mod=%%a
	if "!mod:~0,1!" == "?" (
		for /f "tokens=1,2 delims=*" %%x in ("!mod:~1!") do (
			set mod=%%x
			set linenumber=%%y
		)
		if "!mod:~0,1!" == "?" (
			set enabledList[!enabledList[length]!]=!mod:~1!
			set enabledListNums[!enabledList[length]!]=!linenumber!
			set /a enabledList[length]=!enabledList[length]!+1
		) else if not exist "!mod!" set "t=!time: =0!" & echo: & echo [!t:~0,-3!] enabled folder doesn't exist !linenumber!]: !mod!
	) else (
		if exist "!mod!" (
			for /f "usebackq delims=" %%l in (`dir /b /a-d "!mod!" 2^>nul`) do (
				set f_mod=
				if /i "%%~xl" == ".bsa" set f_mod=1
				if /i "%%~xl" == ".esm" set f_mod=1
				if /i "%%~xl" == ".esp" set f_mod=1
				if /i "%%~xl" == ".omwaddon" set f_mod=1
				if defined f_mod (
					set disabledList[!disabledList[length]!]=!mod!*%%l
					set /a disabledList[length]=!disabledList[length]!+1
				)
			)
		)
	)
)
if !enabledList[length]! GTR 0 (
	set /a enabledListLen=!enabledList[length]!-1
	for /f "usebackq tokens=*" %%x in ("!dataTemp!") do (
		set datapath=%%x
		if not "!datapath:~-1!" == "\" set datapath=!datapath!\
		for /l %%i in (0,1,!enabledListLen!) do (
			if exist "!datapath!!enabledList[%%i]!" set enabledList[%%i]=
		)
	)
	for /l %%i in (0,1,!enabledListLen!) do (
		if defined enabledList[%%i] set "t=!time: =0!" & echo: & echo [!t:~0,-3!] enabled mod doesn't exist !enabledListNums[%%i]!]: !enabledList[%%i]!
	)
)
if !disabledList[length]! GTR 0 (
	set modold=
	set /a disabledListLen=!disabledList[length]!-1
	for /f "usebackq tokens=1* delims=]" %%x in (`type "!output!" ^| find /v /n ""`) do (
		set line=%%y
		if defined line if not "!line:~0,1!" == "#" (
			set linenumber=%%x
			for /l %%i in (0,1,!disabledListLen!) do (
				for /f "tokens=1,2 delims=*" %%a in ("!disabledList[%%i]!") do (
					set mod=%%a
					set file=%%b
				)
				for /f "delims=" %%a in ("!file!") do (set linereplace=!line:%%a=!)
				if not "!linereplace!" == "!line!" (
					if not "!modold!" == "!mod!" (
						set "t=!time: =0!" & echo: & echo [!t:~0,-3!] disabled folder: !mod!
						set modold=!mod!
					)
					set "t=!time: =0!" & echo: & echo [!t:~0,-3!] -- contains active mod !linenumber!]: !file!
				)
			)
		)
	)
)
exit /b

:readWarning
@REM read validatorLog and output formatted warnings to screen

echo:
set foutput=
for /f "usebackq delims=" %%i in ("!validatorLog!") do (
	set line=%%i
	if defined foutput (
		set var=!line:~20!
		if defined var (
			if not "!var:Validation completed=!" == "!var!" (goto :eof
			) else echo !var!
		) else echo:
	) else if "!line:~29,27!" == "Some problems were detected" set foutput=1
)
exit /b

:patcherMain
@REM Takes a list of mods %1, path to patcher app %2, and commands to run %3 and
@REM executes the commands on the mods if those mods exist in any data folder,
@REM creates file patcherLog to track output from patcher app to read and output
@REM errors and add successfully patched mods to rewriteList if applicable

set modList=%~1
set modList=!modList:? =?!
set modList=!modList: ?=?!
set patchList[length]=0
set usepath=%~2
set commands=%~3
set commands=!commands:""="!
set patcherLog=!ceedee!\%~n2-!dt!.log
set "t=!time: =0!" & echo: & echo [!t:~0,-3!] creating !patcherLog!
break > !patcherLog!
set f_cleaned=
call :createRef "!fileWin!"
call :listParser "!modList!" "patchList"
set /a patchListLen=!patchList[length]!-1
for /f "usebackq tokens=*" %%x in ("!dataTemp!") do (
	set datapath=%%x
	if not "!datapath:~-1!" == "\" set datapath=!datapath!\
	for /l %%i in (0,1,!patchListLen!) do (
		set modpath=!datapath!!patchList[%%i]!
		if exist "!modpath!" (
			set "t=!time: =0!" & echo: & echo [!t:~0,-3!] patching !modpath!...
			!commands! "!modpath!" >> !patcherLog! 2>&1
			set f_cleaned=1
		)
	)
)
call :delRef
if defined f_cleaned (
	for /f "usebackq tokens=*" %%i in ("!patcherLog!") do (
		set line=%%i
		if not "!line:Output saved in=!" == "!line!" (
			set line=!line:~18,-1!
			for %%l in ("!line!") do (set line=%%~nxl)
			if defined autoRewrite (
				set rewriteList[!rewriteList[length]!]=!line!:!line:~6!
				set /a rewriteList[length]=!rewriteList[length]!+1
			)
		) else (
			if not "!line:was not modified=!" == "!line!" (
				set "t=!time: =0!" & echo: & echo [!t:~0,-3!] !line!
			) else (
				if not "!line:FATAL ERROR=!" == "!line!" (
					set "t=!time: =0!" & echo: & echo [!t:~0,-3!] !line!
					set f_error=1
				) else (
					if not "!line:error occured=!" == "!line!" (
						set "t=!time: =0!" & echo: & echo [!t:~0,-3!] !line!
						set f_error=1
					)
				)
			)
		)
	)
	set "t=!time: =0!" & echo: & echo [!t:~0,-3!] cleaning done
)
set "t=!time: =0!" & echo: & echo [!t:~0,-3!] deleting !patcherLog!
if exist "!patcherLog!" del "!patcherLog!"
exit /b

:createRef
@REM create temp reference file using path and name of file %1, the created
@REM dataTemp file is a list of all data paths in file %1

set dataTemp=!ceedee!\%~n1-!dt!.tmp
break > !dataTemp!
for /f "usebackq eol=# delims=" %%i in ("%~1") do (
	set line=%%i
	if "!line:~0,4!" == "data" echo !line:~6,-1!>> !dataTemp!
)
exit /b

:delRef
@REM delete temp reference file

if exist "!dataTemp!" del "!dataTemp!"
exit /b
