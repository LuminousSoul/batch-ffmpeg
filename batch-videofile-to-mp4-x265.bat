@echo off
set /p filetype=Enter the file extension to convert (e.g. mkv, mp4, avi): 

echo Converting all *.%filetype% files to MP4 (x265)...


setlocal enabledelayedexpansion

REM Count total Video files first
set count=0
for %%f in (*.%filetype%) do (
    set /a count+=1
)

if !count! equ 0 (
    echo No Video Files found in this folder.
    pause
    exit /b
)

REM Initialize file index
set index=0

REM Loop through all Video files
for %%f in (*.%filetype%) do (
    set /a index+=1
    echo Processing file !index! of !count!: "%%f"
	
	
    REM Extracting Thumbnail from video to thumbnail.png
    ffmpeg -i "%%~nf.%filetype%" -map 0:v -map -0:V -c copy thumbnail.png
	

    :: Other Commands to add if needed
    :: Scaling down: -vf "scale='min(1920,iw)':'min(1080,ih)'"
    :: Encoding Speeds: ultrafast, superfast, veryfast, faster, fast, medium, slow, slower, veryslow, placebo
    ffmpeg -i "%%f" -c:v libx265 -preset slow -crf 28 -c:a aac -b:a 192k -c:s copy "%%~nf [x265] [No Thumbnail].mp4"
    
    
    ::If successful, attempt to 
    IF !ERRORLEVEL! EQU 0 (
        REM if unable to or there is nothing to extract, create a thumbnail at specific spot
        if not exist "thumbnail.png" (
            ffmpeg -ss 00:00:30 -i "%%~nf [x265] [No Thumbnail].mp4" -frames:v 1 -q:v 2 "thumbnail.png"
        )


        REM Add thumbnail to file
        ffmpeg -i "%%~nf [x265] [No Thumbnail].mp4" -i thumbnail.png -map 1 -map 0 -c copy -disposition:0 attached_pic "%%~nf [x265].mp4"
        IF !ERRORLEVEL! EQU 0 (
            echo "SUCCESS: Converted %%~nxf"
            REM Optional: Delete the original file after successful conversion
            REM del "%input_file%"
            del "%%~nf [x265] [No Thumbnail].mp4"
        ) ELSE (
            echo "FAILURE: Conversion failed for %%~nxf [No Thumbnail] (2)"
            del "%%~nf [x265].mp4"
            echo "Renaming: "%%~nf [x265] [No Thumbnail].mp4"   to   "%%~nf [x265].mp4"
            ren "%%~nf [x265] [No Thumbnail].mp4" "%%~nf [x265].mp4"
        )

    ) ELSE (
        echo "FAILURE: Conversion failed for %%~nxf (1)"
    )




    
    
    
    del thumbnail.png
)

echo Conversion complete!
pause



