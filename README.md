<h1>Batch File to Automate Generating .omwaddon Files From OMWLLF and Delta-Plugin for Android OpenMW Users</h1>

This is a simple yet highly customisable batch file that will completely automate the process of creating .omwaddon files from both <strong><a href="https://github.com/jmelesky/omwllf">OMWLLF</a></strong> (by <strong><a href="https://github.com/jmelesky">John Melesky</a></strong>) and <strong><a href="https://gitlab.com/bmwinger/delta-plugin/-/releases">DeltaPlugin</a></strong> (by <strong><a href="https://gitlab.com/bmwinger">Benjamin Winger</a></strong>) using an automatically converted version of openmw.cfg from android installations. This script will take the android openmw.cfg, edit every line to change android paths to corresponding windows paths, save the new openmw.cfg into the default OpenMW folder on windows (which is where both omwllf.py and delta_plugin.exe look for openmw.cfg file), and then run the two apps to generate the .omwaddon files into the user's chosen folder.

For default function, just place the openmw.cfg from android as well as the folders for OMWLLF and DeltaPlugin in the same folder as this batch file, go into the batch file and change the following values:

- folderData = location of Data Files folder on android
- replaceData = location of Data Files folder on windows
- folderMod = location of Mods folder on android
- replaceMod = location of Mods folder on windows
- omwaddonFolder = output folder of generated .omwaddon files, same name as android, must be inside the above Mods folder

After editing the values, save the batch file and run it. Read the comments in the batch file for further information. I suggest Notepad++ for modifying .cfg and .bat files. Get it <strong><a href="https://notepad-plus-plus.org/downloads/">here</a></strong>. Folder and file names are case sensitive.

CURRENT VERSION: 0.1

Features:

- only need to modify five values initially and never have to change any values again, just update android openmw.cfg and run it
- automatically disables the output folder and generated .omwaddon file names when converting .cfg file
- highly customisable, backup option, silent mode, optional date and time stamp
- intuitive, allows absolute/relative paths, adds leading/trailing slashes, default file names

Future plans:

- allow outputting .omwaddon files to folders outside Mods folder
- allow passing custom openmw.cfg location to OMWLLF and DeltaPlugin
- allow reverse editing by changing values in android openmw.cfg to reflect chosen names of .omwaddon files
- silence option works on script output lines too
- remove case sensitivity

Feel free to reach out to me for help, bugs, suggestions, or comments by sending me an <strong><a href="mailto:r_b_inc@yahoo.ca">email</a></strong>.
