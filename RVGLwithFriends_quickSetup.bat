@ECHO OFF

REM | User variables; ADJUST AS NECESSARY
REM | ! For %userPath%, if you would prefer this to reflect a device partition designated a "Drive letter"
REM |   due to library directory target being changed, do not forget the colon (:).
SET gamePath=%appdata%\RVGL
SET userPath=%userprofile%
SET repoPath=%userPath%\Documents\GitHub
SET deskPath=%userPath%\Desktop
SET wgetPath=%userPath%\Downloads

REM | Game launch parameters
REM | These will influence how the game runs, same as if a desktop shortcut were made.
REM | ! Consult https://re-volt.gitlab.io/rvgl-docs/general.html#launch-parameters for more information
SET commands=-nointro -sload
REM | -profile: Single-user mode
REM | -noforce: Disable force feedback

REM | Debug: Set /b to leave console opened.
SET X=EXIT
REM | REM disables, ECHO enables; M=finmod

SET M=REM
REM | REM disables, blank enables; G=pre-run Git tasks, L=launch
SET G=
SET L=

REM | Normalize for Program Files (x86)
REM | Also, define what copy of Git SCM is used.
IF NOT EXIST "%programfiles(x86)%" (
	SET programfilesX86="%programfiles%"
	SET gitSCMarch=32-bit
	SET RVGLarch=win32
)
IF EXIST "%programfiles(x86)%" (
	SET programfilesX86="%programfiles(x86)%"
	SET gitSCMarch=64-bit
	SET RVGLarch=win64
)

REM | Canned messages. Do not modify.
SET PAK=Press any key
SET cont=to continue.
SET invoke=This script will now invoke a web request to download
SET waitReq=Please wait as this task completes.

REM | Since you're reading this...
REM | Here are the URLs for everything this script gives.
REM | Supplied at the head of this document for convenience (and future updates!)
REM | -> GitHub Desktop (Do not tamper with variable, this is for 32-bit compatibility.)
SET gitURL=https://github.com/git-for-windows/git/releases/download/v2.29.2.windows.1/Git-2.29.2-%gitSCMarch%.exe
REM | -> RV House (online matchmaking)
SET RVHurl=http://rv12.revoltzone.net/downloads/rv_house_setup.exe
REM | -> Re-Volt OpenGL (RVGL, again don't mess with the arch var.)
SET gameURL=https://distribute.re-volt.io/releases/rvgl_full_%RVGLarch%_original.zip
REM | Location of extra content
SET repoURL=https://github.com/Hebgbs/RVGLwithFriends.git

%G% IF NOT EXIST %gamePath%\rvgl.exe GOTO admin
%G% IF NOT EXIST %repoPath%\RVGLwithFriends\NUL (
%G%		SET postInst=launch
%G%		IF EXIST %gamePath%\defaultCars\NUL DEL %gamePath%\cars
%G%		IF EXIST %gamePath%\defaultLevels\NUL DEL %gamePath%\levels
%G%		IF EXIST %gamePath%\defaultGFX\NUL DEL %gamePath%\gfx
%G%		GOTO clone
%G% )
%G% IF EXIST %repoPath%\RVGLwithFriends\NUL (
%G%	git -C %repoPath%\RVGLwithFriends pull
%G%	ECHO.
%G% )
%G% IF EXIST %gamePath%\rvgl.exe GOTO launch
%L% :launch
%L% IF EXIST %gamePath%\rvgl.exe (
%L%		ECHO Launching game...
%L%		CD /D %gamePath%
%L%		rvgl.exe %commands%
%L%		%X%
%L% )

REM | Get admin
:admin
CLS
COLOR 0E
ECHO Requesting for administrative privileges...
cd /d "%~dp0" && (if exist "%temp%\getadmin.vbs" del "%temp%\getadmin.vbs") && fsutil dirty query %systemdrive% 1>nul 2>nul || (  echo Set UAC = CreateObject^("Shell.Application"^) : UAC.ShellExecute "cmd.exe", "/k cd ""%~sdp0"" && %~s0 %params%", "", "runas", 1 >> "%temp%\getadmin.vbs" && "%temp%\getadmin.vbs" && exit )
ECHO.
ECHO Privileges received! %PAK% to proceed.
PAUSE > NUL
GOTO consent

:consent
CLS
COLOR 05
ECHO Greetings! This script will assist with the following actions:
ECHO - Installing Git (via GitHub desktop, should it not exist)
ECHO - Installing RV House for netplay using Re-Volt OpenGL ("RVGL")
ECHO - Installing RVGL and adding modificaations from my Git repository
ECHO.
ECHO This means that once you continue, this script will act on your
ECHO behalf to retrieve content from the Internet and perform file
ECHO operations on your PC. Do you understand and accept this?
ECHO.
ECHO 1. Yes
ECHO 0. No
ECHO.
set /p choice=Selection: 
if '%choice%'=='' ECHO "%choice%" isn't a selection; Try again.
if '%choice%'=='1' GOTO repoPathChk
if '%choice%'=='0' GOTO refuse
GOTO consent

:repoPathChk
IF EXIST %userPath%\Documents\NUL GOTO wgetPathChk
IF NOT EXIST %userPath%\Documents\NUL GOTO badPaths
:wgetPathChk
IF EXIST %userPath%\Downloads\NUL GOTO deskPathChk
IF NOT EXIST %userPath%\Downloads\NUL GOTO badPaths
:deskPathChk
IF EXIST %userPath%\Desktop\NUL GOTO pathConfirm
IF NOT EXIST %userPath%\Desktop\NUL GOTO badPaths

:badPaths
COLOR 04
ECHO Where's your stuff? This script is relying on
ECHO directories from %userPath% but they do not exist.
ECHO.
ECHO If you or your system administrator had recently
ECHO changed target paths for directories normally in
ECHO %userprofile%, then edit this script and modify
ECHO %%userPath%% to reflect root device / directory
ECHO where your downloads and documents are kept.
ECHO,
GOTO abort

:pathConfirm
CLS
ECHO The following directories are defined as paths to use;
ECHO - Per-user installation of game:
ECHO 	%gamePath%
ECHO - Shortcut launcher:
ECHO 	%deskPath%
ECHO - Local Git repository location:
ECHO 	%repoPath%
ECHO - Local downloads location:
ECHO 	%wgetPath%
ECHO.
ECHO If any of these appear incorrect, exit script and
ECHO edit this batch file as necessary for your system.
ECHO.
ECHO Else %PAK% %cont%
PAUSE > NUL
GOTO initGitChk

REM | Routines for each segment
REM | -> GitHub
:gitMissing
ECHO Git SCM does not exist!
ECHO This is required for the script to perform as intended.
ECHO.
ECHO The easiest way to acquire and purpose Git for this
ECHO instance is to download Git SCM for Windows.
ECHO.
GOTO preGet

:gitPerform
ECHO Setup will now open on your behalf. There are a
ECHO lot of questions it will ask, configure as necessary
ECHO and you should't have a hard time with using it.
ECHO.
ECHO Do not change installation path; script assumes it exists.
ECHO You can reconfigure Git SCM on your own any time later.
ECHO.
ECHO %PAK% %cont%
PAUSE > NUL
GOTO genericTasks

REM | -> RV House
:RVHmissing
ECHO Based on this script's defined paths, RV House doesn't
ECHO exist. This is necessary for easy, convenient matchmaking.
ECHO.
ECHO The latest known version of this utility will be provided.
ECHO.
GOTO preGet

:RVHperform
ECHO During installation, do not tamper with directory path
ECHO or this script will assume it hadn't been installed.
ECHO Just breeze through the prompts and use defaults.
ECHO.
ECHO %PAK% %cont%
PAUSE > NUL
CLS
ECHO You will need to register with Re-Volt Zone prior to
ECHO joining as that is RV House's means of user authentication.
ECHO You can register at https://revoltzone.com.
GOTO genericTasks

REM | -> RVGL
:RVGLmissing
ECHO Based on this script's defined paths, Re-Volt OpenGL wasn't
ECHO found. RVGL needs to exist for this script to fulfill its
ECHO purpose; creating symbolic links to the game directory for
ECHO use of remote content from Git repository RVGLwithFriends.
ECHO.
GOTO preGet

:RVGLperform
SET task=extract
SET perform=%nextChk%
ECHO Content must be extracted from the retrieved archive. This
ECHO includes all basic files for game operation, though some
ECHO directories will be modified after the fact.
ECHO.
ECHO %PAK% %cont%
PAUSE > NUL
MKDIR %gamePath% > NUL
GOTO preEx

:genericTasks
%wgetPath%\%fileName%
GOTO %nextChk%

:chk
IF EXIST %expect% GOTO %nextChk%
IF NOT EXIST %expect% GOTO notExist

:notExist
CLS
COLOR 0D
GOTO %missing%

:preGet
ECHO %invoke%:
ECHO %fileName%.
ECHO.
ECHO %PAK% %cont%
PAUSE > NUL
CLS
ECHO Saving %fileName% from %getURL% to %wgetPath%.
GOTO PSDstage

:preEx
CLS
ECHO Extracting %fileName% to %gamePath%.
GOTO PSDstage

:extract
ECHO %waitReq%
REM | I / O conversation measure
IF NOT EXIST %gamePath%\rvgl.exe (
	powershell -command Expand-Archive -LiteralPath "${env:wgetPath}\${env:fileName}" -DestinationPath "${env:gamePath}" -Force
)
GOTO action

:download
ECHO %waitReq%
REM | Bandwidth conservation measure
IF NOT EXIST %wgetPath%\%fileName% (
	powershell -command Invoke-WebRequest -Uri "${env:getURL}" -OutFile "${env:wgetPath}\${env:fileName}"
)
GOTO action

:action
CLS
GOTO %perform%

:PSDstage
REM | Beautify output for PowerShell actions
ECHO.
ECHO.
ECHO.
ECHO.
ECHO.
ECHO.
GOTO %task%

:initGitChk
SET task=download
SET expect="%programfiles%"\Git\git-cmd.exe
SET missing=gitMissing
SET getURL=%gitURL%
SET fileName=Git-2.29.2-%gitSCMarch%.exe
SET perform=gitPerform
SET nextChk=initRVHchk
GOTO chk

:initRVHchk
SET task=download
SET expect=%programfilesX86%\"RV House"\rv_house.exe
SET missing=RVHmissing
SET getURL=%RVHurl%
SET fileName=rv_house_setup.exe
SET perform=RVHperform
SET nextChk=initRVGLchk
GOTO chk

:initRVGLchk
SET task=download
SET expect=%appdata%\RVGL\rvgl.exe
SET missing=RVGLmissing
SET getURL=%gameURL%
SET fileName=rvgl_full_%RVGLarch%_original.zip
SET perform=RVGLperform
SET nextChk=git
GOTO chk

:git
CLS
COLOR 05
ECHO The last step is to use git for pulling the repository RVGLwithFriends
ECHO and symbolically linking with directory junctions custom content.
ECHO.
ECHO If you hadn't played the game for awhile, new content in this
ECHO repository might exist, which is why it is recommended to perform
ECHO "git -C %repoPath%\RVGLwithFriends pull"
ECHO occasionally to receive new content before executing RVGL.
ECHO,
ECHO Should the game be executed using this script, git will be invoked
ECHO automatically so you don't have to worry about pullng new content.
ECHO.
ECHO %PAK% %cont%
PAUSE > NUL
REM | Only for fresh install, ideally.
SET postInst=fin
GOTO clone

:clone
IF NOT EXIST %repoPath% MKDIR %repoPath%
REM | MUST be handled in a separate instance in case Git SCM did not exist at the time.
cmd /C git -C %repoPath% clone %repoURL%
GOTO :link

:link
IF NOT EXIST %gamePath%\defaultCars REN %gamePath%\cars defaultCars
IF NOT EXIST %gamePath%\defaultLevels REN %gamePath%\levels defaultLevels
IF NOT EXIST %gamePath%\defaultGFX REN %gamePath%\gfx defaultGFX
IF NOT EXIST %gamePath%\cars MKLINK /J %gamepath%\cars %repoPath%\RVGLwithFriends\cars > NUL
IF NOT EXIST %gamePath%\levels MKLINK /J %gamepath%\levels %repoPath%\RVGLwithFriends\levels > NUL
IF NOT EXIST %gamePath%\gfx MKLINK /J %gamepath%\gfx %repoPath%\RVGLwithFriends\gfx > NUL
GOTO %postInst%

:refuse
ECHO There is a quick-start guide which will allow you to perform the
ECHO actions this sctipt automates for you to do on your own.
ECHO.
ECHO Would you like to view it and perform these actions yourself?
ECHO.
ECHO 1. Yes
ECHO 0. No
ECHO.
set /p choice=Selection: 
if '%choice%'=='' ECHO "%choice%" isn't a selection; Try again.
if '%choice%'=='1' GOTO www
if '%choice%'=='0' GOTO abort
GOTO refuse

:fin
CLS
COLOR 0A
ECHO Finished!
ECHO.
%M% This script has been modified! Reverse dev changes before submitting!
%M%.
ECHO Run this batch script again to play RVGL
ECHO and use custom content from RVGLwithFriends!
ECHO.
GOTO abort

:www
CLS
ECHO Your web browser should open shortly after seeing this message.
ECHO.
START https://github.com/Hebgbs/RVGLwithFriends/blob/master/quickstart.md
GOTO abort

:abort
ECHO %PAK% to exit.
PAUSE > NUL
%X%
