# RVGL with friends!
## Preface
If you're seeing this, most likely you're coming from either Fishlegs or River's Twitch channels. Huge props for them in showing interest in a modern take for an R / C racing "Simulator" which is over twenty years old. There is a dedicated community of peers within the Re-Volt community who is also to thank for their efforts, make sure you express to them, as well my friends your gratitude:  
[FishLegs' guild](https://discord.gg/JUqRD7k)  
[Rivkets' guild](https://discord.gg/eq8Gfzb)  
[Re-Volt guild (int'l)](https://discord.gg/NMT4Xdb)

Without these communities, this project wouldn't be a thing, and this game would not exist. Nobody would imagine after 23 years, this game would still be a thing, but _it is_ and it's wonderful.

## Joining in
> _Some instructions may apply to Microsoft WIndows only. This is because the software included in this repository is only compatible with Microsoft Windows. Users of Linux or Mac OS X fret not, if you are comfortable with the command line you can apply changes to your copy of RVGL yourself with a few basic commands!_

### Getting Re-Volt
To begin, you'll want to download Re-Volt OpenGL. Visit https://re-volt.io/downloads/game and fetch eitheer the "Online" or "Original" archive compatible with your system architecture and extract to a location you'll memorize --- You'll need this later for the script included in this repository.

### Downloading our extra content
Sign up for a GitHub account and make sure you can log in. You'll want to do this because _you_ can add extra content later on, which will be explained later.

Visit https://desktop.github.com and download the GitHub client for Windows. Once installed, sign into your GitHub account and clone this repository using the desktop application.

After the repository is cloned, the next steps can take place.

### Installing the extra content
From the repository, run `RVGLcontentInstall.bat` and allow it to perform.
> If Windows SmartScreen gets in the way, allow execution --- Windows is wise to malicious batch scripts, but no malicious intent is present in `RVGLcontentInstall.bat`. See for yourself!

Follow the batch prompts to continue operations from your desktop and you will be presented with a menu which has three actions. Of these three, select **option 1**: Install content.

What the script will do next is use `mklink` to create directory junction links for loadiing content. This means if this repository is ever moved or deleted for any reason, the game will refuse to function because it's expecting content to exist where there is none. Here is what it's doing:
```
REN %RVGLpath%\cars oldCars
REN %RVGLpath%\levels oldLevels
REN %RVGLpath%\gfx oldGFX
MKLINK /J %RVGLpath%\cars %gitPath%\cars
MKLINK /J %RVGLpath%\levels %gitPath%\levels
MKLINK /J %RVGLpath%\gfx %gitPath%\gfx
ECHO. > %RVGLpath%\keepme
```
> ### tl;dr:
> * Rename target directories
> * Create links from repository to game installation
> * Create check file for later possible removal

Once finished, open `rvgl.exe` and register your profile within the game. If you browse the selection of vehicles and maps available, there should be _tons_ of extra content for you to choose from.

## Adding extra content
### Giving
Open wither the repository where the content is sourced from or your game directory and drop in content for RVGL from https://revoltzone.net for your use. If you'd like to share this content with everybody, then use GitHub Desktop to create a pull request.

Make sure you leave a descriptive comment in your push request so everybody knows what's up. After the content is approved, repository moderators will merge changes.

### Receiving
To update available content, _first_ make sure there is a pull request which had been merged to begin with. GitHub Desktop will tell you how many commits you're behind. If you are behind, catch up by pulling in new changes. If you encounter problems, let the repository moderators know!

## Removal
To remove the content from your copy of the game, execute the batch file once more and choose **option 2**: Remove content.

Here's what it does:
```
RMDIR %RVGLpath%\cars
RMDIR %RVGLpath%\levels
RMDIR %RVGLpath%\gfx
REN %RVGLpath%\oldCars cars
REN %RVGLpath%\oldLevels levels
REN %RVGLpath%\oldGFX gfx
DEL %RVGLpath%\keepme	
```
> ### tl;dr:
> * Remove additional content directories
> * Remove links from repository to game installation
> * Remove check file as repository content is no longer available.

## Troubleshooting
* `Incorrect copy / Use the copy from %userprofile%\Desktop`  
**Resolution:** Use the copy from desktop instead of the repository.  
**Reason:** While this file is in `.gitignore`, this check is an extra provision to prevent accidential alteration of the repository copy.
* `Game executable does not exist`  
**Resolution:** Define `%RVGLpath% by navigating to the game location in `explorer` and copying it from the address bar, then paste in the batch script to replace the path for this variable.  
**Reason:** No game, no reason.
* `Git content repository does not exist`  
**Resolution:** Define `%gitPath%` by using Github Desktop to open `explorer` at the repository directory and copy it from the address bar, then paste in the batch script to replace the path for this variable.  
**Reason:** Script checks for an empty file called `keepme` in the repository. If this doesn't exist, then script will not work.
* `Are you sure you had installed this previously?`  
**Resolution:** If you had installed this content previously, then this message wouldn't come up. Ptherwise, revert changes yourself if you had deleted `%RVGLpath%\keepme`.  
**Reason:** Prevents accidental removal of default game content.
