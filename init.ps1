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

Register-EngineEvent -SourceIdentifier PowerShell.Exiting -SupportEvent -Action {
    try{
        docker stop aceproxy | Out-Null
    }catch{
       
    }
}

try{
    docker stop aceproxy | Out-Null
}catch{
   
}

$scriptpath = $MyInvocation.MyCommand.Path
$dir = Split-Path $scriptpath
cd $dir

$conf = Get-Content '.env' | Select -Skip 1 | ConvertFrom-StringData

docker-compose up
docker-compose down

start $conf.ACESTREAM_OR_VLC_PATH "./playlist/events.m3u --no-qt-error-dialogs"


if($conf.PROXY -eq "1") {   

    try{
        echo "If you stop or close this window transmition stops and nothing will be saved!"
        docker run --rm -it --name aceproxy -p  "$($conf.PORTPROXY):8000" -v "${PWD}/code/supervisord.conf:/etc/supervisor/conf.d/supervisord.conf" ikatson/aceproxy | Out-Null
        echo "Se ha cerrado todo"
    }catch{
        Write-Host "Aceproxy is already running" -ForegroundColor red
    }
    
}

return



