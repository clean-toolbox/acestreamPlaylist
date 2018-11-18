
echo "If you see ""ERROR: Access is denied."" then you need to right click and use ""Run as Administrator""."

echo "Removing vlc:// association..."

reg delete HKCR\vlc /f

