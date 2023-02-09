Batch File to Automate Generating Omwaddon Files from Omwllf.py and Delta-Plugin

This is a simple yet highly customisable batch file that will completely automate the process of creating .omwaddon files from both omwllf.py (by jmelesky) and delta-plugin.exe (by bmwinger) using an automatically converted version of openmw.cfg from android installation.

For default function, just place the openmw.cfg from android as well as the folders for omwllf and delta-plugin in the same folder as this batch file, go into the batch file and change the following values:

- folderData = location of Data Files folder on android
- replaceData = location of Data Files folder on windows
- folderMod = location of Mods folder on android
- replaceMod = location of Mods folder on windows
- omwaddonFolder = output folder of generated .omwaddon files, this folder must be inside the above Mods folder, leave blank to output to Mods folder

Read the comments in the batch file for further information. I suggest Notepad++ for modifying .cfg and .bat files. Get it <a href="https://notepad-plus-plus.org/downloads/">here</a>.

CURRENT VERSION: 0.1
Features:

- only need to modify five values initially and never have to change any values again
- automatically disables the output folder and generated .omwaddon file names when converting .cfg file
- highly customisable, backup option, silent mode, optional date and time stamp

Future plans:

- allow outputting .omwaddon files to folders outside Mods folder
