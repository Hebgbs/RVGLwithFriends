# "Quick" start guide for Re-Volt OpenGL netplay

So you want to play online with us? That's _great_ but there are a few things which have to be done on your end first before joining the any races with us. Follow the content below and you'll go from zero to gaming in about fifteen minutes.

## Services

Before attempting to join, make sure you have the following services available to you by registering for their use:

### Required
**Re-Volt Zone** — Re-Volt Zone isn't only where new content can be had for the game, they are also the service for our current preferred method of matcmaking with random players on the Internet. Register for an account on https://revoltzone.net so you can sign in with said software to join our races.

### Optional
**GitHub** — If you do not have a GitHub account already _what are you waiting for?_ While not strictly necessary if you do not wish to contribute, having a GitHub account will allow you to add levels and vehicles to this repository later on. If you're just playing _for the day_ and / or do not anticipate contributing to this repository then you can skip registering for GitHub and use GitHub Desktop without an account.

## Software

### Acquisition
**RVGL**, or _Re-Volt OpenGL_ is a modern take on a timeless classic. Originally made as "Re-Volt" in 1997 by Acclaim Entertainment (RIP), thhhis game places you at the perspective of an R / C vehicle, typically driving in life-size environments. RVGL comes with it modern netplay code, new features for content creators and the capability to use multiple processor cores if a user wishes to do as such. **You will need this content to play.**

<table>
  <tr><th colspan="2">Select your system architecture:</th></tr>
  <tr>
    <td><i>x86</i></td>
    <td>https://distribute.re-volt.io/releases/rvgl_full_win32_original.zip</td>
  </tr>
    <td><i>x64</i></td>
    <td>https://distribute.re-volt.io/releases/rvgl_full_win64_original.zip</td>
  </tr>
</table>

Tyoically your selection will be x64 on modern hardware, _but_ if you aren't sure or want a portable buiild with the most compatibiility, the _x86_ build will function on all systems.

[**RV House**](http://rvhouse.revoltzone.net/downloads/rv_house_setup.exe) is the software we use for stream races. While direct-to-IP typically works when any host is configured to allow data packets from RVGL in and out of their Internet communications device, use of a middle service  for Internet play is less of a hassle. Sadly, this also limits play to Microsoft Windows users, so people on Macand Linux can get stuffed until someone gives a damn enough to make a new version of RV House compatiblewith OS X and anything using the Linux kernel. **You will need to download this software and sign in with your Re-Volt Zone account to join.**

[**GitHub Desktop**](desktop.github.com) helps make contributing to a repository easy by means of a graphical user interface ssanctioned by the very same brand which files for this repository are under. No need learning what commands to punch into powershell, the graphicaluser interface provided by GitHub makes it stupid-easy to maintain and contribute repositories available on your system. **If you wish to not install this, follow instructions related to this ommission below.**

### Configuration

#### RVGL
Extract the contents of the directory you downloaded to a place you will remember. If using your desktop, don't be an idiot — Make a new folder (directory) to shove it in and keep your virtual space tidy!

#### GitHub Desktop
Whether you have an account with GitHub or not, you can clone _this repository_ by copying the following address, and pasting it in the prompt for cloning a repository: https://github.com/Hebgbs/RVGLwithFriends.git

#### Repository content
So that you are in sync with us and have available use of all extra content this repository provides, perform the following, in order:
1. In GitHub Desktop, open repository `RVGLwithFriends` in explorer
2. Either copy to `%userprofile%\Desktop` the batch file, or upon execution from reppsitory directory the script will copy itself on your behalf.
3. Execute the script and see what errors come up. _If any_, you will have to edit the script so it functions.
   * Visit the [**Troubleshooting**](https://github.com/Hebgbs/RVGLwithFriends#troubleshooting) section of the repository page to make the script functional.
4. Once the script is made functional by modifying variable paths to correct locations on disk, in the menu provided select option 1.
   * If this fails, you're probably using a directory requiring elevation: Choose to _Run as Administrator_ in the context menu.

#### RV House
You will want to configure RV House so it can find your copy of RVGL and it boots with the following flags to get into the game quickly:
`-nointro -sload`

If you want to define a specific window size, information about that is provided in the next section.

### RVGL: Specific window size
If you'd like to open the game with a specific window size ratherthan using borderless fullscreen, then you can perform the following:

1. Visit [**Andrew Hedges' Aspect Ratio Calculator**](https://andrew.hedges.name/experiments/aspect_ratio/)
2. Define for <i>W<sub>1</sub></i> and <i>H<sub>1</sub></i> the _aspect ratio_ of the display space
3. Define for whichever is most narrow (typically, <i>H<sub>2</sub></i>) window size: Website should autofill the last field.
   * In this case, you will want something a bit less than your current display resolution.
4. Use this information to display the game. Example: `-aspect 16 9 -window 1366 768`
   * This can also be appended in your command flags for RVGL in RV House.
