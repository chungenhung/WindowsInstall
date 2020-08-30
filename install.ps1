<#
https://christitus.com/ultimate-windows-setup-guide/
The original URL is https://raw.githubusercontent.com/ChrisTitusTech/win10script/master/win10debloat.ps1
He shortened it using git.io.
powershell -nop -c "iex(New-Object Net.WebClient).DownloadString('https://git.io/JJ8R4')"

#My own script
powershell -nop -c "iex(New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/chungenhung/WindowsInstall/master/install.ps1')"
#>
#===============================================================================

#List of functions that will run.
$tweaks = @(
	### Require administrator privileges ###
	"RequireAdmin",
	"InstallPrograms"
)

# Relaunch the script with administrator privileges
Function RequireAdmin {
	If (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]"Administrator")) {
		Start-Process powershell.exe "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`" $PSCommandArgs" -WorkingDirectory $pwd -Verb RunAs
		Exit
	}
}

Function InstallPrograms {
	pause
	Write-Output "Executing FUnction InstallPrograms"
	pause
	Write-Output "Installing Chocolatey"
	Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
	choco install chocolatey-core.extension -y

	Write-Output "Install these Visual C++ Redistributable Packages first. Because some programs require it"
	<#
	This includes:
	- vcredist2012 v11.0.61031
	- kb3033929 v1.0.5
	- kb2999226 v1.0.20181019
	- vcredist2005 v8.1.0.20160118
	- vcredist2015 v14.0.24215.20170201
	- vcredist2008 v9.0.30729.6163
	- vcredist2010 v10.0.40219.2
	- vcredist-all v1.0.0
	- vcredist2017 v14.16.27033
	- vcredist140 v14.26.28720.3
	- kb3035131 v1.0.3
	- chocolatey-windowsupdate.extension v1.0.4
	#>
	Write-Output "Microsoft Visual C++ Runtime - all versions 1.0.0"
	choco install vcredist-all -y

	#This no longer needed. It is already included in the above script.
	#Write-Output "Installing Visual C++ Redistributable Packages for Visual Studio 2013 12.0.40660.20180427"
	#choco install vcredist2013 -y

	Write-Output "Installing 7-Zip"
	choco install 7zip -y
	
	Write-Output "Installing Adobe Acrobat Reader"
	choco install adobereader -y
	
	Write-Output "Installing Audacity"
	choco install audacity -y
	
	Write-Output "Installing Brave Browser"
	choco install brave -y
	
	Write-Output "Pause 10 seconds for Brave Browser to start"
	Start-Sleep -Seconds 10
	
	Write-Output "Closing Brave Browser"
	Stop-Process -Name "Brave" -Force
	
	#Write-Output "Removing Brave Browser desktop shortcut"
	#Remove-Item -path $home\Desktop\Brave.lnk

	Write-Output "Removing ALL desktop shortcuts"
	Remove-Item -path C:\Users\Public\Desktop\*.lnk
	Remove-Item -path $home\Desktop\*.lnk
<#
As of 2020-08-28. These programs are NOT available on chocolatey.org:
Duck Capture
Logitech G-Hub. For Logitech gaming keyboard and gaming headphones.
Microsoft Office. Chocolatey have various versions, but not the one I think I need.
#>

}

##########
# Parse parameters and apply tweaks
##########

# Normalize path to preset file
$preset = ""
$PSCommandArgs = $args
If ($args -And $args[0].ToLower() -eq "-preset") {
	$preset = Resolve-Path $($args | Select-Object -Skip 1)
	$PSCommandArgs = "-preset `"$preset`""
}

# Load function names from command line arguments or a preset file
If ($args) {
	$tweaks = $args
	If ($preset) {
		$tweaks = Get-Content $preset -ErrorAction Stop | ForEach { $_.Trim() } | Where { $_ -ne "" -and $_[0] -ne "#" }
	}
}

#>>>>>>> MAIN PROGRAM that will kick start everything >>>>>>>>>>>>>>>>>>>>>>>>>>
# Call the desired tweak functions
$tweaks | ForEach { Invoke-Expression $_ }

pause

<#
Privacy settings to disable:
Diagnostic data
Find my device
Inking & typing
Location
Online speech recognition
Tailored experiences
Advertising ID
#>
