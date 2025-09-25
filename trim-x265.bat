@echo off
::Format: trim-x265 input.mp4 00:01:00 00:05:00 output.mp4

ffmpeg -ss %2 -to %3 -i "%~1" -c:v libx265 -preset slow -crf 28 -c:a aac -b:a 192k -c:s copy "%~4"
