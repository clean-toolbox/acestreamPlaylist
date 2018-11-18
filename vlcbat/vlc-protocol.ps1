param (
    [string]$url
 )
 $scriptpath = $MyInvocation.MyCommand.Path
 $dir = Split-Path $scriptpath
 cd $dir
 

$conf = Get-Content '../.env' | Select -Skip 1 | ConvertFrom-StringData
$url=$url.Substring(6)
echo "$($conf.VLC_PATH)/vlc.exe"

start "$($conf.VLC_PATH)/vlc.exe"  "$url"
