@echo off
::Original Command: ffmpeg -err_detect ignore_err -i broken.mp4 -c copy fixed.mp4

ffmpeg -err_detect ignore_err -i "%~1" -c copy "%~2"