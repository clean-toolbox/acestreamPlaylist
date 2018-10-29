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



