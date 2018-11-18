<##
 # Copyright (C) 2018 clean-toolbox
 # 
 # This file is part of acestreamPlaylist.
 # 
 # acestreamPlaylist is free software: you can redistribute it and/or modify
 # it under the terms of the GNU General Public License as published by
 # the Free Software Foundation, either version 3 of the License, or
 # (at your option) any later version.
 # 
 # acestreamPlaylist is distributed in the hope that it will be useful,
 # but WITHOUT ANY WARRANTY; without even the implied warranty of
 # MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 # GNU General Public License for more details.
 # 
 # You should have received a copy of the GNU General Public License
 # along with acestreamPlaylist.  If not, see <http://www.gnu.org/licenses/>.
 # 
#>

$env:HostIP = ( `
    Get-NetIPConfiguration | `
    Where-Object { `
        $_.IPv4DefaultGateway -ne $null `
        -and `
        $_.NetAdapter.Status -ne "Disconnected" `
    } `
).IPv4Address.IPAddress


$scriptpath = $MyInvocation.MyCommand.Path
$dirinit = Split-Path $scriptpath
cd $dirinit

$conf = Get-Content '.env' | Select -Skip 1 | ConvertFrom-StringData



Write-Host "Cleaning playlist content..."

Remove-Item .\playlist\*.m3u
Remove-Item .\playlist\*.txt

Write-Host "Init containers scraper, aceproxy and webacestream..."

docker-compose up -d
$check=""
Write-Host "Waiting for scraper "
while ($check.Length -eq 0) {	
    Write-Host -NoNewline "."
    if($(docker ps -aq -f status=exited -f name=scraper)){
        $check="checked"
    }
    Start-Sleep 1 
}
Write-Host "Scraper is already " -ForegroundColor green

if($conf.PROXY -eq "1"){

    Write-Host -NoNewline "Waiting for aceproxy "
    $parse=""
    while ($parse.Length -eq 0) {	
        Write-Host -NoNewline "."
        $parse=$(docker logs aceproxy | select-string -Pattern "INFO success: acehttp" ) 
        Start-Sleep 1 
    }
    Write-Host ""
    Write-Host "Aceproxy container already loaded " -ForegroundColor green
    Write-Host "*************************************************" -ForegroundColor green
    Write-Host "*                                               *" -ForegroundColor green
    Write-Host "*         http://$($env:HostIP):$($conf.WEBPORT)/         *" -ForegroundColor green
    Write-Host "*                                               *" -ForegroundColor green
    Write-Host "*************************************************" -ForegroundColor green
    start  "http://$($env:HostIP):$($conf.WEBPORT)/"

    Write-Host "* You should install protocol register from vlcbat folder, if you will access from another computer in same network we should install it there also "
    Write-Host "* You can create a shortcut if you want, there a script to do it createShortcut.ps1 "
    Write-Host "* If you want remove everything you have a script removeAll.ps1"
    Write-Host "* In mobile Android you should also have vlc installed " 
    Write-Host "* With your vlc you can send event to your CHROMECAST device, if you are in the same network " 
    Write-Host "* If anything goes wrong chek your firewall, antivirus, and that all devices are in the same network "

 
}else{
    docker stop aceproxy webacestream
    docker rm aceproxy webacestream
    
    Write-Host "We will open your vlc instance with event playlist " -ForegroundColor green
    start $conf.VLC_PATH "./playlist/events.m3u --no-qt-error-dialogs"

}

 
Write-Host "Check the playlist folder and use it with vlc if you have proxy actived or you acetreamplayer if you already have installed in your computer " -ForegroundColor green




