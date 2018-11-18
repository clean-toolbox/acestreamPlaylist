<?php
require_once("Chromecast.php");

// Create Chromecast object and give IP and Port
$cc = new Chromecast("192.168.1.43","8009");

var_dump($cc->DMP->getStatus());
