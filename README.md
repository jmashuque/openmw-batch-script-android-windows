<h1>Batch File for OpenMW Android/Windows Users to Automatically Modify openmw.cfg, Run openmw-validator, and Generate OMWLLF/DeltaPlugin .omwaddon Files</h1>

This is a simple yet highly functional and customisable batch file that will completely automate the process of validating your android or windows openmw.cfg file using <strong><a href="https://mw.moddinghall.com/file/28-openmw-validator">openmw-validator</a></strong> (by <strong><a href="https://hristos.co/">Hristos N. Triantafillou</a></strong>), and then creating .omwaddon files from both <strong><a href="https://github.com/jmelesky/omwllf">OMWLLF</a></strong> (by <strong><a href="https://github.com/jmelesky">John Melesky</a></strong>) and <strong><a href="https://gitlab.com/bmwinger/delta-plugin/-/releases">DeltaPlugin</a></strong> (by <strong><a href="https://gitlab.com/bmwinger">Benjamin Winger</a></strong>). All you need is your android or windows openmw.cfg file and the three apps, and the script does the rest. This script will take the windows or android openmw.cfg file, edit every line to change android paths to corresponding windows paths, disable relevant .omwaddon folder/files, save the new openmw.cfg file into the default OpenMW folder on windows, and then run the three apps and output the .omwaddon files into the user's chosen folder. This is for people like me who do not use a mod manager and prefer a hands-on approach. If you're sick of modifying the windows openmw.cfg file and then running every app each time you make a change to your mod list, then this is my solution for you.

<br>After weeks of painstakingly modding OpenMW android, one mod at a time, trying different versions and alternatives, checking compatibility, consulting several mod lists and trying to combine them, having to repeatedly change and generate the files, disabling the generated files and additional mods that aren't compatible with DeltaPlugin, and finally coming to the conclusion that there's gotta be an easier way. It started off as a simple script of less than fifteen lines. But I kept adding more and more functionality. Eventually I decided there must be others out there who could make use of this script too. So I started expanding it so others could easily modify values and use the features they need. I had to learn a lot about batch files to do this script, I hope it makes your life a little easier.

<h3>Current Version: 0.5.0</h3>

<h2>Features:</h2>

<li>no prompts, no executables, no java, no python, no perl, just a small batch file</li>
<li>compatible with any version of windows, requires only the apps you'd like to run</li>
<li>made for android or windows users who want to make mod list changes on-the-fly</li>
<li>implements all three of the main apps you should use with OpenMW android or windows</li>
<li>efficient and speedy, converts large .cfg files in seconds</li>
<li>backs up any existing files, creates folders if they don't exist</li>
<li>intuitive, allows absolute/relative paths, fixes slash errors, default values, support for non-Latin characters</li>
<li>highly customisable, pick steps to perform, open or delete validator log, silent mode, date and time stamp</li>
<li>automatically disables the OMWLLF/DeltaPlugin .omwaddon files/folder before running apps, including those timestamped</li>
<li>specify lists of mods/folders to exclude before running either OMWLLF or DeltaPlugin</li>
<li>list of folders to exclude will be checked for active mods similar to openmw-validator</li>
<li>only need to open the batch file in a text editor, modify a few values, save, and then run it</li>
<li>define variables in a separate text file for quick changing</li>
<li>NEW! disable or enable mods or folders using a list, useful even if you don't use the apps</li>

<h2>Usage:</h2>

On the right side of this page, under Releases, click the latest version, download the zip, and unpack it somewhere. For default function, firstly you need your latest openmw.cfg file ready. For android users, ust place the file, as well as the folders for openmw-validator, OMWLLF and DeltaPlugin, in the same folder as runme.bat, then open "variables.txt" and change the following values:<br>

<li>mode = use "android" or "windows" without quotes</li>
<li>folderData = location of Data Files folder on android</li>
<li>replaceData = location of Data Files folder on windows</li>
<li>folderMod = location of Mods folder on android</li>
<li>replaceMod = location of Mods folder on windows</li>
<li>omwaddonFolder = output folder of generated .omwaddon files, same name as android, must be inside the above Mods folder</li>

<br>After editing the values, save the text file then run the batch file like you would any other file. And that's it, now go out there and enjoy your own customised and unique world of Morrowind, on your phone!

<br>Windows users only need to modify "replaceMod" and "omwaddonFolder" values. Enable backup feature to do backup before overwriting. Read the comments in the batch file for further information on all the modes and functions. I suggest <strong><a href="https://notepad-plus-plus.org/downloads/">Notepad++</a></strong> for modifying .bat and .cfg files (it's free). Download all the apps from the links above, you only need the ones you enable. OpenMW windows is not necessary for any of the apps to function. OMWLLF requires python. It is recommended you use just DeltaPlugin as it handles leveled lists better and is still being updated.

<h2>Changelog:</h2>

<h3>0.6.0 [upcoming]:</h3>
<li>add support for tes3cmd and TR Filepatcher</li>
<li>enhanced partial matching to search out of order</li>
<li>speed up disabling .omwaddon mods/folder if mod disabling feature not enabled</li>
<li>can disable or enable mods found in folders specified</li>
<li>no longer enables lines with comments</li>
<li>less confusing mode system</li>
<li>output issues found in validator log to screen</li>
<li>changes to checking disabled folders to exclude already excluded lines</li>

<h3>0.5.0 [2023-05-17]:</h3>
<li>ability to specify a list of mods/folders to disable or enable, useful if you categorise mods or wish to disable or enable many lines</li>
<li>disabled mods list separated for each app and are now delimited by a question mark since file/folder names can't contain them</li>
<li>disabled folders can be checked for active mods before running each app, and non-existent excluded folders will be reported</li>
<li>allows specifying modes, including new modes "reverse" and "writeonly"</li>
<li>openmw-validator now reads from and writes to same documents folder as shell</li>
<li>reads validator log to report if errors were found or not</li>
<li>added option to clear screen before execution</li>
<li>fixed error introduced in 0.4.0 that disabled the first line when excluding mods</li>
<li>fixed issue with file names containing single quotes</li>
<li>minor bug fixes, logic and performance optimisation, improved readability, further code cleaning</li>

<h3>0.4.1 [2023-03-06]:</h3>
<li>list of mods to disable can include folders with android/windows paths or just folder name</li>
<li>fixed error when deleting non-existent files</li>
<li>returns exit code of 1 if error detected</li>
<li>cleaned code some more</li>

<h3>0.4.0 [2023-03-02]:</h3>
<li>allows specifying a comma separated list of mods to disable before running apps</li>
<li>option to read variables from a specified file instead of the batch file</li>
<li>empty lines are preserved when converting openmw.cfg</li>
<li>exits only batch process and not cmd</li>
<li>fixed error outputting to base mods folder</li>
<li>python executable location can be specified</li>
<li>timestamp added to output lines</li>
<li>OpenMW folder is now created if it doesn't exist</li>
<li>cleaned some terrible coding</li>

<h3>0.3.0 [2023-02-24]:</h3>
<li>enable or disable individual steps</li>
<li>output folder is now created if it doesn't exist, no longer exits if folder missing</li>
<li>added option to disable relevant .omwaddon files and folder instead of forcing it</li>
<li>windows mode combined with conversion step will temporarily disable .omwaddon files/folder using temp file</li>
<li>disabling .omwaddon files now uses partial match to work with date and time stamped entries</li>
<li>base mods folder will no longer be disabled</li>
<li>enabling date and time stamp will skip backing up .omwaddon files</li>
<li>date and time stamp now no longer region-specific</li>
<li>spaces in file/folder names don't break the script anymore</li>
<li>lets user enter a codepage identifier to allow recognising non-Latin characters</li>
<li>single character names for files/folders now work</li>
<li>keeps disabled lines intact and only disables lines that aren't already disabled</li>
<li>adds backslashes to end of all folders in converted android openmw.cfg</li>
<li>slash error fixing covers a wider range of scenarios</li>
<li>openmw-validator error catching improved</li>
<li>alerts user that process finished after errors</li>
<li>other small bug fixes</li>

<h3>0.2.2 [2023-02-17]:</h3>
<li>windows mode added, see comments</li>
<li>backup skips .omwaddon files if timestamp enabled</li>

<h3>0.2.1 [2023-02-14]:</h3>
<li>checks for existence of app name rather than folder</li>

<h3>0.2.0 [2023-02-14]:</h3>
<li>now runs openmw-validator</li>
<li>options to open openmw-validator log and delete aftter execution</li>
<li>added pause prompt between running apps</li>
<li>slashes/backslashes are now consistent</li>
<li>minor cleaning</li>

<h3>0.1.0 [2023-02-09]:</h3>
<li>initial release</li>

<h2>Future plans:</h2>

<li>allow outputting .omwaddon files to folders outside Mods folder</li>
<li>allow passing custom openmw.cfg location to all three apps</li>
<li>silence option works on script output lines too</li>
<li>output to log</li>
<li>check folder to be disabled for other mods</li>
<li>add tes3cmd cleaning option</li>

<br>Feel free to reach out to me for help, bugs, suggestions, or comments by sending me an <strong><a href="mailto:r_b_inc@yahoo.ca">email</a></strong>. Thank you to Hristos N. Triantafillou, John Melesky, and Benjamin Winger for their wonderful apps. Thank you to <strong><a href="https://github.com/OpenMW">the OpenMW team</a></strong>, <strong><a href="https://github.com/xyzz">xyzz</a></strong>, <strong><a href="https://github.com/docent27">Dmitry</a></strong>, and <strong><a href="https://github.com/Sisah2">Sisah2</a></strong> for their amazing work on OpenMW. Thank you to all the modders out there, specially those who are still going at it all these years later. And lastly thank you to Bethesda for making one of my most favourite games.
