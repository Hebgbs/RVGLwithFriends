# RVGL with friends!
## Preface
Greetings! If you are seeing this, it is likely because it has beenn shared in the guild I co-administer, Linux Enthusiast Group. You should also check out the official Re-Volt community if you have a continued interest in this game. Their places on Discord as follows:
[Linux Enthusiast Group](https://discord.gg/JUqRD7k)
[Re-Volt guild (int'l)](https://discord.gg/NMT4Xdb)

Without these communities, this project wouldn't be a thing, and this game would not exist. Nobody would imagine after 24 years, this game would still be a thing, but _it is_ and it's wonderful.

## Joining in
> _In the event of placceholders, which are __not__ shell paths (represented with `$`) they will be shown prefixed with `?`._

### Getting Re-Volt
To begin, you'll want to download Re-Volt OpenGL. Visit https://re-volt.io/downloads/game and followw intstructions provided to fetch the game. Windows and Mac users have an Archive, while Linux users have a Python script which will download the game on one's behalf _and_ diagnose potential issues from missing libraries. For Linux, these dependencies are needed:
> `openal`
> `opengl`
> `sdl2`
> `sdl2_image`
> `enet`
> (Optional) `fluidsynth`

Install for your distribution these libraries before running the game for best results.

### Downloading our extra content
Optionally, sign up for a GitHub account and make sure you can log in. You'll want to do this because _you_ can add extra content later on, which will be explained later.

You can install Git SCM or use `git`Visit https://desktop.github.com and download the GitHub client for Windows. Once installed, sign into your GitHub account and clone this repository using the desktop application.

After the repository is cloned, the next steps can take place.

### Installing the extra content
This reository ue to have scripts for people to run, but I figured they're on par useful to yours truly, **so I deleted them.** Both methods for Windows and Linux are shown below — Mac users, you're on your own. _But_ the intent here is to create a means of using them through the use of journaling filesystems.
> ### Windows
> ```
> REN %RVGLpath%\cars oldCars
> REN %RVGLpath%\levels oldLevels
> REN %RVGLpath%\gfx oldGFX
> MKLINK /J %RVGLpath%\cars %gitPath%\cars
> MKLINK /J %RVGLpath%\levels %gitPath%\levels
> MKLINK /J %RVGLpath%\gfx %gitPath%\gfx
> ```

> ### GNU / Linux
> ```
> mv $RVGLpath/cars oldcars
> mv $RVGLpath/levels oldlevels
> mv $RVGLpath/gfx oldgfx
> ln -s %gitPath%/cars $RVGLpath
> ln -s %gitPath%/levels $RVGLpath
> ln -s %gitPath%/gfx $RVGLpath
> ```

> ### tl;dr:
> * Rename target directories
> * Create links from repository to game installation

Once finished, run RVGL and register your profile within the game. If you browse the selection of vehicles and maps available, there should be _tons_ of extra content for you to choose from.

## Adding extra content
### Giving
Open wither the repository where the content is sourced from or your game directory and drop in content for RVGL from https://revoltzone.net for your use. If you'd like to share this content with everybody, then use GitHub Desktop to create a pull request.

Make sure you leave a descriptive comment in your push request so everybody knows what's up. After the content is approved, repository moderators will merge changes.

### Receiving
To update available content, _first_ make sure there is a pull request which had been merged to begin with. GitHub Desktop will tell you how many commits you're behind. If you are behind, catch up by pulling in new changes. If you encounter problems, let the repository moderators know!

## Removal
To remove the content from your copy of the game, ddelete (or `unlink`) the directories which are symbolic references in RVGL's game directory and revert the previous modifications to the directories therein.
