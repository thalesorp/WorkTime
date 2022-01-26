# Work Time Core
# A script that opens and closes up work related applications
#
# Version 3
# (c) 2021 Thales Pinto <ThalesORP@gmail.com> under the GPL
#          http://www.gnu.org/copyleft/gpl.html
#

$AppName = "teams"

# Resource file: tells if the app is open or closed
$FileDirectory = "D:\Projects\Scripts\WorkTime\Resources"
$FileName = "AppOpenedStatus"
$FilePath = "$($FileDirectory)\$($FileName)"

$CurrentDay = Get-Date -Format "ddd"


# First of all, check if it's weekend
if ('Sat Sun'.contains($CurrentDay)){
    exit
}

# Now checking if the app is opened or closed
if (Get-Process $AppName -ErrorAction SilentlyContinue) {
    $OpenedStatus = $True
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

$Hour = [int]$(Get-Date -Format "HH")

# Now check if it's work time
if ( ($Hour -ge "8") -and ($Hour -le "18") ) {

    $OpenedStatus = [System.Convert]::ToBoolean($(Get-Content -Path $FilePath))

    if ($OpenedStatus -eq $False) {
        Add-Type -AssemblyName PresentationCore,PresentationFramework

        $body = "Open work related applications?"
        $title = "Work time"
        $button = "YesNoCancel"
        $image = "Question"
        $result = [System.Windows.MessageBox]::Show($body, $title, $button, $image)

        if ($result -eq "Yes") {
            Start-Process -FilePath "C:\Users\ThalesORP\Programs\Teams.lnk"
        }
        elseif ($result -eq "Cancel") {
            exit
    }

    $SecondsLeft = (New-TimeSpan -End (Get-Date -Hour 18 -Minute 0)).TotalSeconds
    Sleep -s $SecondsLeft
}

if ( ($Hour -ge "18") -and ($Hour -le "8") ){

    $OpenedStatus = [System.Convert]::ToBoolean($(Get-Content -Path $FilePath))

        if ($OpenedStatus -eq $True) {

            Add-Type -AssemblyName PresentationCore,PresentationFramework

            $body = "Close work related applications?"
            $title = "Work time"
            $button = "YesNo"
            $image = "Question"
            $result = [System.Windows.MessageBox]::Show($body, $title, $button, $image)

            if ($result -eq "Yes") {
                Stop-Process -Name "Teams" -ErrorAction SilentlyContinue
            }
            elseif ($result -eq "No") {
                $HalfHour = 60 * 30
                Start-Sleep -s $HalfHour
            }

        }

        $SecondsLeft = (New-TimeSpan -End (Get-Date -Hour 8 -Minute 0)).TotalSeconds
        Sleep -s $SecondsLeft
    }

}
