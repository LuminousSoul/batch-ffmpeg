@echo off
::Format: trim-x265 input.mp4 00:01:00 00:05:00 output.mp4
ffmpeg -ss %2 -to %3 -i "%~1" -c copy  "%~4"