#List of functions that will run.
$tweaks = @(
	### Require administrator privileges ###
	"RequireAdmin"
	#"InstallPrograms"
)

# Relaunch the script with administrator privileges
Function RequireAdmin {
	Read-Host -Prompt "Press Enter to continue"
	If (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]"Administrator")) {
		Start-Process powershell.exe "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`" $PSCommandArgs" -WorkingDirectory $pwd -Verb RunAs
		Exit
	}
	Write-Output "Msg 1."
	Read-Host -Prompt "Press Enter to continue"
}

Function InstallPrograms {
	Write-Output "Msg 2."
	Read-Host -Prompt "Press Enter to continue"
	
	Write-Output "Executing FUnction InstallPrograms"
	
	Write-Output "Msg 3."
	Read-Host -Prompt "Press Enter to continue"
		
	Write-Output "Installing Chocolatey"
	Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
	choco install chocolatey-core.extension -y

	Write-Output "Install these Visual C++ Redistributable Packages first. Because some programs require it"

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

Write-Output "Msg 4."
Read-Host -Prompt "Press Enter to continue"
