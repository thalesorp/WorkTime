# Compile
# Script that compiles the PowerShell and AutoHotkey scripts of WorkTime project
#
# Version 1
# (c) 2021 Thales Pinto <ThalesORP@gmail.com> under the GPL
#          http://www.gnu.org/copyleft/gpl.html
#

$OriginalPath = Get-Location

cd "D:\Projects\Scripts\WorkTime"

ps2exe .\WorkTimeCore.ps1 .\WorkTimeCore.exe -noConsole

cd "C:\Program Files\AutoHotkey\Compiler"

./Ahk2Exe /in "D:\Projects\Scripts\WorkTime\WorkTime.ahk" /out "D:\Projects\Scripts\WorkTime\WorkTime.exe"

cd $OriginalPath
