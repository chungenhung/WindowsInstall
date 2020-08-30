#List of functions that will run.
$tweaks = @(
	### Require administrator privileges ###
	"RequireAdmin"
)

# Relaunch the script with administrator privileges
Function RequireAdmin {
	Read-Host -Prompt "Press Enter to continue"
	If (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]"Administrator")) {
		Start-Process powershell.exe "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`" $PSCommandArgs" -WorkingDirectory $pwd -Verb RunAs
		Write-Output "Msg 0."
		Read-Host -Prompt "Press Enter to continue"
		Exit
	}
	Write-Output "Msg 1."
	Read-Host -Prompt "Press Enter to continue"
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

Write-Output "Msg 2."
Read-Host -Prompt "Press Enter to continue"

Write-Output "Executing FUnction InstallPrograms"
	
Write-Output "Msg 3."
Read-Host -Prompt "Press Enter to continue"
		
Write-Output "Installing Chocolatey"
Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
choco install chocolatey-core.extension -y
	
Write-Output "Msg 4."
Read-Host -Prompt "Press Enter to continue"
