@echo off

setlocal enabledelayedexpansion

REM ----------------------------------------------------------------------------
REM ----------- openmw android windows validator omwllf delta script -----------
REM ----------------------------------------------------------------------------

REM to use defaults, place the android openmw.cfg (if applicable) as well as the
REM validator, omwllf and delta folders in the same folder as this batch file,
REM by default the android openmw.cfg will be in "/sdcard/omw_nightly/config/",
REM your folder name might be a bit different depending on your OpenMW build,
REM use "/sdcard" instead of "/storage/emulated/0", the default windows copy is
REM in "%userprofile%\Documents\My Games\OpenMW\", you can modify the
REM input/output folders and the name of the .cfg as well as folders for the
REM apps, and you can choose the output folder and names of the .omwaddon files,
REM android users need to change values for folderData, replaceData, folderMod,
REM replaceMod, and omwaddonFolder, and windows users only need to change the
REM last two

REM this script tries to correct for some errors and checks for some files but
REM also makes many assumptions, including assuming the .cfg file is formatted
REM in the correct way and does not contain the following special characters
REM (!, <, >, |, &, ^, =, :, ", `, ?), all values are case-sensitive, enter
REM values inside existing quotes immediately after the equal signs, do not
REM change the variable names, if you have large mod lists then it may seem like
REM the script has frozen but it can take upto several minutes depending on the
REM number of files being processed and the specs of your PC

REM there are some random bugs that I couldn't seem to replicate enough times to
REM diagnose, usually the script still executes fine and other times just
REM running it again seems to solve the errors, this script can overwrite any
REM file matching any name provided and their backup copies as well so manually
REM backup any files you don't want to accidentally overwrite

REM this option is for users who are using file or folder names containing
REM non-Latin characters, modify just the number in the line below with the
REM correct codepage identifier for your language, the default value covers
REM Latin letters only, which this code and default values are all written in
REM exclusively, if you are seeing errors in names then your letters aren't
REM being recognised and you must use a custom codepage identifier, changing
REM this value may show some errors but the script should execute fine, check
REM the following link for the correct identifier number for your characters:
REM https://learn.microsoft.com/en-us/windows/win32/intl/code-page-identifiers
chcp 1252 > NUL

REM name of a configuration file to use to load variables for this script, you
REM can enter values for variables below in the user variables section or you
REM can import them from a file, this batch file comes with a sample
REM variables.cfg file that contains all user variable names and default values,
REM the file can be modified like the openmw.cfg file, variable definitions
REM below will only be used if this value is empty
set "varFile=variables2.cfg"

if not "!varFile!" == "" goto skip

REM ----------------------- beginning of user variables ------------------------

REM set value to 1 to backup .cfg and .omwaddon files before overwriting, will
REM ovewrite previous backup copy
set "enableBackup=1"

REM set value to 1 to add a date and time stamp to the end of the file name for
REM both the omwllf and delta output files, added before the extension, format
REM is not region-specific
set "enableTimestamp="

REM set value to 1 to run omwllf.py and delta_plugin.exe in silent mode,
REM neither will output anything to screen including errors, but this script
REM will still output to screen
set "enableSilent="

REM set value to 1 to pause after each step to allow reading output
set "enableDelay="

REM set value to 1 to use windows mode which skips converting android paths,
REM instead the input is set to the default windows openmw.cfg, if used with the
REM disable files or folder option this will create a temporary copy of the .cfg
REM file and disable entries in the original copy and after execution it will
REM delete the modified .cfg and rename the temporary back to the original so
REM date modified is unchanged
set "windowsMode="

REM set value to 1 to enable conversion of openmw.cfg, this will allow android
REM copies of openmw.cfg to be converted to windows paths, and disabling output
REM .omwaddon files and folder, as well as specified mods for compatibility
REM reasons, before running the apps, do not skip unless you have a properly
REM configured windows openmw.cfg with omwllf/delta .omwaddon files disabled or
REM else you will have issues with the apps, if using this in windows mode and
REM the script cannot finish you can still recover the original .cfg file by
REM going to the folder with the .cfg file and simply renaming the .tmp file
REM back to the .cfg extension
set "enableConvert=1"

REM set value to 1 to disable the .omwaddon files containing the names of the
REM generated files defined below, make sure to enable this to not cause issues
REM with the apps trying to read them as mods, names that only partially match
REM and are .omwaddon files will also be disabled
set "disableFiles="

REM set value to 1 to disable the .omwaddon folder, use this if you don't store
REM other mod files in this folder, implies above option so files will also be
REM disabled, will not disable base Mods folder even if base mods folder is
REM output for .omwaddon files, will cause errors in the apps if folder contains
REM other mod files that haven't been disabled manually or added to the
REM exclusion list below
set "disableFolder=1"

REM set value to 1 to disable the mods or folders listed below before running
REM the apps
set "enableExclude="

REM list the exact names of the mod files (.bsa/.esm/.esp/.omwaddon), ideally
REM including extension, that should be disabled prior to execution of apps, you
REM can also include folders to be disabled, folders can be android or windows
REM paths or just the name of the folder, do not include the names of the
REM generated .omwaddon files from omwllf/delta as those are disabled elsewhere,
REM names are separated by commas so file or folder names with commas should be
REM renamed, will disable every instance of each mod or folder listed including
REM content, fallback, groundcover, and data lines, include folder names if mods
REM disabled are only files in those folders, do not split this value into
REM several lines, this does not use partial matching
set "excludeMods="

REM location of android version of openmw.cfg on windows, can be a folder, if
REM file name not provided then openmw.cfg will be used, if left blank will
REM assume file name is openmw.cfg and located in the same folder as this
REM batch file, can be relative or absolute path
set "input="

REM location of windows version of openmw.cfg, all three apps will look for
REM openmw.cfg where windows openmw usually puts it, so leave this blank unless
REM you want to override defaults, if modified then no apps will run, if file
REM name not provided then openmw.cfg will be used, and if folder not provided
REM but file name is provided then will output file to the same folder as this
REM batch file
set "output="

REM location of Data Files folder on android, must match paths in openmw.cfg,
REM no default value
set "folderData=ANDROID USERS MUST PROVIDE A VALUE HERE"

REM location of Data Files folder on windows, must already contain all base game
REM and expansion .bsa and .esm files, no default value
set "replaceData=ANDROID USERS MUST PROVIDE A VALUE HERE"

REM location of Mods folder on android, must match paths in openmw.cfg, no
REM default value
set "folderMod=ANDROID USERS MUST PROVIDE A VALUE HERE"

REM location of Mods folder on windows, must already contain all mods from the
REM android openmw.cfg in the same folder structure, including all .esm and .esp
REM files, no default value
set "replaceMod=ANDROID/WINDOWS USERS MUST PROVIDE A VALUE HERE"

REM name of folder for .omwaddon files generated by omwllf and delta, must match
REM paths in openmw.cfg and be inside Mods folder, can include subfolders, if
REM the omwaddon files are in the base Mods folder then just leave blank, if
REM folder doesn't exist and either omwllf or delta is enabled it will be
REM created, if folder not listed in openmw.cfg do not forget to add it along
REM with the generated .omwaddon files to your openmw.cfg before running game
set "omwaddonFolder=ANDROID/WINDOWS USERS MUST PROVIDE A VALUE HERE"

REM the file names of the apps used by this script are hard-coded and will not
REM be recognised if the file names have been changed, only folder names can be
REM modified, if for whatever reason you wish to run apps with different names
REM you can search the code for instances of each file name and replace them

REM set value to 1 to run openmw-validator
set "enableValidator=1"

REM set value to 1 to open the generated validator log file after executing
REM openmw-validator command, it is recommended you use Notepad++ or another
REM 3rd-party text editor as your default notepad because the log file can get
REM pretty large and Notepad will struggle to load it
set "openLog="

REM set value to 1 to delete the generated validator log file at the end of
REM execution
set "deleteLog="

REM location of openmw-validator.exe, can be relative or absolute, this app
REM does not output to screen so check log for errors with your openmw.cfg
set "validatorDir=openmw-validator-1.7"

REM set value to 1 to run OMWLLF
set "enableOmwllf=1"

REM python must be installed for OMWLLF, set a custom path for python.exe here
REM if it is not inside the windows PATH variable, leave blank otherwise
set "pythonFolder="

REM location of omwllf.py, can be relative or absolute path
set "omwllfDir=omwllf-master"

REM name of .omwaddon file generated by omwllf.py, outputs to omwaddonFolder,
REM name must match name in android openmw.cfg, or if using date and time
REM stamp then name must match name of stamped entry in openmw.cfg file
REM excluding stamp portion
set "omwllfOut=omwllf.omwaddon"

REM set value to 1 to run DeltaPlugin
set "enableDelta=1"

REM location of delta_plugin.exe, can be relative or absolute path
set "deltaDir=delta-plugin-0.17.1-windows-amd64"

REM name of .omwaddon file generated by delta_plugin.exe, outputs to
REM omwaddonFolder, name must match name in android openmw.cfg, or if using date
REM and time stamp then name must match name of stamped entry in openmw.cfg file
REM excluding stamp portion
set "deltaOut=delta.omwaddon"

REM -------------------------- end of user variables ---------------------------

:skip

if not "!varFile!" == "" (
	for /f "usebackq tokens=1,2 delims==" %%i in ("!varFile!") do (
		set name=%%i
		if not "!name:~0,1!" == "#" set !name!=%%j
	)
)

echo:
if "!windowsMode!" == "1" (call :writer "running script in windows mode"
) else call :writer "running script in android mode"

if not "!varFile!" == "" call :writer "variables read from !varFile!"

if "!enableSilent!" == "1" call :writer "silent mode"

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
if "!omwaddonFolder!" == "" set omwaddonFolder=\
if not "!omwllfOut:.omwaddon=!" == "!omwllfOut!" set omwllfOut=!omwllfOut:.omwaddon=!
if not "!deltaOut:.omwaddon=!" == "!deltaOut!" set deltaOut=!deltaOut:.omwaddon=!
set excludeMods=!excludeMods:, =,!

if not "!enableConvert!" == "1" goto validatorBegin

if "!disableFolder!" == "1" set disableFiles=1
if "!windowsMode!" == "1" if "!enableConvert!" == "1" if not "!disableFiles!" == "1" (
	call :writer "conversion does nothing in windows mode if disabling files isn't enabled"
	goto validatorBegin
)

set outputMask=%userprofile%\Documents\My Games\OpenMW
if not exist "!outputMask!" md "%userprofile%\Documents\My Games\OpenMW\"
set omw=openmw.cfg
set outputMask=!outputMask!\!omw!
if "!output!" == "" set output=!outputMask!
if not "!output:~-4!" == ".cfg" set output=!output!\!omw!

if "!windowsMode!" == "1" (
	set input=!output!.tmp
	copy "!output!" "!output!.tmp" > NUL
) else (
	if "!input!" == "" set input=!omw!
	if not "!input:~-4!" == ".cfg" set input=!input!\!omw!
)

if not exist !input! (
	call :writer "!input! not found at expected location" 1
	goto end
)
call :writer "!input! found"

if "!enableBackup!" == "1" if not "!windowsMode!" == "1" if exist "!output!" (
	copy "!output!" "!output!.bak" > NUL
	call :writer "backed up !output!"
)

for /f "tokens=1* delims=]" %%i in ('type "!input!" ^| find /v /n "" ^& break ^> "!output!"') do (
	set line=%%j
	if not "!line!" == "" (
		if not "!windowsMode!" == "1" (
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
		)
		if not "!line:~0,1!" == "#" (
			if "!enableExclude!" == "1" call :parser "!excludeMods!"
			if not "!line:~0,1!" == "#" if "!disableFiles!" == "1" (
				if "!line:~0,7!" == "content" (
					if not "!line:%omwllfOut%=!" == "!line!" if "!line:~-9!" == ".omwaddon" set line=# !line!
					if not "!line:%deltaOut%=!" == "!line!" if "!line:~-9!" == ".omwaddon" set line=# !line!
				)
				if not "!line:~0,1!" == "#" if "!disableFolder!" == "1" if not "!omwaddonFolder!" == "\" if not "!line:%addonComb%=!" == "!line!" set line=# !line!
			)
		)
		echo !line!>> "!output!"
	) else echo:>> "!output!"
)

call :writer "finished converting !output!"

if not "!output!" == "!outputMask!" (
	call :writer "output location modified, cannot run validator/omwllf/delta" 1
	goto end
)

if "!enableDelay!" == "1" pause"

:validatorBegin

if not "!enableValidator!" == "1" goto omwllfBegin

set validatorDir=!validatorDir:/=\!
if "!validatorDir:~0,1!" == "\" set validatorDir=!validatorDir:~1!
if "!validatorDir:openmw-validator.exe=!" == "!validatorDir!" set validatorDir=!validatorDir!\openmw-validator.exe

if not exist "!validatorDir!" (
	call :writer "!validatorDir! not found at expected location" 1
	goto end
)

call :writer "running openmw-validator.exe"
for /f "tokens=*" %%i in ('"!validatorDir!"') do (set validatorLog=%%i)
set validatorLog=!validatorLog:Validation completed, log written to: =!
if not "!validatorLog:~-4!" == ".log" (
	call :writer "error returned by openmw-validator.exe" 1
	goto end
)
if "!openLog!" == "1" (
	start "" "!validatorLog!"
)
call :writer "openmw-validator.exe finished, log saved to: !validatorLog!"

if "!enableDelay!" == "1" pause"

:omwllfBegin

if "!addonComb:~-1!" == "\" set addonComb=!addonComb:~0,-1!
if "!omwllfOut:.omwaddon=!" == "!omwllfOut!" set omwllfOut=!omwllfOut!.omwaddon
if "!deltaOut:.omwaddon=!" == "!deltaOut!" set deltaOut=!deltaOut!.omwaddon

if "!enableTimestamp!" == "1" (
	set omwllfOut=!omwllfOut:.omwaddon=!
	set deltaOut=!deltaOut:.omwaddon=!
	for /f "tokens=*" %%i in ('powershell get-date -format "yyyy-MM-dd-HHmmss"') do (set dt=%%i)
	set omwllfOut=!omwllfOut!-!dt!.omwaddon
	set deltaOut=!deltaOut!-!dt!.omwaddon
	if "!enableBackup!" == "1" (
		set "enableBackup="
		call :writer "timestamp enabled, .omwaddon files will not be backed up"
	)
)

if not "!enableOmwllf!" == "1" goto deltaBegin

if "!pythonFolder!" == "" set pythonFolder=python
set omwllfDir=!omwllfDir:/=\!
if "!omwllfDir:~0,1!" == "\" set omwllfDir=!omwllfDir:~1!
if "!omwllfDir:omwllf.py=!" == "!omwllfDir!" set omwllfDir=!omwllfDir!\omwllf.py
if not exist "!omwllfDir!" (
	call :writer "!omwllfDir! not found at expected location" 1
	goto end
)

if "!enableBackup!" == "1" (
	if exist "!addonComb!\!omwllfOut!" (
		copy "!addonComb!\!omwllfOut!" "!addonComb!\!omwllfOut!.bak" > NUL
		call :writer "backed up !omwllfOut!"
	)
)

call :writer "running omwllf.py"
call :writer "omwllf writing to !addonComb!\!omwllfOut!"
if "!enableSilent!" == "1" (
	"!pythonFolder!" "!omwllfDir!" -m "!omwllfOut!" -d "!addonComb!" > NUL
) else (
	"!pythonFolder!" "!omwllfDir!" -m "!omwllfOut!" -d "!addonComb!"
)
if !errorlevel! == 1 (
	echo:
	call :writer "error returned by omwllf.py" 1
	goto end
)
echo:
call :writer "!omwllfOut! written to !addonComb!"

if "!enableDelay!" == "1" pause"

:deltaBegin

if not "!enableDelta!" == "1" goto end

set deltaDir=!deltaDir:/=\!
if "!deltaDir:~0,1!" == "\" set deltaDir=!deltaDir:~1!
if "!deltaDir:delta_plugin.exe=!" == "!deltaDir!" set deltaDir=!deltaDir!\delta_plugin.exe
if not exist "!deltaDir!" (
	call :writer "!deltaDir! not found at expected location" 1
	goto end
)

if not exist "!addonComb!" md "!addonComb!"

if "!enableBackup!" == "1" (
	if exist "!addonComb!\!deltaOut!" (
		copy "!addonComb!\!deltaOut!" "!addonComb!\!deltaOut!.bak" > NUL
		call :writer "backed up !deltaOut!"
	)
)

call :writer "running delta_plugin.exe"
call :writer "delta writing to !addonComb!\!deltaOut!"
if "!enableSilent!" == "1" (
	"!deltaDir!" -q merge "!addonComb!\!deltaOut!" > NUL
) else (
	"!deltaDir!" merge "!addonComb!\!deltaOut!"
)
if !errorlevel! == 1 (
	echo:
	call :writer "error returned by delta_plugin.exe" 1
	goto end
)
echo:
call :writer "!deltaOut! written to !addonComb!"

:end

if "!enableValidator!" == "1" if "!deleteLog!" == "1" if exist "!validatorLog!" (
	del "!validatorLog!"
	call :writer "validator log deleted"
)

if "!windowsMode!" == "1" if "!enableConvert!" == "1" (
	if exist "!output!.tmp" (
		if exist "!output!" del "!output!"
		ren "!output!.tmp" "!omw!"
	) else (
		call :writer "!output! could not be restored, temp file not found"
	)
)

call :writer "process finished"
pause
exit /b !ex!

:parser
set var=%~1
for /f "tokens=1* delims=," %%a in ("!var!") do (
	set ax=%%a
	if not "!ax:/=!" == "!ax!" (
		set ax=!ax:%folderData%=!
		set ax=!ax:%folderMod%=!
	) else if not "!ax:\=!" == "!ax!" (
		set ax=!ax:%replaceData%=!
		set ax=!ax:%replaceMod%=!
	) 
	if not "!line:%ax%=!" == "!line!" (
		set line=# !line!
		goto continue
	)
	if not "%%b" == "" call :parser "%%b"
)
:continue
exit /b

:writer
set t=!time: =0!
echo ^>^>^>^> [!t:~0,-3!] %~1 & echo:
if not "%~2" == "" set ex=%~2
exit /b
