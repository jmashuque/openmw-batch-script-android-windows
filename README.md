<h1>OpenMW Batch Script for Android and Windows Users</h1>
<h3>Automate Converting/Modifying openmw.cfg and Downloading/Running openmw-validator, tes3cmd, tr-patcher, OMWLLF, and DeltaPlugin</h3>

This is a relatively simple yet highly functional and customisable batch file meant for both Android and Windows OpenMW users that will completely automate the process of converting or modifying openmw.cfg and running the following apps:

<h4><strong><a href="https://mw.moddinghall.com/file/28-openmw-validator">openmw-validator</a></strong> (by <strong><a href="https://hristos.co/">Hristos N. Triantafillou</a></strong>)</h4>
<h4><strong><a href="https://github.com/john-moonsugar/tes3cmd">tes3cmd</a></strong> (clean) (by <strong><a href="https://github.com/john-moonsugar">John Moonsugar</a></strong>)</h4>
<h4><strong><a href="https://gitlab.com/bmwinger/tr-patcher/-/releases">tr-patcher</a></strong> (Tamriel Data Filepatcher) (by <strong><a href="https://gitlab.com/bmwinger">Benjamin Winger</a> and the <a href="https://www.tamriel-rebuilt.org/about/about-project">Tamriel Rebuilt Team</a></strong>)</h4>
<h4><strong><a href="https://github.com/jmelesky/omwllf/releases">OMWLLF</a></strong> (by <strong><a href="https://github.com/jmelesky">John Melesky</a></strong>)</h4>
<h4><strong><a href="https://gitlab.com/bmwinger/delta-plugin/-/releases">DeltaPlugin</a></strong> (by <strong><a href="https://gitlab.com/bmwinger">Benjamin Winger</a></strong>)</h4>

No prompts, no executables, no java, no python, just a small batch file. All you need is your Android or Windows openmw.cfg file and the apps you want to use (if any), and the script does the rest. This script can do many things, the following is a more complex example of one run of the script:

<li>download/unzip all the apps into the right folders</li>
<li>back up openmw.cfg</li>
<li>convert Android to/from Windows paths</li>
<li>enable or disable any lines that match user-specified list of mods</li>
<li>run openmw-validator and read generated log for errors</li>
<li>run tes3cmd clean command or tr-patcher on list of mods specified</li>
<li>back up .omwaddon files</li>
<li>automatically disable the names of .omwaddon files in openmw.cfg and optionally user-specified mods</li>
<li>run OMWLLF and DeltaPlugin</li>
<li>output the .omwaddon files into the user's chosen folder</li>
<li>revert openmw.cfg to before running apps</li>
<li>write lines for .omwaddon files/folder if they don't exist in openmw.cfg</li>
<li>find installation folder of OpenMW and run the game</li>

<br>This is for people like me who do not use a mod manager and prefer a hands-on approach. If you're sick of modifying the Windows openmw.cfg file, running Delta, then converting to Android manually each time you make a change to your mod list, then this is my solution for you. After weeks of painstakingly modding OpenMW Android, one mod at a time, trying different versions and alternatives, checking compatibility, consulting several mod lists and trying to combine them, having to repeatedly change and generate the files, disabling the generated files and additional mods that aren't compatible with DeltaPlugin, I finally came to the conclusion that there's gotta be an easier way. It started off as a simple script of less than fifteen lines. But I kept adding more and more functionality. Eventually I decided there must be others out there who could make use of this script too. So I started expanding it so others could easily modify values and use the features they need. I had to learn a lot about batch files to do this script, with zero use of AI. I hope it makes your life a little easier.

<h4>Current Version: 0.6.0</h4>

<h3>At a Glance:</h3>

<li>convert or modify large mod lists in about a second</li>
<li>compatible with Windows 7 and up, requires only the apps you'd like to run</li>
<li>made for Android or Windows users who want to make mod list changes on-the-fly</li>
<li>uses default values and creates folders if they don't exist</li>
<li>allows absolute/relative paths, fixes slash errors, automatically changes mod lists to chosen OS</li>
<li>define variables in a separate text file for quick changing, no need to modify the batch file</li>
<li>pick which steps to perform and pause between them</li>
<li>downloader.bat for Windows 10 and above to automatically download/unzip apps, takes arguments</li>

<h3>Convert/Modify Optional Features:</h3>

<li>disabled/enabled/excluded lines can be checked to see if they contain active mods or exist, similar to openmw-validator</li>
<li>add a date/time stamp comment at the end of the modified openmw.cfg, overwriting previous stamps</li>
<li>user list matching function can also match terms out of order instead of exact matches</li>
<li>use reverse to convert output to input and use ignore input to overwrite output</li>
<li>verbose mode prints lines and line numbers of modified lines</li>

<h3>Applications Optional Features:</h3>

<li>display errors from openmw-validator, open log file, delete log after execution</li>
<li>modify openmw.cfg after running tes3cmd clean command to rewrite appropriate lines</li>
<li>specify lists of mods/folders to exclude before running either OMWLLF or DeltaPlugin</li>
<li>silent mode to mute any output from OMWLLF\DeltaPlugin including errors</li>
<li>add a timestamp to .omwaddon file names</li>
<li>write or rewrite appropriate data and content lines for .omwaddon files at end of file if they're missing</li>

<h2>Usage:</h2>

On the right side of this page, under Releases, click the latest version, download the zip, and unpack it somewhere. Firstly you need your latest openmw.cfg file ready, see the batch file for default locations. For Android users, just place the file in the same folder as runme.bat. For Windows users, the openmw.cfg at the default location will be used. Copy the folders for openmw-validator, tr-patcher, OMWLLF and/or DeltaPlugin, into the same folder as runme.bat, if their names match the default values they will be located. For tes3cmd, the executable must be placed inside the Data Files folder. Open variables.txt and change the following values:<br>

<li>convertTo = use Windows or Android</li>
<li>folderData = location of Data Files folder on Android</li>
<li>replaceData = location of Data Files folder on Windows</li>
<li>folderMod = location of Mods folder on Android</li>
<li>replaceMod = location of Mods folder on Windows</li>
<li>omwaddonFolder = output folder of generated .omwaddon files, must be inside the above Mods folder</li>

<br>After editing the values, save the text file then run the batch file like you would any other file. The default variables.txt will simply convert Android paths to Windows, run openmw-validator, disable the .omwaddon files, run DeltaPlugin, and finally restore the Windows openmw.cfg. You can of course do many other things with this batch file, but that should get you started. See the examples below for more ways to use it. You can also use different versions of variables.txt by using runme.bat through command prompt and supplying the variables file name as an argument. And that's it, now go out there and enjoy your own customised and unique world of Morrowind, on your phone!

Backup is enabled by default, but make a backup elsewhere just in case because backups are overwritten. Read the comments in the batch file for further information on all the options and features. I suggest <strong><a href="https://notepad-plus-plus.org/downloads/">Notepad++</a></strong> for modifying .bat and .cfg files (it's free). Download all the apps from the links in the top paragraph, you only need the ones you enable. OpenMW doesn't have to be installed if you're an Android user, the OpenMW folder will be created if it doesn't exist. tr-patcher requires <strong><a href="https://www.java.com/en/download/manual.jsp">java</a></strong>. OMWLLF requires <strong><a href="https://www.python.org/downloads">python</a></strong>. For leveled lists, it is recommended you use only DeltaPlugin as it handles them better than OMWLLF and is still being developed. You can use the included downloader.bat script to automatically download each app necessary, see the script code for more information.

<h2>Examples:</h2>

The variables.txt file can be modified in many ways to suit your preferences. You can add/remove any comments. You can rearrange the variables as you like, and you can add/remove any blank lines too. You can also remove the line for any variable you don't need, excluding the six variables specifically mentioned under Usage. Although, removing a variable will remove its functions. You can also override variables by redefining them at the end of the file, the last definition of a variable will always be used.

<h3>Modify Android Copy Only</h3>
Set convertTo to android and enable ignoreInput.

<h3>Modify Windows Copy Only</h3>
Set convertTo to windows and enable ignoreInput.

<h3>Convert Input Only</h3>
Set convertTo to android or windows, enable ignoreInput and enableReverse.

<h3>Disable/Enable Mod Groupings</h3>
Enable disableSearchExact and modify the appropriate variable depending on what function you're using. For example, you can disable all Tyddy textures that are HQ by specifying:
<pre>
disableSearchExact=True
modsDisabler=Tyddy HQ
</pre>
and the script will match any lines that contain each term in any order.

<h2>Warning:</h2>

Batch files can be very dangerous. They can do some destructive and irreversible things without user interaction or administrative privileges. Do not use batch files from unknown sources unless you understand what malicious code can look like. Do not run this batch file if you did not download it from my GitHub. Do not modify the batch file unless you know what you are doing. This batch file, and downloader.bat, should not ask for administrative privileges or set off standard antivirus software, if it does then stop using it and contact me.

<h2>Changelog:</h2>

<h3>Future (maybe):</h3>
<li>can disable or enable all mods found in folders specified</li>
<li>write new lines in openmw.cfg for enabled mods not found</li>

<h3>0.6.0 [2023-12-02]:</h3>
<li>support for tr-patcher and tes3cmd clean function, takes list of mod names and finds any that exist in your data paths and runs app on them</li>
<li>overhauled most of the code, now performs less read/write operations, uses less recursion in favour of arrays, performance significantly improved in many situations</li>
<li>uses temporary files to allow for larger internal lists than batch file variables can hold, at the cost of a little performance</li>
<li>will write .omwaddon files and folder to end of openmw.cfg if lines aren't found</li>
<li>optionally will modify openmw.cfg to reflect new file names after running tes3cmd or OMWLLF/DeltaPlugin with timestamps enabled</li>
<li>no more mode system, just change convertTo variable to "Windows" or "Android", use enableReverse or ignoreInput for further control</li>
<li>option for matching terms instead of the exact phrase when doing disabling/enabling/excluding</li>
<li>can now run OpenMW after successful execution using powershell command to find OpenMW in registry</li>
<li>line enabling only enables lines with proper syntax to avoid (but not eliminate) enabling actual comments</li>
<li>checker now works much faster and checks enabled lines to see if they exist too</li>
<li>verbose mode to output each line enabled/disabled/excluded including line number to screen</li>
<li>option to output issues found in validator log to screen</li>
<li>option to add a date and time stamp comment at the end of the openmw.cfg output, this overwrites previous stamps</li>
<li>varFile can now be supplied through a command-line argument</li>
<li>includes a separate batch file (downloader.bat) to download and extract all apps</li>
<li>DeltaPlugin version updated to 0.19.0</li>
<li>other small improvements, additions, bug fixes and logic optimisations</li>

<h3>0.5.0 [2023-05-18]:</h3>
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
<li>list of mods to disable can include folders with Android/Windows paths or just folder name</li>
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
<li>Windows mode combined with conversion step will temporarily disable .omwaddon files/folder using temp file</li>
<li>disabling .omwaddon files now uses partial match to work with date and time stamped entries</li>
<li>base mods folder will no longer be disabled</li>
<li>enabling date and time stamp will skip backing up .omwaddon files</li>
<li>date and time stamp now no longer region-specific</li>
<li>spaces in file/folder names don't break the script anymore</li>
<li>lets user enter a codepage identifier to allow recognising non-Latin characters</li>
<li>single character names for files/folders now work</li>
<li>keeps disabled lines intact and only disables lines that aren't already disabled</li>
<li>adds backslashes to end of all folders in converted Android openmw.cfg</li>
<li>slash error fixing covers a wider range of scenarios</li>
<li>openmw-validator error catching improved</li>
<li>alerts user that process finished after errors</li>
<li>other small bug fixes</li>

<h3>0.2.2 [2023-02-17]:</h3>
<li>Windows mode added, see comments</li>
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
<li>initial release, able to convert Android paths to Windows and run OMWLLF and DeltaPlugin</li>
<li>backup and timestamp features</li>

<h2>Thanks for checking out this project</h2>

Feel free to reach out to me for help, bugs, suggestions, requests, or comments by sending me an <strong><a href="mailto:r_b_inc@yahoo.ca">email</a></strong>. Thank you to Hristos N. Triantafillou, John Moonsugar, Benjamin Winger, and John Melesky for their wonderful apps. Thank you to <strong><a href="https://github.com/OpenMW">the OpenMW team</a></strong>, <strong><a href="https://github.com/xyzz">xyzz</a></strong>, <strong><a href="https://github.com/docent27">Dmitry</a></strong>, and <strong><a href="https://github.com/Sisah2">Sisah2</a></strong> for their amazing work on OpenMW. Thank you to all the modders out there, specially those who are still going at it all these years later including the amazing Tamriel Rebuilt Team. And lastly thank you to Bethesda for making one of my most favourite games.
