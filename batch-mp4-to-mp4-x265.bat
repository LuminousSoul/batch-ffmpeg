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
	
	
	REM extract Thumbnail from video to thumbnail.png
	ffmpeg -i "%%~nf.mp4" -map 0:v -map -0:V -c copy thumbnail.png
	
	


	:: Other Commands to add if needed
	:: Scaling down: -vf "scale='min(1920,iw)':'min(1080,ih)'"
	:: Encoding Speeds: ultrafast, superfast, veryfast, faster, fast, medium, slow, slower, veryslow, placebo
    ffmpeg -i "%%f" -c:v libx265 -preset slow -crf 28 -c:a aac -b:a 192k -c:s copy "%%~nf [x265] [No Thumbnail].mp4"
		

	REM if unable to or there is nothing to extract, create a thumbnail at specific spot
	if not exist "thumbnail.png" (
		ffmpeg -ss 00:00:30 -i "%%~nf [x265] [No Thumbnail].mp4" -frames:v 1 -q:v 2 "thumbnail.png"
	)

	REM Add thumbnail to file
	ffmpeg -i "%%~nf [x265] [No Thumbnail].mp4" -i thumbnail.png -map 1 -map 0 -c copy -disposition:0 attached_pic "%%~nf [x265].mp4"
	::del "%%~nf [x265] [No Thumbnail].mp4"
	del thumbnail.png
)

echo Conversion complete!
pause



