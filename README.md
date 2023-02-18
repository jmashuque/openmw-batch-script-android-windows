<h1>Batch File for OpenMW Android/Windows Users to Automatically Convert openmw.cfg, Run openmw-validator, and Generate OMWLLF/DeltaPlugin .omwaddon Files</h1>

This is a simple yet highly functional and customisable batch file that will completely automate the process of validating your android or windows openmw.cfg file using <strong><a href="https://mw.moddinghall.com/file/28-openmw-validator">openmw-validator</a></strong> (by <strong><a href="https://git.sr.ht/~hristoast">Hristos N. Triantafillou</a></strong>), and then creating .omwaddon files from both <strong><a href="https://github.com/jmelesky/omwllf">OMWLLF</a></strong> (by <strong><a href="https://github.com/jmelesky">John Melesky</a></strong>) and <strong><a href="https://gitlab.com/bmwinger/delta-plugin/-/releases">DeltaPlugin</a></strong> (by <strong><a href="https://gitlab.com/bmwinger">Benjamin Winger</a></strong>), using an automatically converted openmw.cfg. All you need is your android or windows openmw.cfg and the three apps, and the script does the rest. Just modify the values mentioned below and you're good to go, you never have to change the batch file again unless there is a new version of one of the apps. This script will take the windows or android openmw.cfg, optionally edit every line to change android paths to corresponding windows paths, disables relevant .omwaddon folder and files, save the new openmw.cfg into the default OpenMW folder on windows (which is where all three apps will look for the file), and then run the three apps and output the .omwaddon files into the user's chosen folder, and optionally re-enable disabled lines. This is for people like me who do not use a mod manager and prefer a hands-on approach. If you're sick of modifying the windows openmw.cfg and then running every app each time you make a change to your mod list, then this is my solution for you. Optionally windows users can opt out of the converting process and use just the apps function.

<h2>Features:</h2>

<li>implements all three main apps required for use with OpenMW android and windows</li>
<li>only need to modify a few, just update android openmw.cfg with proper data/content paths, and run it</li>
<li>automatically disables the output folder and generated .omwaddon file names when converting .cfg file</li>
<li>highly customisable, open or delete validation log, backup before overwriting, silent mode, optional date and time stamp, pause between steps</li>
<li>intuitive, allows absolute/relative paths, adds leading/trailing slashes, default file names</li>
<li>works for windows users too, enable windows mode to skip converting openmw.cfg</li>
<li>no prompts, no executables, no java, no python, no perl, just a small batch file</li>

<h2>Usage:</h2>

For default function, firstly you need your updated android openmw.cfg ready. Just place the file, as well as the folders for openmw-validator, OMWLLF and DeltaPlugin, in the same folder as runme.bat, then go into the batch file and change the following values:

<li>folderData = location of Data Files folder on android</li>
<li>replaceData = location of Data Files folder on windows</li>
<li>folderMod = location of Mods folder on android</li>
<li>replaceMod = location of Mods folder on windows</li>
<li>omwaddonFolder = output folder of generated .omwaddon files, same name as android, must be inside the above Mods folder</li>

<br>After editing the values, save the batch file then run it. That's it, now go out there and enjoy your own beautiful world of Morrowind, on your phone!

Read the comments in the batch file for further information, you will find several neat features. Windows users can enable windows mode to skip rewriting the openmw.cfg, you only need to modify "replaceMod" and "omwaddonFolder" values. I suggest Notepad++ for modifying .cfg and .bat files. Get it <strong><a href="https://notepad-plus-plus.org/downloads/">here</a></strong>. Folder and file names are case sensitive. Download the apps from the links above. You will have to change the folder value for an app if a new release comes out, you change the default folder name, or you place the app somewhere else.

<h3>Current Version: 0.2.2</h3>

<h2>Changelog:</h2>

<h3>0.3.0 (coming soon)</h3>
<li>overhauled windows mode, now temporarily disables .omwaddon files before execution, then re-enables</li>
<li>enabling date and time stamp will skip backing up .omwaddon files</li>
<li>date and time stamp now no longer region-specific</li>
<li>spaces in folder or .omwaddon file names don't break the script anymore</li>
<li>added option to disable .omwaddon folder instead of forcing it</li>
<li>keeps disabled lines intact, only disables</li>
<li>adds backslashes to end of all folders in converted openmw.cfg</li>
<li>alerts user process finished after error</li>
<li>enable or disable individual apps</li>
<li>other bug fixes</li>

<h3>0.2.2</h3>
<li>windows mode added, see comments</li>
<li>backup skips .omwaddon files if timestamp enabled</li>

<h3>0.2.1</h3>
<li>checks for app file rather than folder</li>

<h3>0.2.0:</h3>
<li>now runs openmw-validator</li>
<li>added pause prompt between running apps</li>
<li>slashes/backslashes are now consistent</li>
<li>minor cleaning</li>

<h3>0.1.0:</h3>
<li>initial release</li>

<h2>Future plans:</h2>

<li>allow outputting .omwaddon files to folders outside Mods folder</li>
<li>allow passing custom openmw.cfg location to all three apps</li>
<li>allow reverse editing by changing values in android openmw.cfg to reflect chosen names of .omwaddon files</li>
<li>expand windows mode by allowing temporarily modifying openmw.cfg to disable omwaddon files and folder then re-enabling</li>
<li>silence option works on script output lines too</li>
<li>disable .omwaddon file names while ignoring timestamps or longer names</li>
<li>add tes3cmd cleaning option</li>
<li>output to log</li>

<br>Feel free to reach out to me for help, bugs, suggestions, or comments by sending me an <strong><a href="mailto:r_b_inc@yahoo.ca">email</a></strong>. Thank you to Hristos N. Triantafillou, John Melesky, and Benjamin Winger for their wonderful apps. Thank you to <strong><a href="https://github.com/Sisah2">Sisah2</a></strong> for their work on OpenMW. Thank you to all the modders out there who are still going at it all these years later. And lastly thank you to Bethesda for their amazing vision.
