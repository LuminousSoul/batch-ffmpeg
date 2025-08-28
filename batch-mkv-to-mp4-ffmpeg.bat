@echo off
setlocal enabledelayedexpansion

:: Ask user which codec to use
echo Choose a codec for conversion:
echo 1 - H.264 (libx264)
echo 2 - H.265 (libx265)
echo 3 - VP9 (libvpx-vp9)
echo 4 - AV1 (libaom-av1)
set /p codec_choice=Enter option number (1-4): 

:: Set codec variables based on choice
if "%codec_choice%"=="1" (
    set "vcodec=libx264"
    set "crf=23"
    set "preset=fast"
    set "acodec=aac"
) 
if "%codec_choice%"=="2" (
    set "vcodec=libx265"
    set "crf=28"
    set "preset=fast"
    set "acodec=aac"
) 
if "%codec_choice%"=="3" (
    set "vcodec=libvpx-vp9"
    set "crf=30"
    set "preset="
    set "acodec=libopus"
) 
if "%codec_choice%"=="4" (
    set "vcodec=libaom-av1"
    set "crf=30"
    set "preset="
    set "acodec=aac"
)

echo.
echo Using codec: %vcodec%
echo.

:: Loop through all MKV files in folder
for %%a in ("*.mkv") do (
    set "out=%%~na.mp4"
    set "count=1"

    :checkfile
    if exist "!out!" (
        set "out=%%~na(!count!).mp4"
        set /a count+=1
        goto checkfile
    )

    echo Converting "%%a" to "!out!" with subtitles...

    :: Use subtitle burn-in and codec options
    if "%vcodec%"=="libx264" (
        ffmpeg -i "%%a" -vf subtitles="%%a" -c:v !vcodec! -crf !crf! -preset !preset! -c:a !acodec! -b:a 192k "!out!"
    ) else if "%vcodec%"=="libx265" (
        ffmpeg -i "%%a" -vf subtitles="%%a" -c:v !vcodec! -crf !crf! -preset !preset! -c:a !acodec! -b:a 192k "!out!"
    ) else if "%vcodec%"=="libvpx-vp9" (
        ffmpeg -i "%%a" -vf subtitles="%%a" -c:v !vcodec! -b:v 0 -crf !crf! -c:a !acodec! "!out!"
    ) else if "%vcodec%"=="libaom-av1" (
        ffmpeg -i "%%a" -vf subtitles="%%a" -c:v !vcodec! -b:v 0 -crf !crf! -c:a !acodec! "!out!"
    )
)

echo.
echo All conversions complete!
pause
