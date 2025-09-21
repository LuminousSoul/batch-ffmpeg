@echo off
setlocal enabledelayedexpansion

REM Count total TS files first
set count=0
for %%f in (*.ts) do set /a count+=1

if %count%==0 (
    echo No TS files found in this folder.
    pause
    exit
)

REM Initialize file index
set index=0

REM Loop through all TS files
for %%f in (*.ts) do (
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
