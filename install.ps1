<#
https://christitus.com/ultimate-windows-setup-guide/
The original URL is https://raw.githubusercontent.com/ChrisTitusTech/win10script/master/win10debloat.ps1
He shortened it using git.io.
powershell -nop -c "iex(New-Object Net.WebClient).DownloadString('https://git.io/JJ8R4')"

My own script
The original URL is https://raw.githubusercontent.com/chungenhung/WindowsInstall/master/install.ps1
powershell -nop -c "iex(New-Object Net.WebClient).DownloadString('https://git.io/JUtcu')"


#>
#===============================================================================

#List of functions that will run.
$tweaks = @(
	"DisableNetDevicesAutoInst",  # "EnableNetDevicesAutoInst",
	#"DisableCtrldFolderAccess",	# "EnableCtrldFolderAccess",
	# "DisableFirewall",            # "EnableFirewall",
	#"DisableDefender",            # "EnableDefender",
	#"DisableDefenderCloud",       # "EnableDefenderCloud",
	"EnableF8BootMenu",             # "DisableF8BootMenu",
	#"SetDEPOptOut",                 # "SetDEPOptIn",
	# "EnableCIMemoryIntegrity",    # "DisableCIMemoryIntegrity",
	#"DisableScriptHost",            # "EnableScriptHost",
	#"EnableDotNetStrongCrypto",     # "DisableDotNetStrongCrypto",
	"DisableMeltdownCompatFlag", # "EnableMeltdownCompatFlag"    
)

Function DisableNetDevicesAutoInst {
	Write-Output "Disabling automatic installation of network devices..."
	If (!(Test-Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\NcdAutoSetup\Private")) {
		New-Item -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\NcdAutoSetup\Private" -Force | Out-Null
	}
	Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\NcdAutoSetup\Private" -Name "AutoSetup" -Type DWord -Value 0
}

# Enable F8 boot menu options
Function EnableF8BootMenu {
	Write-Output "Enabling F8 boot menu options..."
	bcdedit /set `{current`} bootmenupolicy Legacy | Out-Null
}

# Disable Meltdown (CVE-2017-5754) compatibility flag
Function DisableMeltdownCompatFlag {
	Write-Output "Disabling Meltdown (CVE-2017-5754) compatibility flag..."
	Remove-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\QualityCompat" -Name "cadca5fe-87d3-4b96-b7fb-a231484277cc" -ErrorAction SilentlyContinue
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
		$tweaks = Get-Content $preset -ErrorAction Stop | ForEach-Object { $_.Trim() } | Where-Object { $_ -ne "" -and $_[0] -ne "#" }
	}
}

#>>>>>>> MAIN PROGRAM that will kick start everything >>>>>>>>>>>>>>>>>>>>>>>>>>
# Call the desired tweak functions
$tweaks | ForEach-Object { Invoke-Expression $_ }

Read-Host -Prompt "Press Enter to continue"

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
