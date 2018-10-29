$conf = Get-Content '.env' | Select -Skip 1 | ConvertFrom-StringData

$scriptpath = $MyInvocation.MyCommand.Path
$dir = Split-Path $scriptpath
cd $dir

Write-Host "Stop containers..."
docker-compose down  | Out-Null
docker stop aceproxy | Out-Null
Write-Host "Remove Images..."


docker rmi cleantoolbox/ubuntu-curl-html2text | Out-Null
docker rmi ikatson/aceproxy | Out-Null
Write-Host "Clean playlist..."
Remove-Item "$dir\playlist\*.m3u" | Where { ! $_.PSIsContainer } | Out-Null
Remove-Item "$dir\playlist\*.txt" | Where { ! $_.PSIsContainer } | Out-Null
Write-Host "Clean Icons..."
if ((Test-Path "$Home\Desktop\$($conf.SHORTCUTNAME).lnk")) {
    Remove-Item -Path "$Home\Desktop\$($conf.SHORTCUTNAME).lnk" -Force -ErrorAction Ignore | Out-Null
}