param(
    [Parameter(Mandatory)]
    [ValidateSet('Grave', 'Enter', 'ShiftF10', 'Escape')]
    [string]$Key,
    [string]$GameExecutable = 'D:\SteamLibrary\steamapps\common\Europa Universalis V\binaries\eu5.exe'
)

$ErrorActionPreference = 'Stop'
$expectedPath = [IO.Path]::GetFullPath($GameExecutable)
$gameProcesses = @(Get-Process eu5 -ErrorAction SilentlyContinue | Where-Object {
    $_.Path -eq $expectedPath -and $_.MainWindowHandle -ne 0
})
if ($gameProcesses.Count -ne 1) {
    throw 'Expected exactly one visible EU5 process at the configured installation path.'
}
$gameProcess = $gameProcesses[0]

Add-Type -TypeDefinition @'
using System;
using System.Runtime.InteropServices;
public static class Eu5ScanInput {
    [StructLayout(LayoutKind.Sequential)] public struct MOUSEINPUT {
        public int dx, dy;
        public uint mouseData, dwFlags, time;
        public UIntPtr dwExtraInfo;
    }
    [StructLayout(LayoutKind.Sequential)] public struct KEYBDINPUT {
        public ushort wVk, wScan;
        public uint dwFlags, time;
        public UIntPtr dwExtraInfo;
    }
    [StructLayout(LayoutKind.Explicit)] public struct UNION {
        [FieldOffset(0)] public MOUSEINPUT mi;
        [FieldOffset(0)] public KEYBDINPUT ki;
    }
    [StructLayout(LayoutKind.Sequential)] public struct INPUT {
        public uint type;
        public UNION data;
    }
    [DllImport("user32.dll", SetLastError=true)]
    public static extern uint SendInput(uint count, INPUT[] inputs, int size);
    [DllImport("user32.dll")] public static extern bool SetForegroundWindow(IntPtr window);
    [DllImport("user32.dll")] public static extern IntPtr GetForegroundWindow();
    public static void Send(ushort scan, bool release) {
        var input = new INPUT { type = 1 };
        input.data.ki.wScan = scan;
        input.data.ki.dwFlags = 8u | (release ? 2u : 0u);
        if (SendInput(1, new [] { input }, Marshal.SizeOf(typeof(INPUT))) != 1)
            throw new System.ComponentModel.Win32Exception(Marshal.GetLastWin32Error());
    }
}
'@

[void][Eu5ScanInput]::SetForegroundWindow($gameProcess.MainWindowHandle)
Start-Sleep -Milliseconds 250
if ([Eu5ScanInput]::GetForegroundWindow() -ne $gameProcess.MainWindowHandle) {
    throw 'EU5 is not foreground; no input sent.'
}
$scan = switch ($Key) {
    'Grave' { 0x29 }
    'Enter' { 0x1c }
    'ShiftF10' { 0x44 }
    'Escape' { 0x01 }
}
$shiftPressed = $false
$keyPressed = $false
try {
    if ($Key -eq 'ShiftF10') {
        [Eu5ScanInput]::Send(0x2a, $false)
        $shiftPressed = $true
    }
    [Eu5ScanInput]::Send($scan, $false)
    $keyPressed = $true
    Start-Sleep -Milliseconds 100
} finally {
    if ($keyPressed) { [Eu5ScanInput]::Send($scan, $true) }
    if ($shiftPressed) { [Eu5ScanInput]::Send(0x2a, $true) }
}
Write-Output "Sent $Key scan-code input to EU5 process $($gameProcess.Id). Verify the resulting UI separately."
