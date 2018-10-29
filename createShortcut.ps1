$conf = Get-Content '.env' | Select -Skip 1 | ConvertFrom-StringData
$scriptpath = $MyInvocation.MyCommand.Path
$dir = Split-Path $scriptpath
cd $dir
echo $conf.SHORTCUTNAME;
$WshShell = New-Object -comObject WScript.Shell
$Shortcut = $WshShell.CreateShortcut("$Home\Desktop\"+$conf.SHORTCUTNAME+".lnk")
$Shortcut.TargetPath="%windir%\System32\WindowsPowerShell\v1.0\powershell.exe"
$Shortcut.Arguments = '-NoLogo -NoProfile -NoExit -File '+ '"'+$dir+'\init.ps1'+'"'
$Shortcut.IconLocation="$dir\icon128.ico"
$Shortcut.WorkingDirectory="$dir"
$Shortcut.Save()