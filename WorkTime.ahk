; Work Time
; A script that runs the Work Time Core repeatedly
;
; Version 3
; (c) 2021 Thales Pinto <ThalesORP@gmail.com> under the GPL
;          http://www.gnu.org/copyleft/gpl.html

#SingleInstance,Force
#Persistent


Run, D:\Projects\Scripts\WorkTime\WorkTimeCore.exe

OneMinute := 60 * 1000

SetTimer, WorkTime, %OneMinute%

return


WorkTime:

Run, D:\Projects\Scripts\WorkTime\WorkTimeCore.exe

return
