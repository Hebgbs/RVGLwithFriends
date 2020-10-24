@ECHO OFF
REM | Hey user, touch these. Paths defined below directly affect script functionality.
REM | These variables are explained in the Git repo readme, open RVGLwithFriends/readme.md for more information.
SET RVGLpath="%systemdrive%\Games\RVGL"
SET gitPath="%userprofile%\Documents\GitHub\rvglwithfriends"

REM | These are canned messages with no bearing on script functionality. Don't bother.
SET PAK=Press any key
SET HEADMSG=The following will be performed:
SET FOOTMSG=If you are comfortable with these actions, press any key to continue.
SET DONEMSG=Actions complete.

REM | Debug: Don't bother.
SET X=EXIT

REM | User script check
REM | If user-editable copy does not exist, make one.
IF NOT EXIST "%userprofile%\Desktop\RVGLcontentInstall.bat" (
	CLS
	ECHO To prevent modifications of this script in the Git repository,
	ECHO a copy of this script will be created on your desktop.
	ECHO.
	ECHO Press any key to perform this task and exit script.
	ECHO Execute the copy in %userprofile%\Desktop to continue installation.
	PAUSE > NUL
	DEL %userprofile%\Desktop\RVGLcontentInstall.bat 2>NUL
	COPY %gitPath%\RVGLcontentInstall.bat %userprofile%\Desktop
	ECHO.
	ECHO Finished. Open copy at %userprofile%\Desktop.
	ECHO %PAK%
	PAUSE > NUL
	%X%
)
IF EXIST %userprofile%\Desktop\RVGLcontentInstall.bat (GOTO locChk)

REM | Make sure user is using the copy at their desktop
:locChk
IF NOT EXIST %~dp0\keepme (GOTO RVGLchk)
IF EXIST %~dp0\keepme (
	COLOR 0C
	CLS
	ECHO Incorrect copy.
	ECHO Use the copy from %userprofile%\Desktop.
	ECHO.
	ECHO This is to prevent accidential modification of the repository copy.
	GOTO fixMe
)

REM | Game check
REM | If game does not exist, stop.
:RVGLchk
IF NOT EXIST "%RVGLpath%\rvgl.exe" (
	COLOR 0C
	CLS
	ECHO Game executable does not exist.
	ECHO Please modify script so %%RVGLpath%% is the game directory.
	GOTO fixMe
)
IF EXIST "%RVGLpath%\rvgl.exe" (GOTO gitChk)

REM | Git repo check
REM | If git content does not exist, stop.
:gitChk
IF NOT EXIST "%gitPath%\keepme" (
	COLOR 0C
	CLS
	ECHO Check file not detected.
	ECHO Please modify script so %%gitPath%% is the content directory.
	GOTO fixMe
)
IF EXIST "%gitPath%\keepme"(GOTO instMenu

REM | Script action menu
:instMenu
COLOR 0B
CLS
ECHO Content installation script for RVGL
ECHO.
ECHO This script will either install or remove
ECHO content pased upon the action selected below.
ECHO.
ECHO Please make a selection below.
ECHO ------------------------------
ECHO 0. Exit this script
ECHO 1. Install modifications
ECHO 2. Remove modifications
ECHO.
set /p choice=Selection:
if '%choice%'=='' ECHO "%choice%" isn't a selection; Try again.
if '%choice%'=='0' GOTO endMe
if '%choice%'=='1' GOTO ln
if '%choice%'=='2' GOTO rmChk

REM | Action 1.
:ln
CLS
ECHO %HEADMSG%
ECHO.
ECHO - Rename stock directories in %RVGLpath% for later restoration
ECHO - Make links to directories from %gitPath% to %RVGLpath%
ECHO.
ECHO %FOOTMSG%
PAUSE > NUL
GOTO doInst

REM | Performance: Installation
:doInst
REN %RVGLpath%\cars oldCars
REN %RVGLpath%\levels oldLevels
REN %RVGLpath%\gfx oldGFX
MKLINK /J %RVGLpath%\cars %gitPath%\cars
MKLINK /J %RVGLpath%\levels %gitPath%\levels
MKLINK /J %RVGLpath%\gfx %gitPath%\gfx
ECHO. > %RVGLpath%\keepme
CLS
COLOR 0A
ECHO %DONEMSG%
ECHO Open RVGL and enjoy your new content!
GOTO End

REM | Action 2.
REM | Removal prevention
:rmChk
IF NOT EXIST "%RVGLpath%\keepme" (
	COLOR 0C
	CLS
	ECHO Are you sure you had installed this previously?
	ECHO For safety of default content, action has been cancelled.
	ECHO.
	ECHO If you are sure you've executed this before and the file this
	ECHO script seeks to continue removal doesn't exist then remove
	ECHO the content and restore stock files yourself.
	GOTO End
)
IF EXIST "%RVGLpath%\rvgl.exe" (GOTO rm)

:rm
CLS
ECHO %HEADMSG%
ECHO.
ECHO - Delete links to content from Git repository
ECHO - Rename stock directories to restore them.
ECHO.
ECHO %FOOTMSG%
PAUSE > NUL
GOTO doDel

REM | Performance: removal
:doDel
RMDIR %RVGLpath%\cars
RMDIR %RVGLpath%\levels
RMDIR %RVGLpath%\gfx
REN %RVGLpath%\oldCars cars
REN %RVGLpath%\oldLevels levels
REN %RVGLpath%\oldGFX gfx
DEL %RVGLpath%\keepme
ECHO %DONEMSG%
ECHO.
ECHO All modifications had been removed.
GOTO End

REM | Action 0.
:endMe
CLS
ECHO Action cancelled.
GOTO End

REM | Fix advice
:fixMe
ECHO.
ECHO You can begin modifying this file by choosing to edit
ECHO from the context menu on your desktop or in explorer.
GOTO End

REM | Stop message.
:End
ECHO.
ECHO %PAK% to exit.
PAUSE > NUL
COLOR 07
%X%
