# acestream Playlist

This repository is for generate acestream playlist and watch it on acestream player (with acestream engine) or VLC using a acestream proxy server.  The main goal of this project is that you can use as portable, when you finish your event you can close it and remove everything.  For now there are only windows scripts to start and stop, further it will be also in linux.


## Prerequisites
This project have some prerequisites to work 

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
FOLDERSHARED=/playlist
PROXY=1
PORTPROXY=8000
ACESTREAM_OR_VLC_PATH=C:/Program Files (x86)/VideoLAN/VLC/vlc.exe
SHORTCUTNAME=watchSports
```
* DOMAIN - The domain where you can make scrape and extract the playlist channels and events.
* MASK - Is the mask that you can use to generate event name in playlist to reproduce, separated by @ symbol.
* FOLDERSHARED - Name of the folder use it by scrape container.
* PROXY - If set to 1, it will use a container with acestream server proxy. This option is better if you dont want to have the acestream engine in you host. if you put to 0 you must have acestream player  and engine in your host machine.
* PORTPROXY - Port where acestreamproxy server it will be exposed, if you set PROXY to 0 this option it will be ignored
* ACESTREAM_OR_VLC_PATH - path to the VLC if you set PROXY to 1 or ACESTREAM path if you set PROXY to 0
* SHORTCUTNAME - Name of shortcut if you generate it with script.
 
## Shortcut

There are a script inside main folder where you can create a shortcut to execute everything, the shortcut will be created in Desktop folder. You can create or remove shortcut whenever you want.

## Clean or remove everything

There are a script to remove all containers, images and shortcut. 


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
