@echo off
setlocal enabledelayedexpansion

REM Count total AVI files first
set count=0
for %%f in (*.avi) do set /a count+=1

if %count%==0 (
    echo No AVI files found in this folder.
    pause
    exit
)

REM Initialize file index
set index=0

REM Loop through all AVI files
for %%f in (*.avi) do (
    set /a index+=1
    echo Processing file !index! of %count%: "%%f"

    ffmpeg -i "%%f" -map_metadata 0 -map 0 ^
        -c:v libx265 -preset slow -crf 28 ^
        -vf "scale='min(1920,iw)':'min(1080,ih)'" ^
        -c:a aac -b:a 192k ^
        -c:s copy ^
        -disposition:v:0 attached_pic ^
        "%%~nf[x265].mp4"
)

echo Conversion complete!
pause
