<?php

$result = '';
$lines = file('/var/www/html/openWB/openwb.conf');
foreach($lines as $line) {
    if(strpos($line, "minimalstromstaerke=") !== false) {
        list(, $minimalstromstaerkeold) = explode("=", $line);
    }
    if(strpos($line, "maximalstromstaerke=") !== false) {
        list(, $maximalstromstaerkeold) = explode("=", $line);
    }
    if(strpos($line, "sofortll=") !== false) {
        list(, $sofortllold) = explode("=", $line);
    }
    if(strpos($line, "sofortlls1=") !== false) {
        list(, $sofortlls1old) = explode("=", $line);
    }
    if(strpos($line, "sofortlls2=") !== false) {
        list(, $sofortlls2old) = explode("=", $line);
    }
    if(strpos($line, "lastmanagement=") !== false) {
        list(, $lastmanagementold) = explode("=", $line);
    }
    if(strpos($line, "lastmanagements2=") !== false) {
        list(, $lastmanagements2old) = explode("=", $line);
    }
    if(strpos($line, "lademstat=") !== false) {
        list(, $lademstatold) = explode("=", $line);
    }
    if(strpos($line, "lademstats1=") !== false) {
        list(, $lademstats1old) = explode("=", $line);
    }
    if(strpos($line, "lademkwh=") !== false) {
        list(, $lademkwhold) = explode("=", $line);
    }
    if(strpos($line, "lademkwhs1=") !== false) {
        list(, $lademkwhs1old) = explode("=", $line);
    }
    if(strpos($line, "lademstats2=") !== false) {
        list(, $lademstats2old) = explode("=", $line);
    }
    if(strpos($line, "lademkwhs2=") !== false) {
        list(, $lademkwhs2old) = explode("=", $line);
    }
    if(strpos($line, "sofortsoclp1=") !== false) {
        list(, $sofortsoclp1old) = explode("=", $line);
    }
    if(strpos($line, "sofortsoclp2=") !== false) {
        list(, $sofortsoclp2old) = explode("=", $line);
    }
    if(strpos($line, "sofortsoclp3=") !== false) {
        list(, $sofortsoclp3old) = explode("=", $line);
    }
    if(strpos($line, "sofortsocstatlp1=") !== false) {
        list(, $sofortsocstatlp1old) = explode("=", $line);
    }
    if(strpos($line, "sofortsocstatlp2=") !== false) {
        list(, $sofortsocstatlp2old) = explode("=", $line);
    }
    if(strpos($line, "sofortsocstatlp3=") !== false) {
        list(, $sofortsocstatlp3old) = explode("=", $line);
    }
    if(strpos($line, "msmoduslp1=") !== false) {
        list(, $msmoduslp1old) = explode("=", $line);
    }
    if(strpos($line, "msmoduslp2=") !== false) {
        list(, $msmoduslp2old) = explode("=", $line);
    }
    if(strpos($line, "speichermodul=") !== false) {
        list(, $speicherstatold) = explode("=", $line);
    }
    if(strpos($line, "lp1name=") !== false) {
        list(, $lp1nameold) = explode("=", $line);
    }
    if(strpos($line, "lp2name=") !== false) {
        list(, $lp2nameold) = explode("=", $line);
    }
    if(strpos($line, "lp3name=") !== false) {
        list(, $lp3nameold) = explode("=", $line);
    }
    if(strpos($line, "zielladenaktivlp1=") !== false) {
        list(, $zielladenaktivlp1old) = explode("=", $line);
    }
    if(strpos($line, "nachtladen=") !== false) {
        list(, $nachtladenstate) = explode("=", $line);
    }
    if(strpos($line, "nachtladens1=") !== false) {
        list(, $nachtladenstates1) = explode("=", $line);
    }
    if(strpos($line, "nlakt_sofort=") !== false) {
        list(, $nlakt_sofortold) = explode("=", $line, 2);
    }
    if(strpos($line, "nlakt_nurpv=") !== false) {
        list(, $nlakt_nurpvold) = explode("=", $line, 2);
    }
    if(strpos($line, "nlakt_minpv=") !== false) {
        list(, $nlakt_minpvold) = explode("=", $line, 2);
    }
    if(strpos($line, "nlakt_standby=") !== false) {
        list(, $nlakt_standbyold) = explode("=", $line, 2);
    }
    if(strpos($line, "evuglaettungakt=") !== false) {
        list(, $evuglaettungaktold) = explode("=", $line, 2);
    }
    if(strpos($line, "graphliveam=") !== false) {
        list(, $graphliveamold) = explode("=", $line, 2);
    }
    if(strpos($line, "speicherpvui=") !== false) {
        list(, $speicherpvuiold) = explode("=", $line, 2);
    }
    if(strpos($line, "speicherpveinbeziehen=") !== false) {
        list(, $speicherpveinbeziehenold) = explode("=", $line, 2);
    }
    if(strpos($line, "chartlegendmain=") !== false) {
        list(, $chartlegendmainold) = explode("=", $line, 2);
    }
    if(strpos($line, "hausverbrauchstat=") !== false) {
        list(, $hausverbrauchstatold) = explode("=", $line, 2);
    }
    if(strpos($line, "theme=") !== false) {
        list(, $themeold) = explode("=", $line, 2);
    }
    if(strpos($line, "heutegeladen=") !== false) {
	    list(, $heutegeladenold) = explode("=", $line, 2);
    }
    if(strpos($line, "displayconfigured=") !== false) {
	    list(, $displayconfiguredold) = explode("=", $line, 2);
    }
	if(strpos($line, "displaypinaktiv=") !== false) {
		list(, $displaypinaktivold) = explode("=", $line);
	}
	if(strpos($line, "displaytagesgraph=") !== false) {
		list(, $displaytagesgraphold) = explode("=", $line);
	}
	if(strpos($line, "displaypincode=") !== false) {
		list(, $displaypincodeold) = explode("=", $line);
	}
	if(strpos($line, "settingspw=") !== false) {
		list(, $settingspwold) = explode("=", $line);
	}
}
$displaypincodeold = str_replace("\n", '', $displaypincodeold);
$themeold = preg_replace('~[\r\n]+~', '', $themeold);
$lastregelungaktiv = file_get_contents('/var/www/html/openWB/ramdisk/lastregelungaktiv');
$lademodusold = file_get_contents('/var/www/html/openWB/ramdisk/lademodus');
$lp1nameold = str_replace( "'", "", $lp1nameold);
$lp2nameold = str_replace( "'", "", $lp2nameold);
$lp3nameold = str_replace( "'", "", $lp3nameold);
$speichervorhanden = file_get_contents('/var/www/html/openWB/ramdisk/speichervorhanden');
$soc1vorhanden = file_get_contents('/var/www/html/openWB/ramdisk/soc1vorhanden');
$verbraucher1vorhanden = file_get_contents('/var/www/html/openWB/ramdisk/verbraucher1vorhanden');
$verbraucher2vorhanden = file_get_contents('/var/www/html/openWB/ramdisk/verbraucher2vorhanden');
$settingspwold = str_replace("\n", '', $settingspwold);

$owbversion = file_get_contents('/var/www/html/openWB/web/version');
if (isset($_GET[theme])) {
    $theme = $_GET[theme];
    $_SESSION = $theme;

}
else
{
    $theme = $themeold;
    $_SESSION = $theme;

}
?>
