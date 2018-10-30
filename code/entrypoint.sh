#!/bin/bash


#  Copyright (C) 2018 toptnc
#  Copyright (C) 2018 clean-toolbox 

#  This file is part of acestreamPlaylist. 

#  acestreamPlaylist is free software: you can redistribute it and/or modify
#  it under the terms of the GNU General Public License as published by
#  the Free Software Foundation, either version 3 of the License, or
#  (at your option) any later version.
 
#  acestreamPlaylist is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#  GNU General Public License for more details.
 
#  You should have received a copy of the GNU General Public License
#  along with acestreamPlaylist.  If not, see <http://www.gnu.org/licenses/>.



# apt-get -qq update -y > /dev/null
# apt-get -qq install curl html2text -y > /dev/null

m3ufileevents="${FOLDERSHARED}/events.m3u"
m3ufilechannels="${FOLDERSHARED}/channels.m3u"

fronturl=${DOMAIN}

#mask="DATE@TIME@TIMEZONE@SPORT@COMPETITION@EVENT@LANG"

mask=${MASK}
guidetemp='/tmp/playlist.tmp'
guidefile="${FOLDERSHARED}/guide.txt"
guidepath=$(curl -s --cookie "beget=begetok" $fronturl | grep -o '\<a href.*\>' | sed 's/\<a\ href/\n\<a\ href/g' | grep EVENTS | cut -d '"' -f 2)
echo $guidepath | grep -q http && guideurl=$guidepath || guideurl="$fronturl/$guidepath"

curl -s --cookie "beget=begetok"  $guideurl | html2text -width 100 > $guidetemp

declare -A EVENTS
declare -A CHANNELSIDS
declare -A DATA

LNSTART=$(grep -n "EVENTS GUIDE" $guidetemp | cut -d ":" -f 1)
LNEND=$(grep -n "Last update" $guidetemp | cut -d ":" -f 1)
LNSTART=$((LNSTART + 2))
LNEND=$((LNEND - 1))

awk -v start="$LNSTART" -v end="$LNEND" 'NR >= start && NR <= end' $guidetemp > $guidefile

echo > $m3ufilechannels

links=$(curl -s --cookie "beget=begetok" $fronturl | grep -o '\<a href.*\>' | sed 's/\<a\ href/\n\<a\ href/g' | grep ArenaVision)

    IFS='
'
for line in $links;
do

	arenaurl=$(echo "$line" | cut -d '"' -f 2)
	arenatitle=$(echo "$line" | cut -d '>' -f 2 | cut -d '<' -f 1)
	arenalink=$(curl -s --cookie "beget=begetok" $arenaurl | grep acestream:// | sed 's/\ /\n/g'| grep acestream | cut -d "=" -f 2 | sed 's/\"//g')
	
	channel=${arenatitle:12:2}

    id=${arenalink:12:40}
	CHANNELSIDS[$channel]="$id"

	echo \#EXTINF:-1,"$arenatitle" >> $m3ufilechannels
	echo $arenalink >> $m3ufilechannels
done

echo > $m3ufileevents

while IFS='' read -r line || [[ -n "$line" ]]; do
	
	
	fecha=${line:0:10}
	fecha="${fecha// /}"

	if [ ${#fecha} -ge 10 ];then		
		line="$(echo -e "$line" | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')"	
		DATA[DATE]=${line:0:10}
		DATA[TIME]=${line:11:5}
		DATA[TIMEZONE]=${line:17:4}
		DATA[SPORT]=${line:22:10}
		DATA[COMPETITION]=${line:33:18}
		DATA[EVENT]=${line:53:35}

		for K in "${!DATA[@]}"; do
			DATA[$K]="$(echo -e "${DATA[$K]}" | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')"			
		done

	fi

	

	channellang="$(echo "$line" | grep -o '[^[:space:]]\+\([[:space:]]\+[^[:space:]]\+\)\{1\} *$')"

	IFS=' ' read -r -a splited <<< "$channellang"
	IFS='-' read -r -a channels <<<  "${splited[0]}"

	DATA[LANG]=${splited[1]}

	LABEL=""
	IFS=' '
	for INDEX in $(echo $mask | sed "s/@/ /g")
	do		
		if [ "${DATA[$INDEX]}" != "" ]; then
			LABEL+="${DATA[$INDEX]}@"
		fi		
	done
	if [[ -n "${channels[0]}" ]]; then
		channel=${channels[0]}
		echo \#EXTINF:-1,"$LABEL@$channel" >> $m3ufileevents


		link="acestream://${CHANNELSIDS[$channel]}"

		if [ -n ${PROXY} ] 
		then
			if [ "${PROXY}" = "1" ]
			then
				link="http://127.0.0.1:${PORTPROXY:- 8000}/pid/${CHANNELSIDS[$channel]}/stream.mp4"		
			fi
		fi
		echo $link >> $m3ufileevents
		
		if [[ -n "${channels[1]}" ]]; then
			channel=${channels[1]}
			echo \#EXTINF:-1,"$LABEL@$channel" >> $m3ufileevents

			link="acestream://${CHANNELSIDS[$channel]}"

			if [ -n ${PROXY} ] 
			then
				if [ "${PROXY}" = "1" ]
				then
					link="http://127.0.0.1:${PORTPROXY:- 8000}/pid/${CHANNELSIDS[$channel]}/stream.mp4"		
				fi
			fi
			echo $link >> $m3ufileevents
			
		fi		
	fi
     
done < "$guidefile"
