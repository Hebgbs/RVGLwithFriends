# Work
# <3 Thanks Venryx for this answer to self-elevate script from https://stackoverflow.com/questions/7690994
if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Start-Process PowerShell -Verb RunAs "-NoProfile -ExecutionPolicy RemoteSigned -Command `"cd '$pwd'; & '$PSCommandPath';`"";
    exit;
}

# !!! The above is for getting admin since this script does elevated user things.
#     The fact this code is on GitHub should be telling of my trust it is not malicious.
#     If however that trust is compromised, it is not by my hand such had occurred.

################################################################################
# Since you're reading this, below are the arguments RVGL uses to execute.     #
# Edit these as necessary, and nothing else unless you're iterating upon this. #
################################################################################

$arguments = "-nointro -sload"
# Disable force feedback: -noforce (Regardless if joypad has support)
# Set window size: -window X Y (i.e. 1366 768)
# Set aspect ratio: -aspect X Y (i.e. 16 9)
# Profile (single-user): -profile (only select last user)
# Profile (ONLY single user): -profile NAME (i.e. -profile Foo)

# !!! Everything after this should be hands-off unless you really know what you are doing.
#     Seriously. It's a mess down here, you don't need to see that.

# Script version
$sv = "111920_0030"
$svs = "-----------"

function clearText {
if ( $cls -eq 1 ) {
	clear
	}
}

# Canned text
$pak = "Press any key"
$cont = "to continue"
$waitReq = "Please wait as this task completes."

function pakPrompt {
  echo ""
  Read-Host "$pak $cont"
}

# Program Files check
# 1. Establish paths with variables
$pgrmPath = (Get-ItemPropertyValue -Path "Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion" -Name "ProgramFilesDir") # Typically '$env:systemroot\Program Files'
$pgrmPx86 = (Get-ItemPropertyValue -Path "Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion" -Name "ProgramFilesDir (x86)") # Typically '$env:systemroot\Program Files (x86)'
# 2. Set $x86Pgrms based on which exists. Also defines URL variables for architecture specificity.
#    This only matters if user installs for all, rather than for self.
if ( Test-Path -Path $pgrmPx86 ) {
	$x86Pgrms = $pgrmPx86
  $gitArch = '64-bit'
  $RVGLarch = 'win64'
}
if ( -not ( Test-Path -Path $pgrmPx86 ) -and
 					( Test-Path -Path $pgrmPath )) {
	$x86Pgrms = $pgrmPath
  $gitArch = '32-bit'
  $RVGLarch = 'win32'
}

# Program version(s)
$gitSCM='2.29.2'

# Online repository information
$repoHost = "https://github.com"
$repoUser = "Hebgbs"
$repoName = "RVGLwithFriends"
$rns = "---------------"

# Define variables for user paths
# 1. Find root locations using known API calls
$appdata = (Get-ItemPropertyValue -Path "Registry::HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders" -Name "AppData") # Typically '$env:appdata\Roaming'
$downloads = (New-Object -ComObject Shell.Application).NameSpace('shell:Downloads').Self.Path # Typically '$env:userprofile\Downloads'
$documents =  (Get-ItemPropertyValue -Path "Registry::HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders" -Name "Personal") # Typically '$env:userprofile\Documents'
$repoPath = "$documents\GitHub"
$desktop = (Get-ItemPropertyValue -Path "Registry::HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders" -Name "Desktop") # Typically '$env:userprofile\Desktop'

# Define URLs; Kept at head for easy updating.
$gameURL = "https://distribute.re-volt.io/releases/rvgl_full_$RVGLarch`_original.zip"
$RVHurl = "http://rv12.revoltzone.net/downloads/rv_house_setup.exe"
$gitURL = "https://github.com/git-for-windows/git/releases/download/v2.29.2.windows.1/Git-$gitSCM-$gitArch.exe"
$repoURL = "$repoHost/$repoUser/$repoName.git"

function varTest {
  clearText
  echo "$repoName installation script $sv"
  echo "$rns---------------------$svs"
	echo ""
  echo "Below is the output of common variables used throughout this script."
  echo "This only shows if '`$debug' is set to 1 by the end-user."
	echo ""
	if ( $hasGame -eq "1" ) {
		echo "User has game installed at $instPref."
			if ( $ready -eq "1" ) {
				echo "Game will execute."
		}
	}
	if ( $hasGame -eq "2" ) {
		echo "User has game in more than one location."
			if ( $ready -eq "1" ) {
				echo "Script will prompt for where to execute game from."
		}
	}
	if ( $gitFatal -eq "1" ) {
		echo "Script will terminate due to lack of Git SCM."
	}
	else {
		echo "Script will execute Git prompts next."
	}
	echo ""
  echo "=== SYSTEM DIRECTORIES ==="
  echo "Program Files x86..... $pgrmPx86" # Only for 32-bit systems, returns nothing if not existing.
  echo "Program Files......... $pgrmPath"
  echo "If 64-bit show x86.... $x86Pgrms" # Defined by my extra-janky 32-bit check.
  echo ""
  echo "=== SCRIPT DIRECTORIES ==="
  echo "RVGL all users root... $pgrmPath\RVGL"
  echo "RVGL per user root.... $appdata\RVGL"
  echo "Documents location.... $documents"
  echo "Repository root....... $repoPath"
  echo "Downloads location.... $downloads"
  echo "Desktop location...... $desktop"
  echo ""
  echo "=== INTERNET ADDRESSES ==="
  echo "Git SCM.......... $gitURL"
  echo "RV House......... $RVHurl"
  echo "Re-Volt OpenGL... $gameURL"
  echo ""
	echo "=== ARCHITECTURE SPECIFIC ==="
	echo "Git.... $gitArch"
	echo "RVGL... $RVGLarch"
	echo ""
  echo "=== CANNED MESSAGES ==="
  echo "Input req. 1.... $pak"
  echo "Input req. 2.... $cont"
  echo "Wait............ $waitReq"
  echo ""
  echo "Review results and terminate if modification is necessary."
  Read-Host -Prompt "$pak $cont"
}

function dbgEnable {
	clear
	echo "For development and curious users: If you would like to use"
	echo "debug routines to see exactly what this script is doing, then"
	echo "allow it through this prompt. This also means that the script"
	echo "will perform extra function calls and take longer to complete."
	echo ""
	$debugT = ""
	$debugQ = "Enable debug features?"
	$debugO = '&Yes','Yes, and do not &clear text','No, but do not clear &text','&No','E&xit'
	$debugP = $Host.UI.PromptForChoice($debugT, $debugQ, $debugO, 3)
	if ($debugP -eq 0) {
		$debug = "1"
		$cls = "1"
		consent
	}
	if ($debugP -eq 1) {
		$debug = "1"
		consent
	}
	if ($debugP -eq 2) {
		consent
	}
	if ($debugP -eq 3) {
		$cls = "1"
		consent
	}
	else {
		exit
	}
}

function execute {
	if ( ( $hasGame -eq 0,2 ) -and
	 		 ( $ready -eq 1 ) ) {
		gameLoc
	}
	if ( ( $hasGame -eq 1 ) -and
	 		 ( $ready -eq 1 ) ) {
		runMenu
	}
}

function runMenu {
	clearText
	echo "If you had not already, you should run the game by itself"
	echo "to configure game options before joining an online lobby."
	echo ""
	$openT = ""
	$openQ = "What would you like to do now?"
	$openO = 'Play RV&GL single-player','Joi&n RV House netplay lobby','&Uninstall','E&xit'
	$openP = $Host.UI.PromptForChoice($openT, $openQ, $openO, -1)
	if ( $openP -eq 0 ) {
		runRVGL
	}
	if ( $openP -eq 1 ) {
		runRVG
	}
	if ( $openP -eq 2 ) {
		runRemove
	}
	else {
		exit
	}
}

function runRVGL {
	cd "$instPref"
	echo "Launching $instPref\rvgl.exe"
	if ( Test-Path -Path "$pgrmFile\rvgl.exe" ) {
		echo ""
		echo "Game is in a directory which requires elevation."
		echo "Always use this script or run rvgl.exe as admin yourself"
		echo "to save data generated by the game of your progress."
	}
	Start-Process -Wait ".\rvgl.exe" "$arguments"
	runMenu
}

function runRVH {
	echo "Launching RV House"
	echo ""
	echo "If you had not already, you will need to sign in with credentials"
	echo "from https://revoltzone.net. Register, then sign into RV House to"
	echo "join the Re-Volt communiter hosting races with this service to join."
	Start-Process -Wait "$pgrmPath\RV House\rv_house.exe"
	runMenu
}

function consent {
	showDbg
	if ( $ready -eq 1 ) {
		execute
	}
  clearText
  echo "Greetings! This script will assist with the following actions:"
  echo "- Installing Git (via Git SCM for WIndows, should it not exist)"
  echo "- Installing RV House for netplay using Re-Volt OpenGL (RVGL)"
  echo "- Installing RVGL and adding modifications from my Git repository"
	echo ""
	echo "Use of this software is an acknowledgement of waived liability:"
	echo "The author is not responsible for any critical system failure issues"
	echo "encountered from its use, at any time, for this specific release."
	echo "Furthermore you accept this software is an error-ridden piece of crap"
	echo "barely held together with various solutions from the Internet."
	echo ""
	echo "Honestly, thank you StackExchange community. I am not worthy. <3"
	echo ""
	echo "Once you continue, this script will act on your behalf to retrieve"
	if ( $gitFatal -ne 1 ) {
	  echo "content from the Internet and perform file operations on your PC."
	}
	if ( $gitFatal -eq 1 ) {
		echo "software installation media, including Git SCM for Windows which"
		echo "since it is missing, will require this script to be executed once"
		echo "more for continuation of file operations to make Re-Volt OpenGL"
		echo "function with additional content from $repoName."
	}
  echo ""
  $consentT = ""
  $consentQ = "Do you understand and accept this?"
  $consentO = '&Yes', '&No'
  $consent = $Host.UI.PromptForChoice($consentT, $consentQ, $consentO, 1)
  if ($consent -eq 0) {
		clearText
		gameLoc
  }
  else {
    refuse
  }
}

function refuse {
  clearText
  echo "No file operations will be performed using this script."
  echo ""
  echo "If you wish to download and install everything yourself, there"
  echo "is a quick-start guide available online for your convenience."
  echo ""
  $manualT = ""
  $manualQ = "Would you like to view it via your web browser?"
  $manualO = '&Yes', '&No'
  $manualP = $Host.UI.PromptForChoice($manualT, $manualQ, $manualO, 0)
  if ($manualP -eq 0) {
    Start-Process "https://github.com/Hebgbs/$repoName/blob/master/quickstart.md"
		}
  else {
    Read-Host "Script will now terminate. $pak to exit."
    exit
  }
}

function gameLoc {
	if ( ( $hasGame -eq 2 ) -and
			 ( $ready -eq 1 ) ) {
		echo "RVGL has been detected to be in more than one location"
		echo "and is ready to open, but it exists in more than one place."
		$instPrefQ = "Which copy of the game is to be executed?"
		locDecide
	}
	if ( ( $hasGame -eq 2 ) -and
			 ( $ready -lt 1 ) ) {
		echo "RVGL has been detected to be in more than one location."
		echo "This script can only continue with one instance."
		$instPrefQ = "Continue with copy for all users, or $env:USERNAME only?"
		locDecide
	}
	if ( $hasGame -eq 1 ) {
		initGitChk
	}
	if ( $hasGame -eq 0 ) {
	  echo "Before anything else, This script permits either of these installation methods:"
	  echo "- Make available for all users"
	  echo "  Installs to: $pgrmPath\RVGL"
	  echo "- Make available for $env:USERNAME only"
	  echo "  Installs to: $appdata\RVGL"
		$instPrefQ = "How would you like to install RVGL?"
		locDecide
	}
}
function locDecide {
  echo ""
  $instPrefT = ""
  $instPrefO = '&All users', '&Self only'
  $instPrefP = $host.ui.PromptForChoice($instPrefT, $instPrefQ, $instPrefO, 1)
  if ( $instPrefP -eq 0 ) {
    $instPref = "$pgrmPath\RVGL"
  }
  if ( $instPrefP -eq 1 ) {
    $instPref = "$appdata\RVGL"
  }
	if ( $debug -eq 1 ) {
	  echo ""
	  echo "Installation path set to $instPref."
	}
	if ( $ready -eq 1 ) {
		Set-Variable -Name "hasGame" -Value "1" -Scope Script
		clearText
		execute
	}
	else {
		initGitChk
	}
}

function stageDisplay {
  echo ""
  echo ""
  echo "If you see nothing here, it might take a"
  echo "minute for task to begin. Please be patient."
  echo ""
  echo ""
  echo "Please wait for current task to complete."
}

function extract {
  clearText
  if ( -not ( Test-Path -Path "$instPref\rvgl.exe" -PathType Leaf ) ) {
		if ( -not ( Test-Path -Path "$instPref" ) ) {
			mkdir "$instPref" | Out-Null
		}
    echo "Extracting $fileName to $instPref"
		echo ""
		stageDisplay
		Expand-Archive -LiteralPath "$downloads\$fileName" -DestinationPath "$instPref" -Force
  }
}

function download {
	if ( -not ( Test-Path -Path "$downloads\$fileName" -pathType Leaf ) ) {
		clearText
	  echo "This script will now invoke a web request to download:"
	  echo "$fileName"
	  echo "from $getURL"
	  pakPrompt
	  clearText
	  echo "Saving $fileName from $getURL to $downloads"
	  stageDisplay
	  Invoke-WebRequest -Uri "$getURL" -OutFile "$downloads\$fileName"
	}
  pgrmInst
}

function genericTasks {
  Start-Process -Wait "$downloads\$fileName"
  pgrmChk
}

function pgrmChk {
  if ( $debug -eq 1 ) {
    if ( Test-Path -Path "$expect" -pathType Leaf ) {
      $fileAvail = "Yes"
    }
    else {
      $fileAvail = "No"
    }
    if ($gitFatal -eq "1") {
      $gitEnd = "Yes"
    }
    else {
      $gitEnd= "No"
    }
    clearText
    echo "=== ROUTINE SUMMARY ==="
    echo "Expectant file... $expect"
    echo "File available... $fileAvail"
    echo "File address..... $getUrl"
    echo "Incoming file.... $fileName"
    echo "Dialogue start... $routine ($routineT)"
    echo "No Git SCM end... $gitEnd"
    pakPrompt
  }
  clearText
  if ( -not ( Test-Path -Path "$expect" -pathType Leaf ) ) {
    if ( $routine -eq 1 ) {
      echo "Git SCM does not exist!"
      echo "This is required for the script to perform as intended."
      echo ""
      echo "The easiest way to acquire and purpose Git for this"
      echo "instance is to download Git SCM for Windows."
      pakPrompt
    }
    if ( $routine -eq 2 ) {
      echo "RV House wasn't found! While not strictly necessary to"
      echo "enjoy a netplay session, it allows for easier coordination"
      echo "by means of using a matchmaking hub so all players in lobby"
      echo "execute RVGL with like credentials and lobby host address."
      pakPrompt
    }
    if ( $routine -eq 3 ) {
			if ($hasGame -eq 0 ) {
        echo "Re-Volt OpenGL wasn't found! Without this content, there is"
        echo "no game to play, and no reason for this script to fulfill its"
        echo "ultimate purpose of providing additional content to use along"
        echo "with base content for use in a netplay session."
        pakPrompt
			}
  	}
    download
    clearText
  }
  if ( Test-Path -Path "$expect" -pathType Leaf ) {
    if ( $routine -eq 1 ) {
      initRVHchk
    }
    if ( $routine -eq 2 ) {
      initRVGLchk
    }
    if ( $routine -eq 3 ) {
      doGit
    }
  }
}

function pgrmInst {
	clearText
  if ( $routine -eq 1 ) {
    echo "Setup will now open on your behalf. There are a"
    echo "lot of questions it will ask, configure as necessary"
    echo "and you shouldn't have a hard time with using it."
    echo ""
    echo "Do not change installation path; script assumes it exists."
    echo "You can reconfigure Git SCM on your own any time later."
		pakPrompt
		genericTasks
    initRVHchk
  }
  if ( $routine -eq 2 ) {
    echo "During installation, do not tamper with directory path"
    echo "or this script will assume it hadn't been installed."
    echo "Just breeze through the prompts and use defaults."
    pakPrompt
    genericTasks
    initRVGLchk
  }
  if ( $routine -eq 3 ) {
		if ( Test-Path -Path "$instPath\RVGL" ) {
			doGit
		}
    if ( -not ( Test-Path -Path "$instPref\RVGL" ) ) {
			echo "Content must be extracted from the retrieved archive. This"
	    echo "includes all basic files for game operation, though some"
	    echo "directories will be modified after the fact."
	    pakPrompt
	    extract
		}
    doGit
  }
}

function doGit {
  if ( $gitFatal -eq 1 ) {
		clearText
    echo "Unfortunately, due to limitations with this instance of Powershell,"
    echo "as Git was not installed at the time it wouldn't work now in spite of"
    echo "the fact it exists now."
    echo ""
    echo "The next time this script is executed, Git will be available for use"
    echo "and clone task will execute successfully, then the game will launch."
		pakPrompt
    exit
  }
	clearText
	Set-Variable -Name "skipDebug" -Value "1" -Scope Script
  echo "Git will now execute to retrieve the contents of remote repository"
  echo "$repoName so its contents are available for RVGL."
  pakPrompt
	clearText
	if ( -not ( Test-Path -Path "$repoPath" ) ) {
		mkdir "$repoPath" | Out-Null
	}
	if ( -not ( Test-Path -Path $repoPath\$repoName ) ) {
		git -C $repoPath clone https://github.com/Hebgbs/$repoName.git
	}
	else {
		git -C $repoPath pull https://github.com/Hebgbs/$repoName.git
	}
	clearText
	symlink
}

function symlink {
	if ( $ready -lt 1 ) {
	  echo "The content from $repoName cannot be used without creating"
	  echo "directory junction links in lieu of standard directories for cars,"
	  echo "levels and additional graphical assets. Else when playing online,"
	  echo "you'll be unable to proceed without custom tracks and maps!"
	  pakPrompt
	}
	if ( ( -not ( Test-Path -Path "$instPref\defaultCars" ) ) -and
	 		 ( -not ( Test-Path -Path "$instPref\defaultGFX" ) ) -and
			 ( -not ( Test-Path -Path "$instPref\defaultLevels" ) ) ) {
		mv $instPref\cars $instPref\defaultCars | Out-Null
		mv $instPref\levels $instPref\defaultLevels | Out-Null
		mv $instPref\gfx $instPref\defaultGFX | Out-Null
	}
	New-Item -Path "$instPref\cars" -ItemType SymbolicLink -Value "$repoPath\$repoName\cars" | Out-Null
	New-Item -Path "$instPref\levels" -ItemType SymbolicLink -Value "$repoPath\$repoName\levels" | Out-Null
	New-Item -Path "$instPref\gfx" -ItemType SymbolicLink -Value "$repoPath\$repoName\gfx" | Out-Null
	Set-Variable -Name "ready" -Value "1" -Scope Script
	if ( $ready -eq 1 ) {
		gameChk
	}
}

# Routine configuration
function initGitChk {
  $routine = "1"
  $routineT = "Git SCM installation"
  $expect = "$pgrmPath\Git\git-cmd.exe"
  $getURL = "$gitURL"
  $fileName = "Git-2.29.2-$gitArch.exe"
  pgrmChk
}
function initRVHchk {
  $routine = "2"
  $routineT = "RV House installation"
	$expect = "$x86Pgrms\RV House\rv_house.exe"
  $getURL = "$RVHurl"
	$fileName = "rv_house_setup.exe"
  pgrmChk
}
function initRVGLchk {
  $routine = "3"
  $routineT = "RVGL installation"
  $expect = "$instPref\RVGL\rvgl.exe"
	$fileName = "rvgl_full_$RVGLarch`_original.zip"
  $getURL = "$gameURL"
  pgrmChk
}

function fin {
echo "FInished! There is nothing else for this script to do."
	pakPrompt
	exit
}

function runRemove {
	clearText
	echo "The following will remove these components from your device:"
	echo "- Re-Volt OpenGL"
	echo "- RV House"
	echo ""
	echo "Optionally, Git SCM can be removed if you have no future need for it."
	echo ""
	$removeT = ""
	$removeQ = "What would you like to do?"
	$removeO = 'I''m &joking!', 'Remove &all','Remove, but keep &Git'
	$removeP = $Host.UI.PromptForChoice($removeT, $removeQ, $removeO, 0)

	if ( $removeP -eq 0 ) {
		runMenu
	}
	if ( $removeP -eq 1 ) {
		remove
	}
	if ( $removeP -eq 2 ) {
		$keepGit = "1"
		remove
	}
}

function remove {
	clearText
	echo "Where applicable, built-in dialogues to remove software will"
	echo "prompt for elevation. Allow them to function and this script"
	echo "will take care of cleanup behind-the-scenes, on your behalf."
	pakPrompt
	clearText
	echo "Prompting request for removing RV House"
	Start-Process -Wait "$x86Pgrms\RV House\unins000.exe"
	if ( $keepGit -ne "1" ) {
		echo "Prompting request for removing Git SCM"
		Start-Process -Wait "$pgrmPath\Git\unins000.exe"
		Remove-Item -Recurse -Force "$pgrmPath\Git"
		echo "Removing Git repository..."
		cmd /c RMDIR /Q /S "$repoPath\$repoName"
	}
	echo "Removing game files..."
	cmd /c RMDIR /Q /S $instPref
	echo "Removing downloaded items (if applicable)..."
	if ( Test-Path -Path "$downloads\rvgl_full_$RVGLarch`_original.zip" ) {
		Remove-Item "$downloads\rvgl_full_$RVGLarch`_original.zip"
	}
	if ( Test-Path -Path "$downloads\rv_house_setup.exe" ) {
		Remove-Item "$downloads\rv_house_setup.exe"
	}
	if ( Test-Path -Path "$downloads\Git-$gitSCM-$gitArch.exe" ) {
		Remove-Item "$downloads\Git-$gitSCM-$gitArch.exe"
	}
	clearText
	echo "All game files had been removed."
	echo ""
	echo "$pak to exit."
	Read-Host "Delete this script afterward if there is no intent to use it again."
	exit
}

function gameChk {
	Set-Variable -Name "ready" -Value "0" -Scope Script
	if ( ( -not ( Test-Path -Path "$appdata\RVGL" ) ) -and
			 ( -not ( Test-Path -Path "$pgrmPath\RVGL" ) ) ) {
		Set-Variable -Name "hasGame" -Value "0" -Scope Script
	}
	if ( ( Test-Path -Path "$pgrmPath\RVGL" ) -and
( -not ( Test-Path -Path "$appdata\RVGL" ) ) ) {
		Set-Variable -Name "instPref" -Value "$pgrmPath\RVGL" -Scope Script
		Set-Variable -Name "hasGame" -Value "1" -Scope Script
	}
	if ( ( Test-Path -Path "$appdata\RVGL" ) -and
( -not ( Test-Path -Path "$pgrmPath\RVGL" ) ) ) {
		Set-Variable -Name "instPref" -Value "$appdata\RVGL" -Scope Script
		Set-Variable -Name "hasGame" -Value "1" -Scope Script
	}
	if ( ( Test-Path -Path "$pgrmPath\RVGL" ) -and
			 ( Test-Path -Path "$appdata\RVGL" ) ) {
		Set-Variable -Name "instPref" -Value "" -Scope Script
		Set-Variable -Name "hasGame" -Value "2" -Scope Script
	}
	if ( -not ( Test-Path -Path "$pgrmPath\Git\git-cmd.exe" ) ) {
		Set-Variable -Name "gitFatal" -Value "1" -Scope Script
	}
	if ( ( Test-Path -Path "$instPref\defaultCars" ) -and
	 		 ( Test-Path -Path "$instPref\defaultGFX" ) -and
			 ( Test-Path -Path "$instPref\defaultLevels" ) -and
			 ( Test-Path -Path "$repoPath\$repoName" ) ) {
		Set-Variable -Name "ready" -Value "1" -Scope Script
		if ( ( -not ( Test-Path -Path "$instPref\cars" ) ) -or
				 ( -not ( Test-Path -Path "$instPref\gfx" ) ) -or
				 ( -not ( Test-Path -Path "$instPref\levels" ) ) ) {
			symlink
			}
    if ( $skipDebug -lt 1 ) {
		  dbgEnable
    }
	}
}

function showDbg {
	if ( $debug -eq 1 ) {
		varTest
	}
}

gameChk
if ( $skipDebug -eq 1 ) {
	consent
}
else {
  dbgEnable
	consent
}
