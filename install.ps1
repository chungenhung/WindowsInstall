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
	"EnhanceNetworkPerformance"
)

Function EnhanceNetworkPerformance {
	netsh int ipv4 set dynamicport tcp start=1025 num=64510
	netsh int ipv4 show dynamicport tcp

	#The path is same as HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters
	New-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" -Name "TcpTimedWaitDelay" -Value "30" -PropertyType "DWord"
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
