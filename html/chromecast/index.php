<?php

// Demonstrates class to send pictures/videos to Chromecast
// using reverse engineered Castv2 protocol.
//
// Note: To work from internet you must open a route to port 8009 on
// your chromecast through your firewall. Preferably with port forwarding
// from a different port address.

require_once("Chromecast.php");

// Create Chromecast object and give IP and Port
$cc = new Chromecast("192.168.1.43","8009");
$cc->DMP->play("https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4","BUFFERED","video/mp4",true,0);
$cc->DMP->UnMute();
$cc->DMP->SetVolume(1);
sleep(5);
$cc->DMP->pause();
print_r($cc->DMP->getStatus());
sleep(5);
$cc->DMP->restart();
sleep(5);
$cc->DMP->seek(100);
sleep(5);
$cc->DMP->SetVolume(0.5);
sleep(15);
$cc->DMP->SetVolume(1); // Turn the volume back up
$cc->DMP->Mute();
sleep(20);
$cc->DMP->UnMute();
sleep(5);
$cc->DMP->Stop();

?>
