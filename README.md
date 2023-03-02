<h1>Script for OpenMW Android/Windows Users to Automatically Modify openmw.cfg, Run openmw-validator, and Generate OMWLLF/DeltaPlugin .omwaddon Files</h1>

This is a simple yet highly functional and customisable batch file that will completely automate the process of validating your android or windows openmw.cfg file using <strong><a href="https://mw.moddinghall.com/file/28-openmw-validator">openmw-validator</a></strong> (by <strong><a href="https://hristos.co/">Hristos N. Triantafillou</a></strong>), and then creating .omwaddon files from both <strong><a href="https://github.com/jmelesky/omwllf">OMWLLF</a></strong> (by <strong><a href="https://github.com/jmelesky">John Melesky</a></strong>) and <strong><a href="https://gitlab.com/bmwinger/delta-plugin/-/releases">DeltaPlugin</a></strong> (by <strong><a href="https://gitlab.com/bmwinger">Benjamin Winger</a></strong>), using an automatically modified openmw.cfg file. All you need is your android or windows openmw.cfg file and the three apps, and the script does the rest. Just modify the values mentioned below and you're good to go. This script will take the windows or android openmw.cfg file, edit every line to change android paths to corresponding windows paths, disable relevant .omwaddon folder/files, save the new openmw.cfg file into the default OpenMW folder on windows, and then run the three apps and output the .omwaddon files into the user's chosen folder. This is for people like me who do not use a mod manager and prefer a hands-on approach. If you're sick of modifying the windows openmw.cfg file and then running every app each time you make a change to your mod list, then this is my solution for you.

After weeks of painstakingly modding OpenMW android, one mod at a time, trying different versions and alternatives, checking compatibility and playing for a little bit to test it, consulting several mod lists and trying to combine them, having to repeatedly change and generate the files, disabling the .omwaddon files and additional mods for compatibility reasons, and finally coming to the conclusion there's gotta be an easier way. It started off as a simple script of less than fifteen lines. But I kept adding more and more functionality to make it easier for me. Eventually I decided there must be others out there who could make use of this too, plus my GitHub is very sparse, so I started expanding it so others could modify values easily and use features that I didn't need, such as the windows mode. It took weeks to get to this version and I hope it makes your life a little easier like it has mine.

<h2>Features:</h2>

<li>made for android users but works for windows users too with windows mode</li>
<li>implements all three of the main apps you should use with OpenMW android and windows</li>
<li>pick which steps to perform and pause between them</li>
<li>only need to open the batch file, modify a few values, save, and then run it</li>
<li>never have to modify the batch file again unless folder paths change</li>
<li>automatically disables the output .omwaddon files/folder before running apps</li>
<li>disabling feature uses partial match so timestamped entries will disable too</li>
<li>preserve windows copy of openmw.cfg by using backup, or using temp file in windows mode</li>
<li>specify a list of mods to disable before running apps, some mods break with DeltaPlugin</li>
<li>highly customisable, open or delete validator log, backup before overwriting, silent mode, optional date and time stamp</li>
<li>intuitive, allows absolute/relative paths, fixes slash errors, default values, support for non-Latin characters</li>
<li>no prompts, no executables, no java, no python, no perl, just a small batch file</li>
<li>define variables inside the batch file or a separate configuration file</li>

<h2>Usage:</h2>

For default function, firstly you need your latest openmw.cfg file ready. Just place the file, as well as the folders for openmw-validator, OMWLLF and DeltaPlugin, in the same folder as runme.bat, then go into the batch file and change the following values:

<li>folderData = location of Data Files folder on android</li>
<li>replaceData = location of Data Files folder on windows</li>
<li>folderMod = location of Mods folder on android</li>
<li>replaceMod = location of Mods folder on windows</li>
<li>omwaddonFolder = output folder of generated .omwaddon files, same name as android, must be inside the above Mods folder</li>

<br>After editing the values, save the batch file then run it. That's it, now go out there and enjoy your own customised and unique world of Morrowind, on your phone!

Additionally you may define the values inside the included variables.cfg file if that's easier. Windows users need to enable windows mode and only need to modify "replaceMod" and "omwaddonFolder" values, the script will use a temp file to preserve the original windows openmw.cfg file. Read the comments in the batch file for further information, you will find many options to play around with. I suggest <strong><a href="https://notepad-plus-plus.org/downloads/">Notepad++</a></strong> for modifying .bat and .cfg files (it's free). Download all the apps from the links above, you only need the ones you enable. OpenMW windows is not necessary for any of the apps to function. OMWLLF requires python.

<h3>Current Version: 0.4.0</h3>

<h2>Changelog:</h2>

<h3>0.4.0</h3>
<li>allows specifying a comma separated list of mods to disable before running apps</li>
<li>option to read variables from a specified file instead of the batch file</li>
<li>empty lines are preserved when converting openmw.cfg</li>
<li>exits only batch process and not cmd</li>
<li>fixed error outputting to base mods folder</li>
<li>python executable location can be specified</li>
<li>timestamp added to output lines</li>
<li>OpenMW folder is now created if it doesn't exist</li>
<li>cleaned some terrible coding</li>

<h3>0.3.0</h3>
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

<h3>0.2.2</h3>
<li>windows mode added, see comments</li>
<li>backup skips .omwaddon files if timestamp enabled</li>

<h3>0.2.1</h3>
<li>checks for existence of app name rather than folder</li>

<h3>0.2.0:</h3>
<li>now runs openmw-validator</li>
<li>options to open openmw-validator log and delete aftter execution</li>
<li>added pause prompt between running apps</li>
<li>slashes/backslashes are now consistent</li>
<li>minor cleaning</li>

<h3>0.1.0:</h3>
<li>initial release</li>

<h2>Future plans:</h2>

<li>allow outputting .omwaddon files to folders outside Mods folder</li>
<li>allow passing custom openmw.cfg location to all three apps</li>
<li>silence option works on script output lines too</li>
<li>disable .omwaddon file names while ignoring timestamps</li>
<li>preserve empty lines when converting the .cfg</li>
<li>check folder to be disabled for other mods</li>
<li>list of mods to exclude/disable for compatibility reasons</li>
<li>read variables from file</li>
<li>add tes3cmd cleaning option</li>
<li>output to log</li>

<br>Feel free to reach out to me for help, bugs, suggestions, or comments by sending me an <strong><a href="mailto:r_b_inc@yahoo.ca">email</a></strong>. Thank you to Hristos N. Triantafillou, John Melesky, and Benjamin Winger for their wonderful apps. Thank you to <strong><a href="https://github.com/OpenMW">the OpenMW team</a></strong>, <strong><a href="https://github.com/xyzz">xyzz</a></strong>, <strong><a href="https://github.com/docent27">Dmitry</a></strong>, and <strong><a href="https://github.com/Sisah2">Sisah2</a></strong> for their amazing work on OpenMW. Thank you to all the modders out there, specially those who are still going at it all these years later. And lastly thank you to Bethesda for making one of my most favourite games.
