@echo off

REM ----------------------------------------------------------------------------
REM --------- openmw android windows validator omwllf delta batch file ---------
REM ----------------------------------------------------------------------------

REM the default is that android openmw.cfg as well as the validator, omwllf and
REM delta folders all reside in the same folder as this batch file, but you can
REM modify it all, by default the android openmw.cfg will be in
REM /sdcard/omw_nightly/config/, your folder name might be a bit different from
REM this depending on your OpenMW build, and the default windows openmw.cfg will
REM be in %userprofile%\Documents\My Games\OpenMW\, remember all names are case
REM sensitive, avoid using the following special characters in names:
REM [!, <, >, |, &, ^, =, :, ', ", ?], enter values inside existing quotes
REM immediately after the equal signs, do not change the variable names, if you
REM have large mod lists then it may seem like the script has frozen but it can
REM take upto several minutes depending on the number of files being processed
REM and the power of your PC, there are some random bugs that I couldn't seem to
REM replicate enough times to diagnose, usually the script still executes fine
REM and other times just running it again seems to solve the errors

REM this option is for users who are using file or folder names containing
REM non-Latin characters, modify just the number in the line below with the
REM correct codepage identifier for your language, the default value covers
REM Latin letters only, which this code and default values are all written in
REM exclusively, if you are seeing errors in names then your letters aren't
REM being recognised and you must use a custom codepage identifier, changing
REM this value may show some errors but the script should execute fine, check
REM the following link for the correct identifier code for your characters:
REM https://learn.microsoft.com/en-us/windows/win32/intl/code-page-identifiers
chcp 1252 > NUL

REM NOTE: this batch file assumes all folders exist and contain the right files,
REM all .cfg and .omwaddon files and their backups will be overwritten without
REM prompt so make sure to rename files you want this script to ignore
set "backup="

REM set value to 1 to add a date and time stamp to the end of the file name for
REM both the omwllf and delta output files, added before the extension, format
REM is not region-specific
set "timestamp="

REM set value to 1 to run omwllf.py and delta_plugin.exe in silent mode,
REM neither will output anything to screen including errors, but this batch file
REM will still output to screen
set "silent="

REM set value to 1 to pause after each step to allow reading output
set "delay="

REM set value to 1 to use windows mode which skips converting android paths,
REM instead the input is set to the default windows openmw.cfg, if used with the
REM disable files or folder option this will create a temporary 1:1 copy of the
REM .cfg file and disable entries in the original copies and after execution
REM it will delete the modified .cfg and rename the temporary back to the
REM original so date modified is unchanged
set "winMode="

REM set value to 1 to enable conversion of openmw.cfg and disabling .omwaddon
REM files and folder (see below), do not skip unless you have a properly
REM configured windows openmw.cfg with omwllf/delta .omwaddon files disabled or
REM else you will have issues with the apps, if using this in windows mode and
REM the script cannot finish you can still recover the original .cfg file by
REM going to the folder with the .cfg file and simply renaming the .tmp file
REM back to the .cfg extension
set "convertEnabled=1"

REM set value to 1 to disable the .omwaddon files containing the names of the
REM generated files defined below, make sure to enable this to not cause issues
REM with the apps trying to read them as mods, names that only partially match
REM and are .omwaddon files will also be disabled
set "disableFiles="

REM set value to 1 to disable the .omwaddon folder, use this if you don't store
REM other mod files in this folder, implies above option so files will also be
REM disabled, will not disable base Mods folder even if base mods folder is
REM output for .omwaddon files, will cause errors in the apps if folder contains
REM other mod files that haven't been disabled manually
set "disableFolder=1"

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
REM use /sdcard instead of /storage/emulated/0, no default value
set "folderData=/sdcard/Download/openmw/Morrowind/Data Files"

REM location of Data Files folder on windows, must already contain all base game
REM and expansion .bsa and .esm files, no default value
set "replaceData=D:\Morrowind\Data Files"

REM location of Mods folder on android, must match paths in openmw.cfg, use
REM /sdcard instead of /storage/emulated/0, no default value
set "folderMod=/sdcard/Download/openmw/Morrowind/Mod Files"

REM location of Mods folder on windows, must already contain all mods from the
REM android openmw.cfg in the same folder structure, including all .esm and .esp
REM files, no default value
set "replaceMod=D:\Morrowind\Mod Files"

REM name of folder for .omwaddon files generated by omwllf and delta, must match
REM paths in openmw.cfg and be inside Mods folder, can include subfolders, if
REM the omwaddon files are in the base Mods folder then just leave blank, if
REM folder doesn't exist and either omwllf or delta is enabled it will be
REM created
set "omwaddonFolder=LAST"

REM note: the file names of the apps used by this script are hard-coded and will
REM not be recognised if the file names have been changed, only folder names can
REM be modified

REM set to 1 to run openmw-validator
set "validatorEnabled=1"

REM set value to 1 to open the generated validator log file after executing
REM openmw-validator command, it is recommended you use Notepad++ or another
REM 3rd-party text editor as your default notepad because the log file can get
REM pretty large and Notepad will struggle to load it
set "openLog=1"

REM set value to 1 to delete the generated validator log file at the end of
REM execution
set "deleteLog=1"

REM location of openmw-validator.exe, can be relative or absolute, this app
REM does not output to screen so check log for errors with your openmw.cfg
set "validatorDir=openmw-validator-1.7"

REM set to 1 to run OMWLLF
set "omwllfEnabled=1"

REM location of omwllf.py, can be relative or absolute path
set "omwllfDir=omwllf-master"

REM name of .omwaddon file generated by omwllf.py, outputs to omwaddonFolder,
REM name must match name in android openmw.cfg, or if using date and time
REM stamp then name must match name of stamped entry in openmw.cfg file
REM excluding stamp portion
set "omwllfOut=omwllf.omwaddon"

REM set to 1 to run DeltaPlugin
set "deltaEnabled=1"

REM location of delta_plugin.exe, can be relative or absolute path
set "deltaDir=delta-plugin-0.17.1-windows-amd64"

REM name of .omwaddon file generated by delta_plugin.exe, outputs to
REM omwaddonFolder, name must match name in android openmw.cfg, or if using date
REM and time stamp then name must match name of stamped entry in openmw.cfg file
REM excluding stamp portion
set "deltaOut=delta.omwaddon"

REM END OF USER MODIFIABLE VARIABLES, do not modify anything below unless you
REM know what you are doing, this script cannot create or delete folders but it
REM can overwrite any file with a matching folder and file name or backup name
REM without prompting so be careful when creating or modifying batch files

REM ----------------------------------------------------------------------------

setlocal enabledelayedexpansion

echo:
if "!winMode!" == "1" (echo ^>^>^>^> running script, windows mode & echo:
) else echo ^>^>^>^> running script, android mode & echo:

if "!silent!" == "1" echo ^>^>^>^> silent mode & echo:

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
set omwaddonFolder=!omwaddonFolder:/=\!
if "!omwaddonFolder:~0,1!" == "\" set omwaddonFolder=!omwaddonFolder:~1!
if "!omwaddonFolder:~-1!" == "\" set omwaddonFolder=!omwaddonFolder:~0,-1!
if "!omwaddonFolder!" == "" set omwaddonFolder=\

set addonComb=!replaceMod!!omwaddonFolder!

if not "!omwllfOut:.omwaddon=!" == "!omwllfOut!" set omwllfOut=!omwllfOut:.omwaddon=!
if not "!deltaOut:.omwaddon=!" == "!deltaOut!" set deltaOut=!deltaOut:.omwaddon=!

if not "!convertEnabled!" == "1" goto validatorBegin

set omw=openmw.cfg
set outputMask=%userprofile%\Documents\My Games\OpenMW\!omw!
if "!output!" == "" set output=!outputMask!
if not "!output:~-4!" == ".cfg" set output=!output!\!omw!

if "!winMode!" == "1" (
	set input=!output!.tmp
	if "!convertEnabled!" == "1" copy "!output!" "!output!.tmp" > NUL
) else (
	if "!input!" == "" set input=!omw!
	if not "!input:~-4!" == ".cfg" set input=!input!\!omw!
)

if not exist !input! (
	echo ^>^>^>^> !input! not found at expected location & echo:
	goto end
)
echo ^>^>^>^> !input! found & echo:

if "!backup!" == "1" if not "!winMode!" == "1" if exist "!output!" (
	copy "!output!" "!output!.bak" > NUL
	echo ^>^>^>^> backed up !output! & echo:
)

if "!disableFolder!" == "1" set disableFiles=1
set omwComb=!replaceMod!!omwaddonFolder!
for /f "delims=" %%i in ('type "!input!" ^& break ^> "!output!"') do (
	set line=%%i
	if not "!winMode!" == "1" (
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
	if "!disableFiles!" == "1" (
		if "!line:~0,7!" == "content" (
			if not "!line:%omwllfOut%=!" == "!line!" if "!line:~-9!" == ".omwaddon" set line=# !line!
			if not "!line:%deltaOut%=!" == "!line!" if "!line:~-9!" == ".omwaddon" set line=# !line!
		)
		if "!disableFolder!" == "1" if not "!omwaddonFolder!" == "\" if not "!line:~0,1!" == "#" (
			set omwComb=!omwComb:/=\!
			set omwComb=!omwComb:\\=\!
			if not "!line:%omwComb%=!" == "!line!" set line=# !line!
		)
	)
	>> "!output!" echo !line!
)

echo ^>^>^>^> finished converting !output! & echo:

if not "!output!" == "!outputMask!" (
	echo ^>^>^>^> output location modified, cannot run validator/omwllf/delta & echo:
	goto end
)

if "!delay!" == "1" pause & echo:

:validatorBegin

set returnDir=!cd!

if not "!validatorEnabled!" == "1" goto omwllfBegin

set validatorDir=!validatorDir:/=\!
if "!validatorDir:~0,1!" == "\" set validatorDir=!validatorDir:~1!
if "!validatorDir:openmw-validator.exe=!" == "!validatorDir!" set validatorDir=!validatorDir!\openmw-validator.exe

if not exist "!validatorDir!" (
	echo ^>^>^>^> !validatorDir! not found at expected location & echo:
	goto end
)

if not "!validatorDir:openmw-validator.exe=!" == "!validatorDir!" set validatorDir=!validatorDir:openmw-validator.exe=!

pushd !validatorDir!
echo ^>^>^>^> running openmw-validator.exe & echo:
set "validatorLog="
for /f "tokens=*" %%i in ('openmw-validator') do (set validatorLog=%%i)
set validatorLog=!validatorLog:Validation completed, log written to: =!
if not "!validatorLog:~-4!" == ".log" (
	echo ^>^>^>^> error returned by openmw-validator.exe & echo:
	goto end
)
if "!openLog!" == "1" (
	start "" "!validatorLog!"
)
echo ^>^>^>^> openmw-validator.exe finished, log saved to: !validatorLog! & echo:

if "!delay!" == "1" pause & echo:

:omwllfBegin

set newDir=!addonComb!
if "!omwllfOut:.omwaddon=!" == "!omwllfOut!" set omwllfOut=!omwllfOut!.omwaddon
if "!deltaOut:.omwaddon=!" == "!deltaOut!" set deltaOut=!deltaOut!.omwaddon

if "!timestamp!" == "1" (
	set omwllfOut=!omwllfOut:.omwaddon=!
	set deltaOut=!deltaOut:.omwaddon=!
	set "dt="
	for /f "tokens=*" %%i in ('powershell get-date -format "yyyy-MM-dd-HHmmss"') do (set dt=%%i)
	set omwllfOut=!omwllfOut!-!dt!.omwaddon
	set deltaOut=!deltaOut!-!dt!.omwaddon
	if "!backup!" == "1" (
		set "backup="
		echo ^>^>^>^> timestamp enabled, .omwaddon files will not be backed up & echo:
	)
)

if not "!omwllfEnabled!" == "1" goto deltaBegin

cd "!returnDir!"
set omwllfDir=!omwllfDir:/=\!
if "!omwllfDir:~0,1!" == "\" set omwllfDir=!omwllfDir:~1!
if "!omwllfDir:omwllf.py=!" == "!omwllfDir!" set omwllfDir=!omwllfDir!\omwllf.py
if not exist "!omwllfDir!" (
	echo ^>^>^>^> !omwllfDir! not found at expected location & echo:
	goto end
)
set omwllfDir=!omwllfDir:omwllf.py=!
cd "!omwllfDir!"

if "!backup!" == "1" (
	if exist "!newDir!" (
		pushd "!newDir!"
		if exist "!omwllfOut!" (
			copy "!omwllfOut!" "!omwllfOut!.bak" > NUL
			echo ^>^>^>^> backed up !omwllfOut! & echo:
		)
		popd
	)
)

echo ^>^>^>^> running omwllf.py & echo:
echo ^>^>^>^> omwllf writing to !newDir!\!omwllfOut! & echo:
if "!silent!" == "1" (
	python omwllf.py -m "!omwllfOut!" -d "!newDir!" > NUL
) else (
	python omwllf.py -m "!omwllfOut!" -d "!newDir!"
)
if !errorlevel! == 1 (
	echo:
	echo ^>^>^>^> error returned by omwllf.py & echo:
	goto end
)
echo:
echo ^>^>^>^> !omwllfOut! written to !addonComb! & echo:

if "!delay!" == "1" pause & echo:

:deltaBegin

if not "!deltaEnabled!" == "1" goto end

cd "!returnDir!"
set deltaDir=!deltaDir:/=\!
if "!deltaDir:~0,1!" == "\" set deltaDir=!deltaDir:~1!
if "!deltaDir:delta_plugin.exe=!" == "!deltaDir!" set deltaDir=!deltaDir!\delta_plugin.exe
if not exist "!deltaDir!" (
	echo ^>^>^>^> !deltaDir! not found at expected location & echo:
	goto end
)
set deltaDir=!deltaDir:delta_plugin.exe=!

if not exist "!newDir!" (
	md "!newDir!"
)

if "!backup!" == "1" (
	pushd "!newDir!"
	if exist "!deltaOut!" (
		copy "!deltaOut!" "!deltaOut!.bak" > NUL
		echo ^>^>^>^> backed up !deltaOut! & echo:
	)
	popd
)

cd "!deltaDir!"
echo ^>^>^>^> running delta_plugin.exe & echo:
echo ^>^>^>^> delta writing to !newDir!\!deltaOut! & echo:
if "!silent!" == "1" (
	delta_plugin -q merge "!newDir!\!deltaOut!" > NUL
) else (
	delta_plugin merge "!newDir!\!deltaOut!"
)
if !errorlevel! == 1 (
	echo:
	echo ^>^>^>^> error returned by delta_plugin.exe & echo:
	goto end
)
echo:
echo ^>^>^>^> !deltaOut! written to !addonComb! & echo:

:end

if "!validatorEnabled!" == "1" if "!deleteLog!" == "1" (
	del "!validatorLog!"
	echo ^>^>^>^> validator log deleted & echo:
)
if "!winMode!" == "1" if "!convertEnabled!" == "1" (
	if exist "!output!.tmp" (
		del "!output!"
		ren "!output!.tmp" "!omw!"
	) else (
		echo ^>^>^>^> !output! could not be restored, temp file not found & echo:
	)
)
echo ^>^>^>^> process finished & echo:
cd "!returnDir!" & pause
exit
