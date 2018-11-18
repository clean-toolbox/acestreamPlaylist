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

$conf = Get-Content '.env' | Select -Skip 1 | ConvertFrom-StringData

$scriptpath = $MyInvocation.MyCommand.Path
$dir = Split-Path $scriptpath
cd $dir

Write-Host "Stop containers..."
docker-compose down  | Out-Null

docker rmi cleantoolbox/ubuntu-curl-html2text | Out-Null
docker rmi ikatson/aceproxy | Out-Null
docker rmi webacestream | Out-Null

Write-Host "Clean playlist..."
Remove-Item "$dir\playlist\*.m3u" | Where { ! $_.PSIsContainer } | Out-Null
Remove-Item "$dir\playlist\*.txt" | Where { ! $_.PSIsContainer } | Out-Null

Write-Host "Clean Icons..."
if ((Test-Path "$Home\Desktop\$($conf.SHORTCUTNAME).lnk")) {
    Remove-Item -Path "$Home\Desktop\$($conf.SHORTCUTNAME).lnk" -Force -ErrorAction Ignore | Out-Null
}