$tweaks = @(
	### Require administrator privileges ###
	"RequireAdmin",
	"InstallPrograms"
)

# Relaunch the script with administrator privileges
Function RequireAdmin {
	If (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]"Administrator")) {
		Start-Process powershell.exe "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`" $PSCommandArgs" -WorkingDirectory $pwd -Verb RunAs
		#Exit
	}
}

Function InstallPrograms {
	Write-Output "Executing Function InstallPrograms"

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
}

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
		$tweaks = Get-Content $preset -ErrorAction Stop | ForEach-Object { $_.Trim() } | Where-Object { $_ -ne "" -and $_[0] -ne "#" }
	}
}

#>>>>>>> MAIN PROGRAM that will kick start everything >>>>>>>>>>>>>>>>>>>>>>>>>>
# Call the desired tweak functions
$tweaks | ForEach-Object { Invoke-Expression $_ }

Read-Host -Prompt "Press Enter to continue"
