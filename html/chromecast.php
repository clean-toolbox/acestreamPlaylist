<?php
ini_set('xdebug.var_display_max_depth', '10');
ini_set('xdebug.var_display_max_children', '256');
ini_set('xdebug.var_display_max_data', '1024');
//get default gatwway
exec("route -n | awk '{print $2}' | grep  -v '0.0.0.0' | grep -Eo '[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}'",$gw);

$gw="192.168.1.1";


//nmap scan to get all devices with open port 8008 whis is what chromecast listens on
exec("sudo  nmap ".$gw."/24 -p 8008 -oG - | grep 8008/open | awk '{print $2}'",$chromecasts);
$out=array();


var_dump($chromecasts);
//loop through and get the setup info page data
 foreach($chromecasts as $chromecast) {
                     $url='http://'.trim($chromecast).':8008/setup/eureka_info';
                     $curl_handle=curl_init();
                     curl_setopt($curl_handle, CURLOPT_URL,$url);
                     curl_setopt($curl_handle, CURLOPT_CONNECTTIMEOUT, 2);
                     curl_setopt($curl_handle, CURLOPT_RETURNTRANSFER, 1);
                     curl_setopt($curl_handle, CURLOPT_USERAGENT, 'Your application name');
                     $query = curl_exec($curl_handle);
                     curl_close($curl_handle);
                     $data = json_decode($query,true);
                     $out[$chromecast]['data']=$data;
}
var_dump($out);
?>