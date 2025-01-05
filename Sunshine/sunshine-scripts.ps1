<#
	.SYNOPSIS
	sunshine-script.ps1

	.DESCRIPTION
	This script can be used under Sunshine to define the resolution
	and the display conditions when starting an application.
	
	Needs ChangeScreenResolution to work!
	Powershell: Install-Module -Name ChangeScreenResolution

	.PARAMETER Name
	Specifies the file name.

	.PARAMETER Extension
	Specifies the extension. "Txt" is the default.

	.INPUTS
	None. You can't pipe objects to Add-Extension.

	.OUTPUTS
	System.String. Add-Extension returns a string with the extension or file name.

	.EXAMPLE
	Resolution: powershell -command ". C:\_Scripts\sunshine-scripts.ps1; ScreenResolution -width 1920 -height 1080"

	.EXAMPLE
	Behaviour: powershell -command ". C:\_Scripts\sunshine-scripts.ps1; WindowState -ProcessName "steam" -State Maximize"

	.LINK
	Online version: https://github.com/OPUM-LABS/Scripts/Sunshine
#>

Add-Type @"
    using System;
    using System.Runtime.InteropServices;
    public class Window {
        [DllImport("user32.dll")]
        [return: MarshalAs(UnmanagedType.Bool)]
        public static extern bool ShowWindow(IntPtr hWnd, int nCmdShow);
        
        [DllImport("user32.dll")]
        public static extern bool SetForegroundWindow(IntPtr hWnd);
        
        [DllImport("user32.dll")]
        public static extern IntPtr GetForegroundWindow();
    }
"@

function ScreenResolution {
	    param(
        [Parameter(Mandatory=$true)]
        [int]$width,
        [int]$height
    )
	Set-ScreenResolution $width $height
}

function WindowState {
    param(
        [Parameter(Mandatory=$true)]
        [string]$ProcessName,
        [ValidateSet('Maximize', 'Minimize', 'Restore')]
        [string]$State = 'Maximize'
    )
    
    $processes = Get-Process | Where-Object { $_.ProcessName -like "*$ProcessName*" -and $_.MainWindowHandle -ne 0 }
    
    if ($processes.Count -eq 0) {
        Write-Host "Kein Prozess mit dem Namen '$ProcessName' gefunden."
        return
    }
    
    foreach ($process in $processes) {
        $hwnd = $process.MainWindowHandle
        
        switch ($State) {
            'Maximize' { $nCmdShow = 3 }
            'Minimize' { $nCmdShow = 6 }
            'Restore'  { $nCmdShow = 9 }
        }
        
        [void][Window]::ShowWindow($hwnd, $nCmdShow)
        [void][Window]::SetForegroundWindow($hwnd)
    }
}