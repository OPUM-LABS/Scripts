# Sunshine-Scripts

This script can be used under Sunshine to define the resolution and the display conditions when starting an application.

Command to add in Sunshine:

## Resolution:
powershell -command ". C:\_Scripts\sunshine-scripts.ps1; ScreenResolution -width 1920 -height 1080"

## Behaviour:
powershell -command ". C:\_Scripts\sunshine-scripts.ps1; WindowState -ProcessName "steam" -State Maximize"
