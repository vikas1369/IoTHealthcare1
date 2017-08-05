@echo off this is a comment line
if not exist D:\OldDir.txt echo. > D:\OldDir.txt @creates the OldDir if doesnt exist already
dir /b "C:\Users\VIKAS\AppData\Local\Google\Cloud SDK\data" > D:\NewDir.txt @get the list of files from data directory and save it in New NewDir file
set equal=no 
@used for deciding whether some files have been added or not
fc D:\OldDir.txt D:\NewDir.txt | find /i "no differences" > nul && set equal=yes 
@compares the content of old dir and new directory if there are no difference fc returns no differences and then we use nul to not show any output if Newdir and OldDir have same contents then set equal to yes 
copy /y D:\Newdir.txt D:\OldDir.txt > nul 
@Modify the OldDir with NewDir file names
if %equal%==yes (echo "Not changed") else (start cmd /k gsutil rsync -r "C:\Users\VIKAS\AppData\Local\Google\Cloud SDK\data" gs://healthcareiot
)
@if equal is not yes then invoke command to sync the two directory
