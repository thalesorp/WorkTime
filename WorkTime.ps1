# Work Time
# A script that opens and closes up work related applications
#
# Version 4
# (c) 2021 Thales Pinto <ThalesORP@gmail.com> under the GPL
#          http://www.gnu.org/copyleft/gpl.html
#

pwsh -windowstyle hidden {

    $AppName = "teams"
    $AppPath = Get-Process $AppName -ErrorAction SilentlyContinue | Select-Object Path
    # Resource file: tells if the app is open or closed
    $FileDirectory = "D:\Projects\Scripts\WorkTime\WorkTime\Resources"
    #$FileDirectory = "$(Get-Location)\Resources"
    $FileName = "AppOpenedStatus"
    $FilePath = "$($FileDirectory)\$($FileName)"

    Function Set-Status() {
        # Now checking if the app is opened or closed
        if (Get-Process $AppName -ErrorAction SilentlyContinue) {
            $OpenedStatus = $True
            $AppPath = Get-Process $AppName -ErrorAction SilentlyContinue | Select-Object Path
        } else {
            $OpenedStatus = $False
        }

        # If the file exists, write if the app is opened or not
        if (Test-Path $FilePath) {

            # Writing if the app is opened or not
            Set-Content -path $FilePath -Value $OpenedStatus
        }
        else {
            # Create path (if needed) and the file itself
            $null = New-Item -ItemType Directory -Force -Path $FileDirectory
            $null = New-Item -path $FileDirectory -name $FileName -type "file" -Value $OpenedStatus
        }
    }

    Function Opened-Status {
        return [System.Convert]::ToBoolean($(Get-Content -Path $FilePath))
    }

    Function Check-Weekend {
        # First of all, check if it's weekend: it will depend on the Culture defined in PowerShell
        if ( 'sat sab'.contains($CurrentDay) ){
            $DaysToWorkday = 2
        }

        if ( 'sun dom'.contains($CurrentDay) ){
            $DaysToWorkday = 1
        }

        $Workday = ([int](Get-Date -Format "dd") + $DaysToWorkday)
        $TimeToSleep = (New-TimeSpan -End (Get-Date -Day $Workday -Hour 8 -Minute 0 -Second 0)).TotalSeconds
    }

    Function Close-Work-Dialog {

        Add-Type -AssemblyName PresentationCore,PresentationFramework

        $body = "Close work related applications?"
        $title = "Work Time"
        $button = "YesNo"
        $image = "Question"
        $result = [System.Windows.MessageBox]::Show($body, $title, $button, $image)

        if ($result -eq "Yes") {
            Stop-Process -Name $AppName -ErrorAction SilentlyContinue
            $TimeToSleep = (New-TimeSpan -End (Get-Date -Hour 8 -Minute 0)).TotalSeconds
        }
        elseif ($result -eq "No") {
            # Wait half hour
            $TimeToSleep = 60 * 30
        }
        return $TimeToSleep
    }

    Function Open-Work-Dialog {

        Add-Type -AssemblyName PresentationCore,PresentationFramework

        $body = "Open work related applications?"
        $title = "Work Time"
        $button = "YesNoCancel"
        $image = "Question"
        $result = [System.Windows.MessageBox]::Show($body, $title, $button, $image)

        if ($result -eq "Yes") {
            Start-Process -FilePath $AppName
            $TimeToSleep = (New-TimeSpan -End (Get-Date -Hour 18 -Minute 0)).TotalSeconds
        }
        elseif ($result -eq "Cancel") {
            # Wait half hour
            $TimeToSleep = 60 * 30
        }
        return $TimeToSleep
    }

    $TimeToSleep = 1
    while ($true) {

        Start-Sleep -s $TimeToSleep

        Set-Status

        Check-Weekend

        $Hour = [int]$(Get-Date -Format "HH")

        # Now check if it's work time or not
        if ($(Opened-Status)){
            if ( ($Hour -In 18..24) -or ($Hour -In 0..8) ){
                $TimeToSleep = Close-Work-Dialog
            }
        } else {
            if ( $Hour -In 8..18 ) {
                $TimeToSleep = Open-Work-Dialog
            }
        }
    }

}
