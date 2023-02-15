<h1>Automate openmw-validator and OMWLLF + DeltaPlugin .omwaddon Generation for Android OpenMW Users</h1>

This is a simple yet highly functional and customisable batch file that will completely automate the process of validating your openmw.cfg file using <strong><a href="https://mw.moddinghall.com/file/28-openmw-validator">openmw-validator</a></strong> (by <strong><a href="https://git.sr.ht/~hristoast">Hristos N. Triantafillou</a></strong>), and then creating .omwaddon files from both <strong><a href="https://github.com/jmelesky/omwllf">OMWLLF</a></strong> (by <strong><a href="https://github.com/jmelesky">John Melesky</a></strong>) and <strong><a href="https://gitlab.com/bmwinger/delta-plugin/-/releases">DeltaPlugin</a></strong> (by <strong><a href="https://gitlab.com/bmwinger">Benjamin Winger</a></strong>), using an automatically converted openmw.cfg from an android version. All you need is your android openmw.cfg and the three apps, and the script does the rest. Just modify the five values mentioned below and you're good to go, you never have to change the batch file again unless there is a new version of one of the apps. This script will take the android openmw.cfg, edit every line to change android paths to corresponding windows paths, save the new openmw.cfg into the default OpenMW folder on windows (which is where all three apps will look for the file), and then run the three apps and output the .omwaddon files into the user's chosen folder. This is for people like me who do not use a mod manager and prefer a hands-on approach. If you're sick of modifying the windows openmw.cfg and then running every app each time you make a change to your mod list, then this is my solution for you.

For default function, firstly you need your updated android openmw.cfg ready. Just place the file, as well as the folders for openmw-validator, OMWLLF and DeltaPlugin, in the same folder as runme.bat, then go into the batch file and change the following values:

- folderData = location of Data Files folder on android
- replaceData = location of Data Files folder on windows
- folderMod = location of Mods folder on android
- replaceMod = location of Mods folder on windows
- omwaddonFolder = output folder of generated .omwaddon files, same name as android, must be inside the above Mods folder

After editing the values, save the batch file then run it. That's it, now go out there and enjoy your own beautiful world of Morrowind, on your phone!

Read the comments in the batch file for further information, you will find several neat features. I suggest Notepad++ for modifying .cfg and .bat files. Get it <strong><a href="https://notepad-plus-plus.org/downloads/">here</a></strong>. Folder and file names are case sensitive. Download the apps from the links above. You will have to change the folder value for an app if a new release comes out, you change the default folder name, or you place the app somewhere else.

CURRENT VERSION: 0.2.0

Features:

- only need to modify five values initially, just update android openmw.cfg with proper data/content paths, and run it
- automatically disables the output folder and generated .omwaddon file names when converting .cfg file
- highly customisable, open or delete validation log, backup before overwriting, silent mode, optional date and time stamp, pause between steps
- intuitive, allows absolute/relative paths, adds leading/trailing slashes, default file names

Changelog:

0.2.0:
- now runs openmw-validator
- added pause prompt between running apps
- slashes/backslashes are now consistent
- minor cleaning and optimising

Future plans:

- allow outputting .omwaddon files to folders outside Mods folder
- allow passing custom openmw.cfg location to all three apps
- allow reverse editing by changing values in android openmw.cfg to reflect chosen names of .omwaddon files
- silence option works on script output lines too
- remove case sensitivity
- disable .omwaddon file names while ignoring timestamps or longer names
- add tes3cmd cleaning option
- output to log

Feel free to reach out to me for help, bugs, suggestions, or comments by sending me an <strong><a href="mailto:r_b_inc@yahoo.ca">email</a></strong>. Thank you to Hristos N. Triantafillou, John Melesky, and Benjamin Winger for their wonderful apps. Thank you to <strong><a href="https://github.com/Sisah2">Sisah2</a></strong> for their work on OpenMW. Thank you to all the modders out there who are still going at it all these years later. And lastly thank you to Bethesda for your amazing vision.
