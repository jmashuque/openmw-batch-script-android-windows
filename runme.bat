@echo off

setlocal enabledelayedexpansion

REM ############################################################################
REM ###### OpenMW Android/Windows Validator/OMWLLF/DeltaPlugin Batch File ######
REM ############################################################################

REM to use defaults, place the android openmw.cfg (if applicable) as well as the
REM validator, omwllf and delta folders in the same folder as this batch file,
REM by default the android openmw.cfg will be in "/sdcard/omw_nightly/config/",
REM your folder name might be a bit different depending on your OpenMW build,
REM use "/sdcard" instead of "/storage/emulated/0", the default windows copy is
REM in "Documents\My Games\OpenMW\", you can modify the input/output folders and
REM the name of the .cfg as well as folders for the apps, and you can choose the
REM output folder and names of the .omwaddon files, android users need to change
REM values for folderData, replaceData, folderMod, replaceMod, and
REM omwaddonFolder, and windows users only need to change the last two

REM this script tries to correct for some errors and checks for some files but
REM also makes many assumptions, including assuming the .cfg file is formatted
REM in the correct way and does not contain the following special characters
REM (!, <, >, |, &, ^, =, :, ", `, ?), all values are case-sensitive, enter
REM values inside existing quotes immediately after the equal signs, do not
REM change the variable names, this script disables mods by adding "# " at the
REM beginning of a line but it can enable lines that have a combination of "#"
REM and "# " disabling the lines

REM if you have large mod lists or exclude many mods it may seem like the
REM script has frozen but it can take upto several minutes depending on the
REM number of files being processed and the specs of your PC

REM there are some random bugs that I couldn't seem to replicate enough times to
REM diagnose, usually the script still executes fine and other times just
REM running it again seems to solve the errors, this script can overwrite any
REM file matching any name provided and their backup or temp copies as well so
REM manually backup any files you don't want to accidentally overwrite

REM note: the file names of the apps used by this script are hard-coded and will
REM not be recognised if the file names have been changed, only folder names can
REM be modified

REM this option is for users who are using file or folder names containing
REM non-Latin characters, modify just the number in the line below with the
REM correct codepage identifier for your language, the default value covers
REM Latin letters, if you are seeing errors in names then your letters aren't
REM being recognised and you must use a custom codepage identifier, changing
REM this value may show some errors but the script should execute fine, check
REM the following link for the correct identifier number for your characters:
REM https://learn.microsoft.com/en-us/windows/win32/intl/code-page-identifiers
chcp 1252 > NUL

REM name of a configuration file to use to load variables for this script, you
REM can enter values for variables below in the user variables section or you
REM can import them from a file, this batch file comes with a variables.txt
REM file that contains all user variable names and default values, the file can
REM be modified like the openmw.cfg file, variable definitions below will only
REM be used if this value is empty
set "varFile=variables.txt"

if defined varFile goto skipVar

REM ####################### beginning of user variables ########################

REM set to "android" to use regular operating settings, set to "windows" to skip
REM conversion, set to "writeonly" to skip running the apps and if output is
REM blank use input as output using a temp file, and set to "reverse" to use
REM output as input and vice versa and also convert windows paths to android
set "mode="

REM set value to 1 to backup .cfg and .omwaddon files before overwriting, will
REM ovewrite previous backup copy
set "enableBackup="

REM set value to 1 to add a date and time stamp to the end of the file name for
REM both the omwllf and delta output files, added before the extension, format
REM is not region-specific
set "enableTimestamp="

REM set value to 1 to run omwllf.py and delta_plugin.exe in silent mode,
REM neither will output anything to screen including errors
set "enableSilent="

REM set value to 1 to pause after each step to allow reading output
set "enableDelay="

REM set value to 1 to enable continuing to next step even if an error is raised
REM by one of the apps
set "enableContinue="

REM set value to 1 to clear the command prompt screen before running the file
set "enableCls="

REM set value to 1 to enable conversion of openmw.cfg, this will allow android
REM copies of openmw.cfg to be converted to windows paths, do not skip unless
REM you have a properly configured windows openmw.cfg located in right folder,
REM reads from input and writes to output
set "enableConvert="

REM set value to 1 to disable every line matching each mod or folder listed in
REM the next variable, reads and writes to output file
set "enableDisabler="

REM list names of mods or folders to disable, only works if above variable is
REM enabled, uses partial matching so mod names should contain file extension
REM if you want just a mod disabled and not its folder, matches with any line
REM containing the entire name provided, folder paths can be fragments, relative
REM or absolute and can be either android or windows, use a question mark (?)
REM between each file or folder name and do not put more than one space before
REM or after the (?)
set "modsDisabler="

REM set value to 1 to enable every line matching each mod or folder listed in
REM the next variable, reads and writes to output file
set "enableEnabler="

REM list names of mods or folders to enable, only works if above variable is
REM enabled, uses partial matching so mod names should contain file extension
REM if you want just a mod disabled and not its folder, matches with any line
REM containing the entire name provided, folder paths can be fragments, relative
REM or absolute and can be either android or windows, use a question mark (?)
REM between each file or folder name and do not put more than one space before
REM or after the (?)
set "modsEnabler="

REM location of android version of openmw.cfg on windows, can be a folder, if
REM file name not provided then openmw.cfg will be used, if left blank will
REM assume file name is openmw.cfg and located in the same folder as this
REM batch file, can be relative or absolute path
set "input="

REM location of windows version of openmw.cfg, all three apps will look for
REM openmw.cfg where windows openmw usually puts it, so leave this blank unless
REM you want to override defaults, if file name not provided then openmw.cfg
REM will be used, and if folder not provided but file name is provided then will
REM output file to the same folder as this batch file
set "output="

REM location of Data Files folder on android, must match paths in openmw.cfg,
REM no default value
set "folderData="

REM location of Data Files folder on windows, must already contain all base game
REM and expansion .bsa and .esm files, no default value
set "replaceData="

REM location of Mods folder on android, must match paths in openmw.cfg, no
REM default value
set "folderMod="

REM location of Mods folder on windows, must already contain all mods from the
REM android openmw.cfg in the same folder structure, including all .esm and .esp
REM files, no default value
set "replaceMod="

REM name of folder for .omwaddon files generated by omwllf and delta, must match
REM paths in openmw.cfg and be inside Mods folder, can include subfolders, if
REM the omwaddon files are in the base Mods folder then just leave blank, if
REM folder doesn't exist and either omwllf or delta is enabled it will be
REM created, if folder not listed in openmw.cfg do not forget to add it along
REM with the generated .omwaddon files to the end of your openmw.cfg before
REM running the game
set "omwaddonFolder="

REM set value to 1 to disable the .omwaddon files containing the names of the
REM generated files by omwllf/delta defined below, make sure to enable this to
REM not cause issues with the apps trying to read them as regular mods, names
REM that partially match and are .omwaddon files will also be disabled so
REM timestamped entries will be disabled too
set "excludeOmwaddons="

REM set value to 1 to disable the .omwaddon folder, use this if you don't store
REM other mod files in this folder, implies above option so files will also be
REM disabled, will not disable base Mods folder even if base mods folder is
REM output for .omwaddon files, will cause errors in the apps if folder contains
REM other mod files that haven't been disabled manually or added to the
REM exclusion list below
set "excludeOmwaddonsFolder="

REM set value to 1 to check disabled folders for active mods once all items have
REM been disabled, including after disabling mods for each app and the .omwaddon
REM folder, this process may take some time if you specify many folders to
REM disable
set "enableCheck="

REM set value to 1 to run openmw-validator
set "enableValidator="

REM set value to 1 to open the generated validator log file after executing
REM openmw-validator command, it is recommended you use Notepad++ or another
REM 3rd-party text editor as your default notepad because the log file can get
REM pretty large and Notepad will struggle to load it
set "openLog="

REM set value to 1 to delete the generated validator log file at the end of
REM execution, note that if other apps aren't enabled and you enable open log,
REM the validator log might be deleted before it finishes loading on your text
REM editor, you will have to disable this to be able to read the log
set "deleteLog="

REM location of openmw-validator.exe, can be relative or absolute, this app
REM does not output to screen so check log for errors with your openmw.cfg
set "validatorDir="

REM set value to 1 to run OMWLLF
set "enableOmwllf="

REM python must be installed for OMWLLF, set a custom path for python.exe here
REM if it is not inside the windows PATH variable, leave blank otherwise
set "pythonFolder="

REM location of omwllf.py, can be relative or absolute path
set "omwllfDir="

REM name of .omwaddon file generated by omwllf.py, outputs to omwaddonFolder,
REM name must match name in your openmw.cfg, if using date and time stamp the
REM stamp will be applied at the end of file name before the file extension
set "omwllfOut="

REM set value to 1 to disable the mods or folders listed below before running
REM omwllf
set "enableOmwllfExcluder="

REM list names of mods or folders to disable before running omwllf.py, only
REM works if above variable is enabled, same rules as modsDisabler variable
set "modsOmwllfExcluder="

REM set value to 1 to run DeltaPlugin
set "enableDelta="

REM location of delta_plugin.exe, can be relative or absolute path
set "deltaDir="

REM name of .omwaddon file generated by delta_plugin.exe, outputs to
REM omwaddonFolder, name must match name in your openmw.cfg, if using date and
REM time stamp the stamp will be applied at the end of file name before the file
REM extension
set "deltaOut="

REM set value to 1 to disable the mods or folders listed below before running
REM delta
set "enableDeltaExcluder="

REM list names of mods or folders to disable before running delta_plugin.exe,
REM only works if above variable is enabled, same rules as modsDisabler variable
set "modsDeltaExcluder="

REM ########################## end of user variables ###########################

:skipVar

if defined varFile (
	if exist !varFile! (
		for /f "usebackq tokens=1,2 eol=# delims==" %%i in ("!varFile!") do (set %%i=%%j)
	) else (
		call :out "var file not found"
		set "error=1" & goto end
	)
)

if defined enableClear cls

echo:
if defined varFile call :out "variables read from !varFile!"
if defined enableSilent call :out "silent, no app output"
set error=0

for /f "tokens=*" %%i in ('powershell -command "'!mode!'.ToLower()"') do (set mode=%%i)
for /f "usebackq tokens=*" %%i in (`powershell -command "Join-Path ([environment]::GetFolderPath('mydocuments')) 'My Games\OpenMW'"`) do (set outputMask=%%i)
if not exist "!outputMask!" md "!outputMask!"
set omw=openmw.cfg
set outputMask=!outputMask!\!omw!
if not defined input set input=!omw!
if not "!input:~-4!" == ".cfg" set input=!input!\!omw!

if "!mode!" == "writeonly" (
	call :out "running script in write-only mode, no apps will run"
	set enableValidator=
	set enableOmwllf=
	set enableDelta=
) else (
	if not defined output set output=!outputMask!
	if not "!output:~-4!" == ".cfg" set output=!output!\!omw!
	if "!mode!" == "reverse" (
		call :out "running script in reverse mode"
		set var=!input!
		set input=!output!
		set output=!var!
	) else (	
		if "!mode!" == "windows" (
			call :out "running script in windows mode, conversion is disabled"
			set enableConvert=
		) else (
			if "!mode!" == "android" (
				call :out "running script in android mode"
			) else (
				call :out "mode not recognised"
				set "error=1" & goto end
			)
		)
	)
)

set folderData=!folderData:\=/!
if not "!folderData:~0,1!" == "/" set folderData=/!folderData!
if not "!folderData:~-1!" == "/" set folderData=!folderData!/
set folderMod=!folderMod:\=/!
if not "!folderMod:~0,1!" == "/" set folderMod=/!folderMod!
if not "!folderMod:~-1!" == "/" set folderMod=!folderMod!/
set replaceData=!replaceData:/=\!
if not "!replaceData:~-1!" == "\" set replaceData=!replaceData!\
set replaceMod=!replaceMod:/=\!
if not "!replaceMod:~-1!" == "\" set replaceMod=!replaceMod!\
set addonComb=!replaceMod!!omwaddonFolder!
set addonComb=!addonComb:/=\!
set addonComb=!addonComb:\\=\!
if "!addonComb:~-1!" == "\" set addonComb=!addonComb:~0,-1!
if not defined omwaddonFolder set omwaddonFolder=\
if not "!omwllfOut:.omwaddon=!" == "!omwllfOut!" set omwllfOut=!omwllfOut:.omwaddon=!
if not "!deltaOut:.omwaddon=!" == "!deltaOut!" set deltaOut=!deltaOut:.omwaddon=!

if "!mode!" == "writeonly" if not defined output (
	set output=!input!
	call :backup "!output!" 1
	set input=!output!.tmp
)

if defined enableConvert set fbackup=1
if defined enableDisabler set fbackup=1
if defined enableEnabler set fbackup=1
if defined fbackup if defined enableBackup if exist "!output!" call :backup "!output!"

if not defined enableConvert goto beginDisabler

call :existence "!input!"
if "!error!" == "1" goto end
call :out "!input! found"
call :out "converting..."
call :converter
call :out "converted file saved to !output!"
if "!mode!" == "writeonly" call :restore 1

if defined enableDelay pause

:beginDisabler

if defined enableDisabler set fcopy=1
if defined enableEnabler set fcopy=1
if defined fcopy if "!mode!" == "writeonly" if not defined enableConvert if not exist "!output!" copy "!input!" "!output!" > NUL

call :existence "!output!"
if "!error!" == "1" goto end
set input=!output!.tmp

if not defined enableDisabler goto beginEnabler

if defined enableDisabler if defined modsDisabler (
	call :changerCaller "!modsDisabler!"
	call :restore 1
)

if defined enableDelay pause

:beginEnabler

if not defined enableEnabler goto beginValidator

if defined modsEnabler if defined modsEnabler (
	call :changerCaller "!modsEnabler!" 1
	call :restore 1
)

if defined enableDelay pause

:beginValidator

if not "!output!" == "!outputMask!" (
	set output=!outputMask!
	call :existence "!output!"
	if "!error!" == "1" goto end
	set input=!output!.tmp
)

for /f "tokens=*" %%i in ('powershell get-date -format "yyyy-MM-dd-HHmmss"') do (set dt=%%i)

if not defined enableValidator goto beginOmwllf

set validatorDir=!validatorDir:/=\!
if "!validatorDir:~0,1!" == "\" set validatorDir=!validatorDir:~1!
if "!validatorDir:openmw-validator.exe=!" == "!validatorDir!" set validatorDir=!validatorDir!\openmw-validator.exe
call :existence "!validatorDir!"
if "!error!" == "1" goto end
set validatecom="!validatorDir!" --cfg "!outputMask!" --out "!outputMask:~0,-10!validator-!dt!.log"
call :out "running openmw-validator.exe..."
for /f "usebackq tokens=*" %%i in (`"!validatecom!"`) do (set validatorLog=%%i)
set validatorLog=!validatorLog:Validation completed, log written to: =!
if not "!validatorLog:~-4!" == ".log" (
	call :out "error returned by openmw-validator.exe"
	if not defined enableContinue set "error=1" & goto end
)

for /f "usebackq" %%c in (`type "!validatorLog!" ^| find /v /c ""`) do (set validatorCount=%%c)
set /a "validatorCount=!validatorCount!-4"
set skipline=usebackq skip=!validatorCount! delims=
for /f "%skipline%" %%i in ("!validatorLog!") do (
	set toProcess=%%i
	goto skipValidator
)

:skipValidator

if not "!toProcess:No problems detected=!" == "!toProcess!" (call :out "openmw-validator.exe finished, no errors reported"
) else call :out "openmw-validator.exe finished, reported some errors were found"

call :out "log saved to !validatorLog!"

if defined openLog start "" "!validatorLog!"

if defined enableDelay pause

:beginOmwllf

if "!omwllfOut:.omwaddon=!" == "!omwllfOut!" set omwllfOut=!omwllfOut!.omwaddon
if "!deltaOut:.omwaddon=!" == "!deltaOut!" set deltaOut=!deltaOut!.omwaddon

if defined enableTimestamp (
	set omwllfOut=!omwllfOut:.omwaddon=!
	set deltaOut=!deltaOut:.omwaddon=!
	
	set omwllfOut=!omwllfOut!-!dt!.omwaddon
	set deltaOut=!deltaOut!-!dt!.omwaddon
	if defined enableBackup (
		set enableBackup=
		call :out "timestamp enabled, .omwaddon files will not be backed up"
	)
)

if defined excludeOmwaddonsFolder (
	set excludeOmwaddons=1
	if not "!omwaddonFolder!" == "\" (
		if defined enableOmwllfExcluder (
			if defined modsOmwllfExcluder (set modsOmwllfExcluder=!modsOmwllfExcluder!?#!addonComb!
			) else set modsOmwllfExcluder=#!addonComb!
		) else set modsOmwllfExcluder=#!addonComb!
		if defined enableDeltaExcluder (
			if defined modsDeltaExcluder (set modsDeltaExcluder=!modsDeltaExcluder!?#!addonComb!
			) else set modsDeltaExcluder=#!addonComb!
		) else set modsDeltaExcluder=#!addonComb!
	)
)
if defined excludeOmwaddons (
	set enableOmwllfExcluder=1
	set enableDeltaExcluder=1
)

if not defined enableOmwllf goto beginDelta

if not defined pythonFolder set pythonFolder=python
set omwllfDir=!omwllfDir:/=\!
if "!omwllfDir:~0,1!" == "\" set omwllfDir=!omwllfDir:~1!
if "!omwllfDir:omwllf.py=!" == "!omwllfDir!" set omwllfDir=!omwllfDir!\omwllf.py
call :existence "!omwllfDir!"
if "!error!" == "1" goto end
if defined enableBackup if exist "!addonComb!\!omwllfOut!" call :backup "!addonComb!\!omwllfOut!"

if defined enableOmwllfExcluder if defined modsOmwllfExcluder call :changerCaller "!modsOmwllfExcluder!"
call :out "omwllf writing to !addonComb!\!omwllfOut!"
call :out "running omwllf.py..."
if defined enableSilent (
	"!pythonFolder!" "!omwllfDir!" -m "!omwllfOut!" -d "!addonComb!" > NUL 2>&1
) else (
	"!pythonFolder!" "!omwllfDir!" -m "!omwllfOut!" -d "!addonComb!"
)
if !errorlevel! == 1 (
	echo:
	call :out "error returned by omwllf.py"
	if not defined enableContinue set "error=1" & goto end
)
if defined enableOmwllfExcluder if defined modsOmwllfExcluder call :restore
echo:
call :out "!omwllfOut! written to !addonComb!"

if defined enableDelay pause

:beginDelta

if not defined enableDelta goto end

set deltaDir=!deltaDir:/=\!
if "!deltaDir:~0,1!" == "\" set deltaDir=!deltaDir:~1!
if "!deltaDir:delta_plugin.exe=!" == "!deltaDir!" set deltaDir=!deltaDir!\delta_plugin.exe
call :existence "!deltaDir!"
if "!error!" == "1" goto end
if not exist "!addonComb!" md "!addonComb!"
if defined enableBackup if exist "!addonComb!\!deltaOut!" call :backup "!addonComb!\!deltaOut!"

if defined enableDeltaExcluder if defined modsDeltaExcluder call :changerCaller "!modsDeltaExcluder!"
call :out "delta writing to !addonComb!\!deltaOut!"
call :out "running delta_plugin.exe..."
if defined enableSilent (
	"!deltaDir!" -q merge "!addonComb!\!deltaOut!" > NUL 2>&1
) else (
	"!deltaDir!" merge "!addonComb!\!deltaOut!"
)
if !errorlevel! == 1 (
	echo:
	call :out "error returned by delta_plugin.exe"
	set "error=1" & goto end
)
if defined enableDeltaExcluder if defined modsDeltaExcluder call :restore
echo:
call :out "!deltaOut! written to !addonComb!"

:end

if "!ftemp!" == "1" call :restore

if defined enableValidator if defined deleteLog if exist "!validatorLog!" (
	del "!validatorLog!"
	call :out "validator log deleted"
)

call :out "process finished"
pause
exit /b !error!

REM ################################ functions #################################

:out

set t=!time: =0!
echo [!t:~0,-3!] %~1 & echo:
exit /b

:backup

if "%~2" == "1" (
	copy "%~1" "%~1.tmp" > NUL
	set ftemp=1
) else (
	copy "%~1" "%~1.bak" > NUL
	call :out "backed up %~1"
)
exit /b

:restore

if "%~1" == "1" (
	if exist "!output!.tmp" del "!output!.tmp"
) else (
	if exist "!output!.tmp" (
		if exist "!output!" del "!output!"
		ren "!output!.tmp" "!omw!"
	) else call :out "!output! could not be restored, temp file not found"
)
set ftemp=0
exit /b

:existence

if not exist "%~1" (
	call :out "%~1 not found at expected location"
	set "error=1"
)
exit /b

:converter

set freverse=
if "!mode!" == "reverse" set freverse=1
if "!mode!" == "reverseonly" set freverse=1
for /f "usebackq tokens=1* delims=]" %%i in (`type "!input!" ^| find /v /n "" ^& break ^> "!output!"`) do (
	set line=%%j
	if defined line (		
		if not defined freverse (
			if "!line:~0,4!" == "data" (
				if not "!line:~-2,1!" == "/" set line=!line:~0,-1!/"
				if not "!line:~6,1!" == "/" set line=!line:~0,6!/!line:~6!
			)
			if "!line:~0,6!" == "# data" (
				if not "!line:~-2,1!" == "/" set line=!line:~0,-1!/"
				if not "!line:~8,1!" == "/" set line=!line:~0,8!/!line:~8!
			)
			set line=!line:%folderData%=%replaceData%!
			set line=!line:%folderMod%=%replaceMod%!
			set line=!line:/=\!
			set line=!line:\\=\!
		) else (
			if "!line:~0,4!" == "data" if not "!line:~-2,1!" == "\" set line=!line:~0,-1!\"
			if "!line:~0,6!" == "# data" if not "!line:~-2,1!" == "\" set line=!line:~0,-1!\"
			set line=!line:%replaceData%=%folderData%!
			set line=!line:%replaceMod%=%folderMod%!
			set line=!line:\=/!
			set line=!line://=/!
		)
		echo !line!>> "!output!"
	) else echo:>> "!output!"
)
exit /b

:changerCaller

set modList=%~1
set modList=!modList:? =?!
set modList=!modList: ?=?!
set fileList=?
set dirList=?
call :backup "!output!" 1
if not "%~2" == "1" (
	call :out "disabling mods..."
	call :changer "!modList!"
	call :out "mods disabled"
	if "!enableCheck!" == "1" if not "!dirList!" == "?" (
		call :out "checking disabled folders..."
		call :out "dirlist: !dirList!"
		call :checker "!dirList!"
		call :out "checked disabled folders"
	)
) else (
	call :out "enabling mods..."
	call :changer "!modList!" 1
	call :out "mods enabled"
)
exit /b

:changer

if "%~2" == "1" (set fenable=1
) else set fenable=
set freverse=
if "!mode!" == "reverse" set freverse=1
if "!mode!" == "reverseonly" set freverse=1
call :listParser "%~1"
for /f "usebackq tokens=1* delims=]" %%i in (`type "!input!" ^| find /v /n "" ^& break ^> "!output!"`) do (
	set line=%%j
	if defined line (
		if not defined fenable if defined excludeOmwaddons if "!line:~0,7!" == "content" (
			if not "!line:%omwllfOut%=!" == "!line!" if "!line:~-9!" == ".omwaddon" set line=# !line!
			if not "!line:%deltaOut%=!" == "!line!" if "!line:~-9!" == ".omwaddon" set line=# !line!
		)
		call :parser "!fileList!"
		echo !line!>> "!output!"
	) else echo:>> "!output!"
)
exit /b

:listParser

set var=%~1
for /f "tokens=1* delims=?" %%x in ("!var!") do (
	set ax=%%x
	set fl=
	for /f "tokens=*" %%i in ('powershell -command "'!ax!'.ToLower()"') do (set axl=%%i)
	if "!fenable!" == "1" set fl=1
	if not "!fl!" == "1" if "!ax:~0,1!" == "#" (
		set "fl=1"
		set "ax=!ax:~1!"
	)
	if not "!fl!" == "1" if "!axl:~-4!" == ".bsa" set fl=1
	if not "!fl!" == "1" if "!axl:~-4!" == ".esm" set fl=1
	if not "!fl!" == "1" if "!axl:~-4!" == ".esp" set fl=1
	if not "!fl!" == "1" if "!axl:~-9!" == ".omwaddon" set fl=1
	if "!fileList:%%ax%%=!" == "!fileList!" (
		if "!fileList!" == "?" (set fileList=!ax!
		) else set fileList=!fileList!?!ax!
	)
	if not defined fl (		
		if not defined freverse (
			set ax=!ax:%folderData%=%replaceData%!
			set ax=!ax:%folderMod%=%replaceMod%!
			set ax=!ax:/=\!
			set ax=!ax:\\=\!
			if not "!ax:%replaceData%=!" == "!ax!" set fl=1
			if not "!ax:%replaceMod%=!" == "!ax!" set fl=1
		) else (
			set ax=!ax:%replaceData%=%folderData%!
			set ax=!ax:%replaceMod%=%folderMod%!
			set ax=!ax:\=/!
			set ax=!ax://=/!
			if not "!ax:%folderData%=!" == "!ax!" set fl=1
			if not "!ax:%folderMod%=!" == "!ax!" set fl=1
		)
		if "!fl!" == "1" (
			if "!dirList:%%ax%%=!" == "!dirList!" (
				if "!dirList!" == "?" (set dirList=!ax!
				) else set dirList=!dirList!?!ax!
			)
		) else call :dirParser "!ax!"
	)
	if not "%%y" == "" call :listParser "%%y"
)
exit /b

:dirParser

set part=%~1
for /f "usebackq delims=" %%i in ("!output!") do (
	set line=%%i
	if not "!line:/=!" == "!line!" goto skipDirParser
	if "!line:~0,4!" == "data" if not "!line:%part%=!" == "!line!" (
		set lineSeg=!line:~6,-1!
		if "!dirList:%%lineSeg%%=!" == "!dirList!" (
			if "!dirList!" == "?" (set dirList=!lineSeg!
			) else set dirList=!dirList!?!lineSeg!
			set fl=1
		)
	)
	if "!line:~2,4!" == "data" if not "!line:%part%=!" == "!line!" (
		set lineSeg=!line:~8,-1!
		if "!dirList:%%lineSeg%%=!" == "!dirList!" (
			if "!dirList!" == "?" (set dirList=!lineSeg!
			) else set dirList=!dirList!?!lineSeg!
			set fl=1
		)
	)
)

:skipDirParser

exit /b

:parser

set var=%~1
for /f "tokens=1* delims=?" %%a in ("!var!") do (
	if not "!line:%%a=!" == "!line!" (
		if not defined fenable (if "!line:#=!" == "!line!" set line=# !line!
		) else if not "!line:#=!" == "!line!" (
			set line=!line:# =#!
			set line=!line:#=!
		)
		goto skipParser
	)
	if not "%%b" == "" call :parser "%%b"
)

:skipParser

exit /b

:checker

for /f "tokens=1* delims=?" %%a in ("%~1") do (
	set folder=%%a
	set cFiles=?
	if exist "!folder!" (
		for /f "usebackq delims=" %%l in (`dir /b /a-d "!folder!" 2^>nul`) do (
			set cFile=%%l
			if "!cFiles!" == "?" (set cFiles=!cFile!
			) else set cFiles=!cFiles!?!cFile!
		)
		if not "!cFiles!" == "?" (
			for /f "usebackq eol=# delims=" %%i in ("!output!") do (
				set line=%%i
				call :dirChecker "!cFiles!"
			)
		)
	) else call :out "folder to disable doesn't exist: !folder!"
	if not "%%b" == "" call :checker "%%b"
)
exit /b

:dirChecker

for /f "tokens=1* delims=?" %%a in ("%~1") do (
	if not "!line:%%a=!" == "!line!" (
		call :out "disabled folder: !folder!"
		call :out "   contains active mod: %%a"
	) else if not "%%b" == "" call :dirChecker "%%b"
)
exit /b
