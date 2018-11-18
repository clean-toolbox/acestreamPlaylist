$scriptpath = $MyInvocation.MyCommand.Path
$dir = Split-Path $scriptpath
cd $dir

$conf = Get-Content '../.env' | Select -Skip 1 | ConvertFrom-StringData

if (!(Test-Path "$($conf.VLC_PATH)/vlc.exe") ) {
  echo "Warning: Can't find vlc.exe."
  exit
}



echo "If you see ""ERROR: Access is denied."" then you need to right click and use ""Run as Administrator""."
echo "Associating vlc:// with vlc-protocol.bat..."

echo "$($env:windir)"

New-PSDrive -Name HKCR -PSProvider Registry -Root HKEY_CLASSES_ROOT

New-ItemProperty -Path "HKCR:\vlc" -Name '(Default)' -Value "URL:vlc Protocol" -PropertyType String -Force | Out-Null
New-ItemProperty -Path "HKCR:\vlc" -Name 'URL Protocol' -Value "" -PropertyType String -Force | Out-Null
New-ItemProperty -Path "HKCR:\vlc\DefaultIcon" -Name '(Default)' -Value "$($conf.VLC_PATH)/vlc.exe,0" -PropertyType String -Force | Out-Null
New-ItemProperty -Path "HKCR:\vlc\shell\open\command" -Name '(Default)' -Value "`"$($env:windir)\System32\WindowsPowerShell\v1.0\powershell.exe`" -NoLogo -NoProfile -File $dir\vlc-protocol.ps1 %1" -PropertyType String -Force | Out-Null