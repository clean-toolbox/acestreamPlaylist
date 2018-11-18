# acestream Playlist

This repository is for generate acestream playlist and watch it via browser with vlc protocol asociation or you can play the playlists in playlist folder with vlc playwe if you have aceproxy actived or with acestream playr.  The main goal of this project is that you can use as portable, when you finish your event you can close it and remove everything.  For now there are only windows scripts to start and stop, further it will be also in linux.


## Requirements
This project have some requirements to work 

* docker
* docker-compose
* vlc or acestream (player + engine)


## Install
Install this project you can use it with **git** 
```
git clone https://github.com/clean-toolbox/acestreamPlaylist.git
```
or **download** from url   https://github.com/clean-toolbox/acestreamPlaylist/archive/master.zip
 

## Configuration
There are a file **.env** where you can configure several parameters:
```
DOMAIN=http://arenavision.us
MASK=DATE@TIME@TIMEZONE@SPORT@COMPETITION@EVENT@LANG
IGNOREPASTEVENTS=1
PASTEVENTSTHRESOLDHOURS=0
FOLDERSHARED=/playlist
PROXY=1
PORTPROXY=8000
WEBPORT=8181
VLC_PATH=C:/Program Files/VideoLAN/VLC
SHORTCUTNAME=watchSports
```
* DOMAIN - The domain where you can make scrape and extract the playlist channels and events.
* MASK - Is the mask that you can use to generate event name in playlist to reproduce, separated by @ symbol.
* IGNOREPASTEVENTS - if you want ignore past events you should put 1.
* PASTEVENTSTHRESOLDHOURS - Put the number of hours to consider a event that already happen. for example: one example that started one hour ago, maybe you want see it because its not   finished
* FOLDERSHARED - Name of the folder use it by scrape container.
* PROXY - If set to 1, it will use a container with acestream server proxy. This option is better if you dont want to have the acestream engine in you host. if you put to 0 you must have acestream player  and engine in your host machine.
* PORTPROXY - Port where acestreamproxy server it will be exposed, if you set PROXY to 0 this option it will be ignored
* VLC_PATH - path to the VLC for vlc asotiation protocol and to open playlist events with it
* SHORTCUTNAME - Name of shortcut if you generate it with script.

## Powershell warning
If you download this script and try running it with powershell, maybe you will receive some advertise. This is because the restriction on powershell to execute unsigned downloaded scripts. 

Open powershell with administrator rights

```
PS C:\> Set-ExecutionPolicy Bypass
```
References:

https://social.technet.microsoft.com/wiki/contents/articles/38496.unblock-downloaded-powershell-scripts.aspx

https://blog.netspi.com/15-ways-to-bypass-the-powershell-execution-policy/


## Shortcut

There are a script inside main folder where you can create a shortcut to execute everything, the shortcut will be created in Desktop folder. You can create or remove shortcut whenever you want.

## Clean or remove everything

There are a script to remove all containers, images and shortcut. 

# How works

![acestreamplaylisthowworks](https://user-images.githubusercontent.com/44523414/47682660-68554f00-dbcd-11e8-96d4-d344393993b9.gif)

# TODO

There are several things to do:
## Scraper
* Exclude past events 
* Include your time zone
* Filter Events by club, competition
* ..
## VLC
	* Include  something to always on top
	
# My environment
This small project was build under a environment, i think that it will work with another, but just in case i put my environment.

## Docker
```
Client:
 Version:           18.06.1-ce
 API version:       1.38
 Go version:        go1.10.3
 Git commit:        e68fc7a
 Built:             Tue Aug 21 17:21:34 2018
 OS/Arch:           windows/amd64
 Experimental:      false

Server:
 Engine:
  Version:          18.06.1-ce
  API version:      1.38 (minimum version 1.12)
  Go version:       go1.10.3
  Git commit:       e68fc7a
  Built:            Tue Aug 21 17:29:02 2018
  OS/Arch:          linux/amd64
  Experimental:     false
```	
## docker-compose
```
docker-compose version 1.22.0, build f46880fe
```
## Windows OS (host)
```
             Microsoft Windows 10 Pro
             10.0.17134 N/D Compilación 17134
             Microsoft Corporation
```
# References

This project was based in or use solutions from:

https://hub.docker.com/r/ikatson/aceproxy/

https://github.com/toptnc/getarenavision



