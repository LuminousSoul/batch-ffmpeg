@echo off
setlocal enabledelayedexpansion

REM Count total MP4 files first
set count=0
for %%f in (*.mp4) do (
    set /a count+=1
)

if !count! equ 0 (
    echo No MP4 files found in this folder.
    pause
    exit /b
)

REM Initialize file index
set index=0

REM Loop through all MP4 files
for %%f in (*.mp4) do (
    set /a index+=1
    echo Processing file !index! of !count!: "%%f"
	
	
	REM extract Thumbnail
	ffmpeg -ss 00:00:00 -i "%%f" -frames:v 1 -q:v 2 thumbnail.png
	
	ffmpeg -i "%%~nf.mp4" -i thumbnail.png -map 1 -map 0 -c copy -disposition:0 attached_pic "%%~nf [T].mp4"
	del thumbnail.png
)

echo Conversion complete!
pause

