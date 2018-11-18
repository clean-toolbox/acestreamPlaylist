<?php
include "Browser.php";
/**
 * Copyright (C) 2018 clean-toolbox
 * 
 * This file is part of acestreamPlaylist.
 * 
 * acestreamPlaylist is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 * 
 * acestreamPlaylist is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 * 
 * You should have received a copy of the GNU General Public License
 * along with acestreamPlaylist.  If not, see <http://www.gnu.org/licenses/>.
 * 
 */
$browser = new Browser();
$PC=false;
$ANDROID=false;
if( $browser->getPlatform() == Browser::PLATFORM_WINDOWS  || $browser->getPlatform() == Browser::PLATFORM_LINUX ) {
    $PC=true;
}
if( $browser->getPlatform() == Browser::PLATFORM_ANDROID ) {
    $ANDROID=true;
}

$sports=["football","soccer","motogp","tennis","basketball","mma"];



$handle = fopen("/playlist/eventstohtml.txt", "r");
if (!$handle) {
    throw new Exception("CANT OPEN FILE");
    return;
}    

$events='';
while (($line = fgets($handle)) !== false) {
    if(strlen($line)<10)
        continue;

    $fields=explode("##",$line);
    $sport=strtolower($fields[3]);
    if(!in_array($sport,$sports))
        $sport="default";


    $speech=str_replace(["[","]"],["",""], strtolower($fields[6]));


    $linkvlc="";

    if($PC)
        $linkvlc="vlc://".$fields[9];

    
    if($ANDROID)
        $linkvlc="intent".str_replace("http","",$fields[9])."#Intent;scheme=http;package=org.videolan.vlc;end";


    $events.='
    <article class="thumb">
        <div class="image">
            <img src="images/competitions/'.$sport.'.jpg" alt="" />
        </div>
        <div class="speech">
                <img src="images/flags/'.$speech.'.png" alt="" width="32" />
        </div>
        <div class="channel">
                #'.$fields[8].'
        </div>
        <div class="competition">
                ['.$fields[3].'] 
        </div>
        <div class="watch">
            <a href="'.$linkvlc.'" target="_blank" style="margin-right: 30px;">
                <img src="images/watch/vlc.png"  width="64"/>
            </a>
        </div>
        <h2 style="font-size: 20px; font-weight: bold;">'.$fields[5].'</h2>
        <span class="date"><i>'.$fields[0].' '.$fields[1].'('.$fields[2].')</i></span>							
    </article>';
}

fclose($handle);


include_once "template.php";