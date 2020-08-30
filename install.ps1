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
	### Require administrator privileges ###
	#"RequireAdmin", #This does NOT work
	"InstallPrograms",
	"DebloatAll"
)


Function InstallPrograms {
	Write-Output "Executing Function InstallPrograms"

	Write-Output "Installing FFmpeg for Audacity 2.2.2.20181007. Do NOT install version newer than 2.2.2"
	choco install audacity-ffmpeg -y

}

Function DebloatAll {
    $Bloatware = @(
        #Unnecessary Windows 10 AppX Apps
        "Microsoft.BingNews"
        "Microsoft.GetHelp"
        "Microsoft.Getstarted"
        "Microsoft.Messaging"
        "Microsoft.Microsoft3DViewer"
        "Microsoft.MicrosoftSolitaireCollection"
        "Microsoft.NetworkSpeedTest"
        "Microsoft.News"
        "Microsoft.Office.Lens"
        "Microsoft.Office.Sway"
        "Microsoft.OneConnect"
        "Microsoft.People"
        #"Microsoft.Print3D"
        #"Microsoft.SkypeApp"
        "Microsoft.StorePurchaseApp"
        "Microsoft.Whiteboard"
        "Microsoft.WindowsAlarms"
        "microsoft.windowscommunicationsapps"
        "Microsoft.WindowsFeedbackHub"
        "Microsoft.WindowsMaps"
        "Microsoft.WindowsSoundRecorder"
        "Microsoft.ZuneMusic"
        "Microsoft.ZuneVideo"

        #Sponsored Windows 10 AppX Apps
        #Add sponsored/featured apps to remove in the "*AppName*" format
        "*EclipseManager*"
        "*ActiproSoftwareLLC*"
        "*AdobeSystemsIncorporated.AdobePhotoshopExpress*"
        "*Duolingo-LearnLanguagesforFree*"
        "*PandoraMediaInc*"
        "*CandyCrush*"
        "*BubbleWitch3Saga*"
        "*Wunderlist*"
        "*Flipboard*"
        "*Twitter*"
        "*Facebook*"
        "*Spotify*"
        "*Royal Revolt*"
        "*Sway*"
        "*Speed Test*"
        "*Dolby*"
             
        #Optional: Typically not removed but you can if you need to for some reason
        "*Microsoft.Advertising.Xaml_10.1712.5.0_x64__8wekyb3d8bbwe*"
        "*Microsoft.Advertising.Xaml_10.1712.5.0_x86__8wekyb3d8bbwe*"
        "*Microsoft.BingWeather*"
        #"*Microsoft.MSPaint*"
        #"*Microsoft.MicrosoftStickyNotes*"
        #"*Microsoft.Windows.Photos*"
        #"*Microsoft.WindowsCalculator*"
        #"*Microsoft.WindowsStore*"
    )
    foreach ($Bloat in $Bloatware) {
        Get-AppxPackage -Name $Bloat| Remove-AppxPackage
        Get-AppxProvisionedPackage -Online | Where-Object DisplayName -like $Bloat | Remove-AppxProvisionedPackage -Online
        Write-Output "Trying to remove $Bloat."
    }
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
