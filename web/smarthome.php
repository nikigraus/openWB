<!DOCTYPE html>
<html lang="en">

<head>
	<script src="js/jquery-1.11.1.min.js"></script>
	<meta charset="UTF-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<meta name="viewport" content="width=device-width, initial-scale=1">
	<title>OpenWB</title>
	<meta name="description" content="Control your charge" />
	<meta name="keywords" content="html template, css, free, one page, gym, fitness, web design" />
	<meta name="author" content="Kevin Wieland" />
	<!-- Favicons (created with http://realfavicongenerator.net/)-->
	<link rel="apple-touch-icon" sizes="57x57" href="img/favicons/apple-touch-icon-57x57.png">
	<link rel="apple-touch-icon" sizes="60x60" href="img/favicons/apple-touch-icon-60x60.png">
	<link rel="icon" type="image/png" href="img/favicons/favicon-32x32.png" sizes="32x32">
	<link rel="icon" type="image/png" href="img/favicons/favicon-16x16.png" sizes="16x16">
	<link rel="manifest" href="manifest.json">
	<link rel="shortcut icon" href="img/favicons/favicon.ico">
	<meta name="msapplication-TileColor" content="#00a8ff">
	<meta name="msapplication-config" content="img/favicons/browserconfig.xml">
	<meta name="theme-color" content="#ffffff">
	<!-- Normalize -->
	<link rel="stylesheet" type="text/css" href="css/normalize.css">
	<!-- Bootstrap -->
	<link rel="stylesheet" type="text/css" href="css/bootstrap.css">
	<!-- Owl -->
	<link rel="stylesheet" type="text/css" href="css/owl.css">
	<!-- Animate.css -->
	<link rel="stylesheet" type="text/css" href="css/animate.css">
	<!-- Font Awesome, all styles -->
  <link href="fonts/font-awesome-5.8.2/css/all.css" rel="stylesheet">
	<!-- Elegant Icons -->
	<link rel="stylesheet" type="text/css" href="fonts/eleganticons/et-icons.css">
	<!-- Main style -->
	<link rel="stylesheet" type="text/css" href="css/cardio.css">

</head>
<body>
<?php


$lines = file('/var/www/html/openWB/openwb.conf');
foreach($lines as $line) {
	if(strpos($line, "settingspw=") !== false) {
		list(, $settingspwold) = explode("=", $line, 2);
	}
	if(strpos($line, "settingspwakt=") !== false) {
		list(, $settingspwaktold) = explode("=", $line, 2);
	}

	if(strpos($line, "hook1_ausverz=") !== false) {
		list(, $hook1_ausverzold) = explode("=", $line, 2);
	}
	if(strpos($line, "hook1ein_url=") !== false) {
		list(, $hook1ein_urlold) = explode("=", $line, 2);
	}
	if(strpos($line, "angesteckthooklp1_url=") !== false) {
		list(, $angesteckthooklp1_urlold) = explode("=", $line, 2);
	}
	if(strpos($line, "hook1aus_url=") !== false) {
		list(, $hook1aus_urlold) = explode("=", $line, 2);
	}
	if(strpos($line, "hook1ein_watt=") !== false) {
		list(, $hook1ein_wattold) = explode("=", $line, 2);
	}
	if(strpos($line, "hook1aus_watt=") !== false) {
		list(, $hook1aus_wattold) = explode("=", $line, 2);
	}
	if(strpos($line, "hook1_aktiv=") !== false) {
		list(, $hook1_aktivold) = explode("=", $line, 2);
	}
	if(strpos($line, "angesteckthooklp1=") !== false) {
		list(, $angesteckthooklp1old) = explode("=", $line, 2);
	}

	if(strpos($line, "hook1_dauer=") !== false) {
		list(, $hook1_dauerold) = explode("=", $line, 2);
	}
	if(strpos($line, "hook2ein_url=") !== false) {
		list(, $hook2ein_urlold) = explode("=", $line, 2);
	}
	if(strpos($line, "hook2aus_url=") !== false) {
		list(, $hook2aus_urlold) = explode("=", $line, 2);
	}
	if(strpos($line, "hook2ein_watt=") !== false) {
		list(, $hook2ein_wattold) = explode("=", $line, 2);
	}
	if(strpos($line, "hook2aus_watt=") !== false) {
		list(, $hook2aus_wattold) = explode("=", $line, 2);
	}
	if(strpos($line, "hook2_aktiv=") !== false) {
		list(, $hook2_aktivold) = explode("=", $line, 2);
	}
	if(strpos($line, "hook2_dauer=") !== false) {
		list(, $hook2_dauerold) = explode("=", $line, 2);
	}
	if(strpos($line, "hook3ein_url=") !== false) {
		list(, $hook3ein_urlold) = explode("=", $line, 2);
	}
	if(strpos($line, "hook3aus_url=") !== false) {
		list(, $hook3aus_urlold) = explode("=", $line, 2);
	}
	if(strpos($line, "hook3ein_watt=") !== false) {
		list(, $hook3ein_wattold) = explode("=", $line, 2);
	}
	if(strpos($line, "hook3aus_watt=") !== false) {
		list(, $hook3aus_wattold) = explode("=", $line, 2);
	}
	if(strpos($line, "hook3_aktiv=") !== false) {
		list(, $hook3_aktivold) = explode("=", $line, 2);
	}
	if(strpos($line, "hook3_dauer=") !== false) {
		list(, $hook3_dauerold) = explode("=", $line, 2);
	}
	if(strpos($line, "verbraucher1_aktiv=") !== false) {
		list(, $verbraucher1_aktivold) = explode("=", $line, 2);
	}
	if(strpos($line, "verbraucher1_typ=") !== false) {
		list(, $verbraucher1_typold) = explode("=", $line, 2);
	}
	if(strpos($line, "verbraucher1_urlw=") !== false) {
		list(, $verbraucher1_urlwold) = explode("=", $line, 2);
	}
	if(strpos($line, "verbraucher1_urlh=") !== false) {
		list(, $verbraucher1_urlhold) = explode("=", $line, 2);
	}
	if(strpos($line, "verbraucher1_name=") !== false) {
		list(, $verbraucher1_nameold) = explode("=", $line, 2);
	}
	if(strpos($line, "verbraucher1_id=") !== false) {
		list(, $verbraucher1_idold) = explode("=", $line, 2);
	}
	if(strpos($line, "verbraucher1_ip=") !== false) {
		list(, $verbraucher1_ipold) = explode("=", $line, 2);
	}
	if(strpos($line, "verbraucher1_source=") !== false) {
		list(, $verbraucher1_sourceold) = explode("=", $line, 2);
	}
	if(strpos($line, "verbraucher2_aktiv=") !== false) {
		list(, $verbraucher2_aktivold) = explode("=", $line, 2);
	}
	if(strpos($line, "verbraucher2_typ=") !== false) {
		list(, $verbraucher2_typold) = explode("=", $line, 2);
	}
	if(strpos($line, "verbraucher2_urlw=") !== false) {
		list(, $verbraucher2_urlwold) = explode("=", $line, 2);
	}
	if(strpos($line, "verbraucher2_urlh=") !== false) {
		list(, $verbraucher2_urlhold) = explode("=", $line, 2);
	}
	if(strpos($line, "verbraucher2_name=") !== false) {
		list(, $verbraucher2_nameold) = explode("=", $line, 2);
	}
	if(strpos($line, "verbraucher2_id=") !== false) {
		list(, $verbraucher2_idold) = explode("=", $line, 2);
	}
	if(strpos($line, "verbraucher2_ip=") !== false) {
		list(, $verbraucher2_ipold) = explode("=", $line, 2);
	}
	if(strpos($line, "verbraucher2_source=") !== false) {
		list(, $verbraucher2_sourceold) = explode("=", $line, 2);
	}


}

$angesteckthooklp1_urlold = str_replace( "'", "", $angesteckthooklp1_urlold);

$hook1ein_urlold = str_replace( "'", "", $hook1ein_urlold);
$hook1aus_urlold = str_replace( "'", "", $hook1aus_urlold);
$hook2ein_urlold = str_replace( "'", "", $hook2ein_urlold);
$hook2aus_urlold = str_replace( "'", "", $hook2aus_urlold);
$hook3ein_urlold = str_replace( "'", "", $hook3ein_urlold);
$hook3aus_urlold = str_replace( "'", "", $hook3aus_urlold);
$verbraucher1_urlwold = str_replace( "'", "", $verbraucher1_urlwold);
$verbraucher1_urlhold = str_replace( "'", "", $verbraucher1_urlhold);
$verbraucher2_urlwold = str_replace( "'", "", $verbraucher2_urlwold);
$verbraucher2_urlhold = str_replace( "'", "", $verbraucher2_urlhold);






?>



<div class="container">
<div class="row"><br>
 <ul class="nav nav-tabs">

    <li><a data-toggle="tab" href="./index.php">Zurück</a></li>
    <li><a href="./settings.php">Einstellungen</a></li>
    <li><a href="./pvconfig.php">PV Ladeeinstellungen</a></li>
    <li class="active"><a href="./smarthome.php">Smart Home</a></li>
    <li><a href="./modulconfig.php">Modulkonfiguration</a></li>
	<li><a href="./setTheme.php">Theme</a></li>
	<li><a href="./misc.php">Misc</a></li>
  </ul><br><br>
 </div>
<form action="./tools/savesmarthome.php" method="POST">

<div class="col-xs-1">
</div>
<div class="col-xs-10">

<div class="row">
	<b><label for="angesteckthooklp1">Webhook bei Anstecken an LP1:</label></b>
	<select type="text" name="angesteckthooklp1" id="angesteckthooklp1">
		<option <?php if($angesteckthooklp1old == 0) echo selected ?> value="0">Deaktiviert</option>
		<option <?php if($angesteckthooklp1old == 1) echo selected ?> value="1">Aktiviert</option>
	</select>
</div>

<div id="angesteckthooklp1ausdiv">
	<br>
</div>
<div id="angesteckthooklp1andiv">
	<div class="row">
       		<b><label for="angesteckthooklp1_url">URL:</label></b>
        	<input type="text" name="angesteckthooklp1_url" id="angesteckthooklp1_url" value="<?php echo htmlspecialchars($angesteckthooklp1_urlold) ?>"><br>
	<br>
	</div>
	<div class="row">
		URL die (einmalig) aufgerufen wird wenn ein Fahrzeug an LP1 angesteckt wird. Erneutes Ausführen erfolgt erst nachdem abgesteckt wurde.<br><br>
	</div>
</div>
<hr>
<script>
$(function() {
      if($('#angesteckthooklp1').val() == '0') {
		$('#angesteckthooklp1ausdiv').show();
		$('#angesteckthooklp1andiv').hide();
      } else {
		$('#angesteckthooklp1ausdiv').hide();
	       	$('#angesteckthooklp1andiv').show();
      }

	$('#angesteckthooklp1').change(function(){
	      if($('#angesteckthooklp1').val() == '0') {
			$('#angesteckthooklp1ausdiv').show();
			$('#angesteckthooklp1andiv').hide();
	      } else {
			$('#angesteckthooklp1ausdiv').hide();
		       	$('#angesteckthooklp1andiv').show();
	      }
	    });
});
</script>

<div class="row">
	<b><label for="hook1_aktiv">Externes Gerät 1:</label></b>
	<select type="text" name="hook1_aktiv" id="hook1_aktiv">
		<option <?php if($hook1_aktivold == 0) echo selected ?> value="0">Deaktiviert</option>
		<option <?php if($hook1_aktivold == 1) echo selected ?> value="1">Aktiviert</option>
	</select>
</div>

<div id="hook1ausdiv">
	<br>
</div>
<div id="hook1andiv">
	<div class="row">
	Externe Geräte lassen sich per definierter URL (Webhook) an- und ausschalten in Abhängigkeit des Überschusses<br><br>
	</div>
	<div class="row">
       		<b><label for="hook1ein_watt">Gerät 1 Einschaltschwelle:</label></b>
        	<input type="text" name="hook1ein_watt" id="hook1ein_watt" value="<?php echo $hook1ein_wattold ?>"><br>
	<br>
	</div>
	<div class="row">
		Einschaltschwelle in Watt bei die unten stehende URL aufgerufen wird.<br><br>
	</div>
	<div class="row">
       		<b><label for="hook1ein_url">Gerät 1 Einschalturl:</label></b>
        	<input type="text" name="hook1ein_url" id="hook1ein_url" value="<?php echo htmlspecialchars($hook1ein_urlold) ?>"><br>
	<br>
	</div>
	<div class="row">
		Einschalturl die aufgerufen wird bei entsprechendem Überschuss.<br><br>
	</div>
	
	<div class="row">
       		<b><label for="hook1_dauer">Gerät 1 Einschaltdauer:</label></b>
        	<input type="text" name="hook1_dauer" id="hook1_dauer" value="<?php echo $hook1_dauerold ?>"><br>
	<br>
	</div>
	<div class="row">
		Einschaltdauer in Minuten. Gibt an wie lange das Gerät nach Start mindestens aktiv bleiben muss ehe Ausschalturl aufgerufen wird.<br><br>
	</div>
	<div class="row">
       		<b><label for="hook1aus_watt">Gerät 1 Ausschaltschwelle:</label></b>
        	<input type="text" name="hook1aus_watt" id="hook1aus_watt" value="<?php echo $hook1aus_wattold ?>"><br>
	<br>
	</div>
	<div class="row">
		Ausschaltschwelle in Watt bei die unten stehende URL aufgerufen wird. Soll die Abschaltung bei Bezug stattfinden eine negative Zahl eingeben.<br><br>
	</div>
	<div class="row">
       		<b><label for="hook1aus_url">Gerät 1 Ausschalturl:</label></b>
        	<input type="text" name="hook1aus_url" id="hook1aus_url" value="<?php echo htmlspecialchars($hook1aus_urlold) ?>"><br>
	<br>
	</div>
	<div class="row">
		Ausschalturl die aufgerufen wird bei entsprechendem Überschuss.<br><br>
	</div>
	<div class="row">
       		<b><label for="hook1_ausverz">Gerät 1 Ausschaltverzögerung:</label></b>
        	<input type="text" name="hook1_ausverz" id="hook1_ausverz" value="<?php echo $hook1_ausverzold ?>"><br>
	<br>
	</div>
	<div class="row">
		Bestimmt die Dauer für die die Ausschaltschwelle unterschritten werden muss bevor ausgeschaltet wird.<br><br>
	</div>


</div>
<script>
$(function() {
      if($('#hook1_aktiv').val() == '0') {
		$('#hook1ausdiv').show();
		$('#hook1andiv').hide();
      } else {
		$('#hook1ausdiv').hide();
	       	$('#hook1andiv').show();
      }

	$('#hook1_aktiv').change(function(){
	      if($('#hook1_aktiv').val() == '0') {
			$('#hook1ausdiv').show();
			$('#hook1andiv').hide();
	      } else {
			$('#hook1ausdiv').hide();
		       	$('#hook1andiv').show();
	      }
	    });
});
</script>
<hr>
<div class="row">
	<b><label for="hook2_aktiv">Externes Gerät 2:</label></b>
	<select type="text" name="hook2_aktiv" id="hook2_aktiv">
		<option <?php if($hook2_aktivold == 0) echo selected ?> value="0">Deaktiviert</option>
		<option <?php if($hook2_aktivold == 1) echo selected ?> value="1">Aktiviert</option>
	</select>
</div>

<div id="hook2ausdiv">
	<br>
</div>
<div id="hook2andiv">
	<div class="row">
	Externe Geräte lassen sich per definierter URL (Webhook) an- und ausschalten in Abhängigkeit des Überschusses<br><br>
	</div>
	<div class="row">
       		<b><label for="hook2ein_watt">Gerät 2 Einschaltschwelle:</label></b>
        	<input type="text" name="hook2ein_watt" id="hook2ein_watt" value="<?php echo $hook2ein_wattold ?>"><br>
	<br>
	</div>
	<div class="row">
		Einschaltschwelle in Watt bei die unten stehende URL aufgerufen wird.<br><br>
	</div>
	<div class="row">
       		<b><label for="hook2ein_url">Gerät 2 Einschalturl:</label></b>
        	<input type="text" name="hook2ein_url" id="hook2ein_url" value="<?php echo htmlspecialchars($hook2ein_urlold) ?>"><br>
	<br>
	</div>
	<div class="row">
		Einschalturl die aufgerufen wird bei entsprechendem Überschuss.<br><br>
	</div>
	<div class="row">
       		<b><label for="hook2_dauer">Gerät 2 Einschaltdauer:</label></b>
        	<input type="text" name="hook2_dauer" id="hook2_dauer" value="<?php echo $hook2_dauerold ?>"><br>
	<br>
	</div>
	<div class="row">
		Einschaltdauer in Minuten. Gibt an wie lange das Gerät nach Start mindestens aktiv bleiben muss ehe Ausschalturl aufgerufen wird.<br><br>
	</div>
	<div class="row">

       		<b><label for="hook2aus_watt">Gerät 2 Ausschaltschwelle:</label></b>
        	<input type="text" name="hook2aus_watt" id="hook2aus_watt" value="<?php echo $hook2aus_wattold ?>"><br>
	<br>
	</div>
	<div class="row">
		Ausschaltschwelle in Watt bei die unten stehende URL aufgerufen wird. Soll die Abschaltung bei Bezug stattfinden eine negative Zahl eingeben.<br><br>
	</div>
	<div class="row">
       		<b><label for="hook2aus_url">Gerät 2 Ausschalturl:</label></b>
        	<input type="text" name="hook2aus_url" id="hook2aus_url" value="<?php echo htmlspecialchars($hook2aus_urlold) ?>"><br>
	<br>
	</div>
	<div class="row">
		Ausschalturl die aufgerufen wird bei entsprechendem Überschuss.<br><br>
	</div>


</div>
<script>
$(function() {
      if($('#hook2_aktiv').val() == '0') {
		$('#hook2ausdiv').show();
		$('#hook2andiv').hide();
      } else {
		$('#hook2ausdiv').hide();
	       	$('#hook2andiv').show();
      }

	$('#hook2_aktiv').change(function(){
	      if($('#hook2_aktiv').val() == '0') {
			$('#hook2ausdiv').show();
			$('#hook2andiv').hide();
	      } else {
			$('#hook2ausdiv').hide();
		       	$('#hook2andiv').show();
	      }
	    });
});
</script>
<hr>
<div class="row">
	<b><label for="hook3_aktiv">Externes Gerät 3:</label></b>
	<select type="text" name="hook3_aktiv" id="hook3_aktiv">
		<option <?php if($hook3_aktivold == 0) echo selected ?> value="0">Deaktiviert</option>
		<option <?php if($hook3_aktivold == 1) echo selected ?> value="1">Aktiviert</option>
	</select>
</div>

<div id="hook3ausdiv">
	<br>
</div>
<div id="hook3andiv">
	<div class="row">
	Externe Geräte lassen sich per definierter URL (Webhook) an- und ausschalten in Abhängigkeit des Überschusses<br><br>
	</div>
	<div class="row">
       		<b><label for="hook3ein_watt">Gerät 3 Einschaltschwelle:</label></b>
        	<input type="text" name="hook3ein_watt" id="hook3ein_watt" value="<?php echo $hook3ein_wattold ?>"><br>
	<br>
	</div>
	<div class="row">
		Einschaltschwelle in Watt bei die unten stehende URL aufgerufen wird.<br><br>
	</div>
	<div class="row">
       		<b><label for="hook3ein_url">Gerät 3 Einschalturl:</label></b>
        	<input type="text" name="hook3ein_url" id="hook3ein_url" value="<?php echo htmlspecialchars($hook3ein_urlold) ?>"><br>
	<br>
	</div>
	<div class="row">
		Einschalturl die aufgerufen wird bei entsprechendem Überschuss.<br><br>
	</div>
	<div class="row">
       		<b><label for="hook3_dauer">Gerät 3 Einschaltdauer:</label></b>
        	<input type="text" name="hook3_dauer" id="hook3_dauer" value="<?php echo $hook3_dauerold ?>"><br>
	<br>
	</div>
	<div class="row">
		Einschaltdauer in Minuten. Gibt an wie lange das Gerät nach Start mindestens aktiv bleiben muss ehe Ausschalturl aufgerufen wird.<br><br>
	</div>
	<div class="row">

       		<b><label for="hook3aus_watt">Gerät 3 Ausschaltschwelle:</label></b>
        	<input type="text" name="hook3aus_watt" id="hook3aus_watt" value="<?php echo $hook3aus_wattold ?>"><br>
	<br>
	</div>
	<div class="row">
		Ausschaltschwelle in Watt bei die unten stehende URL aufgerufen wird. Soll die Abschaltung bei Bezug stattfinden eine negative Zahl eingeben.<br><br>
	</div>
	<div class="row">
       		<b><label for="hook3aus_url">Gerät 3 Ausschalturl:</label></b>
        	<input type="text" name="hook3aus_url" id="hook3aus_url" value="<?php echo htmlspecialchars($hook3aus_urlold) ?>"><br>
	<br>
	</div>
	<div class="row">
		Ausschalturl die aufgerufen wird bei entsprechendem Überschuss.<br><br>
	</div>

</div><hr>
<script>
$(function() {
      if($('#hook3_aktiv').val() == '0') {
		$('#hook3ausdiv').show();
		$('#hook3andiv').hide();
      } else {
		$('#hook3ausdiv').hide();
	       	$('#hook3andiv').show();
      }

	$('#hook3_aktiv').change(function(){
	      if($('#hook3_aktiv').val() == '0') {
			$('#hook3ausdiv').show();
			$('#hook3andiv').hide();
	      } else {
			$('#hook3ausdiv').hide();
		       	$('#hook3andiv').show();
	      }
	    });
});
</script>

<div class="row">
	<b><label for="verbraucher1_aktiv">Verbraucher 1:</label></b>
	<select type="text" name="verbraucher1_aktiv" id="verbraucher1_aktiv">
		<option <?php if($verbraucher1_aktivold == 0) echo selected ?> value="0">Deaktiviert</option>
		<option <?php if($verbraucher1_aktivold == 1) echo selected ?> value="1">Aktiviert</option>
	</select>
</div>

<div id="verbraucher1ausdiv">
	<br>
</div>
<div id="verbraucher1andiv">
	<div class="row">
	Externe Verbraucher lassen sich in das Logging von OpenWB mit einbinden.<br><br>
	</div>
	<div class="row">
		<b><label for="verbraucher1_typ">Anbindung Verbraucher 1:</label></b>
		<select type="text" name="verbraucher1_typ" id="verbraucher1_typ">
			<option <?php if($verbraucher1_typold == "http\n") echo selected ?> value="http">Http Abfrage</option>
			<option <?php if($verbraucher1_typold == "mpm3pm\n") echo selected ?> value="mpm3pm">MPM3PM</option>
			<option <?php if($verbraucher1_typold == "sdm120\n") echo selected ?> value="sdm120">SDM120</option>
			<option <?php if($verbraucher1_typold == "sdm630\n") echo selected ?> value="sdm630">SDM630</option>
			<option <?php if($verbraucher1_typold == "tasmota\n") echo selected ?> value="tasmota">Sonoff mit Tasmota FW</option>

		</select><br><br>
	</div>
	<div class="row">
       		<b><label for="verbraucher1_name">Verbraucher 1 Name:</label></b>
        	<input type="text" name="verbraucher1_name" id="verbraucher1_name" value="<?php echo $verbraucher1_nameold ?>"><br>
	<br>
	</div>
	<div class="row">
		Name des Verbrauchers 1.<br><br>
	</div>
<div id="v1http">
	<div class="row">
       		<b><label for="verbraucher1_urlw">Verbraucher 1 URL:</label></b>
        	<input size="50" type="text" name="verbraucher1_urlw" id="verbraucher1_urlw" value="<?php echo htmlspecialchars($verbraucher1_urlwold) ?>"><br>
	<br>
	</div>
	<div class="row">
		URL des Verbrauchers Momentanleistung in Watt.<br><br>
	</div>
	<div class="row">
       		<b><label for="verbraucher1_urlh">Verbraucher 1 URL:</label></b>
	<input size="50" type="text" name="verbraucher1_urlh" id="verbraucher1_urlh" value="<?php echo htmlspecialchars($verbraucher1_urlhold) ?>"><br>

	<br>
	</div>
	<div class="row">
		URL des Verbrauchers Zählerststandes in Watt Stunden.<br><br>
	</div>
</div>
<div id="v1modbus">
	<div class="row">
       		<b><label for="verbraucher1_source">Verbraucher 1 Source:</label></b>
        	<input type="text" name="verbraucher1_source" id="verbraucher1_source" value="<?php echo $verbraucher1_sourceold ?>"><br>
	<br>
	</div>
	<div class="row">
		Bei lokal angeschlossenem Zähler ist dies /dev/ttyUSB3 (z.B.). Wird ein Modbus Ethernet Konverter genutzt, z.B. der aus dem Shop, hier die IP Adresse eintragen.<br><br>
	</div>
	<div class="row">
       		<b><label for="verbraucher1_id">Verbraucher 1 ID:</label></b>
        	<input type="text" name="verbraucher1_id" id="verbraucher1_id" value="<?php echo $verbraucher1_idold ?>"><br>
	<br>
	</div>
	<div class="row">
		Modbus ID.<br><br>
	</div>
</div>
<div id="v1tasmota">
	<div class="row">
       		<b><label for="verbraucher1_ip">Verbraucher 1 IP:</label></b>
        	<input type="text" name="verbraucher1_ip" id="verbraucher1_ip" value="<?php echo $verbraucher1_ipold ?>"><br>
	<br>
	</div>
	<div class="row">
		IP Adresse des Tasmota Sonoff Geräts.<br><br>
	</div>
</div>

</div><br>

<script>
function display_verbraucher1 () {
	$('#v1http').hide(); 
	$('#v1modbus').hide();
	$('#v1tasmota').hide();
if($('#verbraucher1_typ').val() == 'http') {
$('#v1http').show();
}
if($('#verbraucher1_typ').val() == 'mpm3pm') {
$('#v1modbus').show();
}
if($('#verbraucher1_typ').val() == 'sdm630') {
$('#v1modbus').show();
}
if($('#verbraucher1_typ').val() == 'sdm120') {
$('#v1modbus').show();
}
if($('#verbraucher1_typ').val() == 'tasmota') {
$('#v1tasmota').show();
}

}
display_verbraucher1();
$('#verbraucher1_typ').change(function(){
	display_verbraucher1();
});
</script>

<script>
$(function() {
      if($('#verbraucher1_aktiv').val() == '0') {
		$('#verbraucher1ausdiv').show();
		$('#verbraucher1andiv').hide();
      } else {
		$('#verbraucher1ausdiv').hide();
	       	$('#verbraucher1andiv').show();
      }

	$('#verbraucher1_aktiv').change(function(){
	      if($('#verbraucher1_aktiv').val() == '0') {
			$('#verbraucher1ausdiv').show();
			$('#verbraucher1andiv').hide();
	      } else {
			$('#verbraucher1ausdiv').hide();
		       	$('#verbraucher1andiv').show();
	      }
	    });
});
</script>

<hr>
<div class="row">
	<b><label for="verbraucher2_aktiv">Verbraucher 2:</label></b>
	<select type="text" name="verbraucher2_aktiv" id="verbraucher2_aktiv">
		<option <?php if($verbraucher2_aktivold == 0) echo selected ?> value="0">Deaktiviert</option>
		<option <?php if($verbraucher2_aktivold == 1) echo selected ?> value="1">Aktiviert</option>
	</select>
</div>

<div id="verbraucher2ausdiv">
	<br>
</div>
<div id="verbraucher2andiv">
	<div class="row">
	Externe Verbraucher lassen sich in das Logging von OpenWB mit einbinden.<br><br>
	</div>
	<div class="row">
		<b><label for="verbraucher2_typ">Anbindung Verbraucher 2:</label></b>
		<select type="text" name="verbraucher2_typ" id="verbraucher2_typ">
			<option <?php if($verbraucher2_typold == "http\n") echo selected ?> value="http">Http Abfrage</option>
			<option <?php if($verbraucher2_typold == "mpm3pm\n") echo selected ?> value="mpm3pm">MPM3PM</option>
			<option <?php if($verbraucher2_typold == "sdm120\n") echo selected ?> value="sdm120">SDM120</option>
			<option <?php if($verbraucher2_typold == "sdm630\n") echo selected ?> value="sdm630">SDM630</option>
			<option <?php if($verbraucher2_typold == "tasmota\n") echo selected ?> value="tasmota">Sonoff mit Tasmota FW</option>

		</select><br><br>
	</div>
	<div class="row">
       		<b><label for="verbraucher2_name">Verbraucher 2 Name:</label></b>
        	<input type="text" name="verbraucher2_name" id="verbraucher2_name" value="<?php echo $verbraucher2_nameold ?>"><br>
	<br>
	</div>
	<div class="row">
		Name des Verbrauchers 2.<br><br>
	</div>
<div id="v2http">
	<div class="row">
       		<b><label for="verbraucher2_urlw">Verbraucher 2 URL:</label></b>
        	<input size="50" type="text" name="verbraucher2_urlw" id="verbraucher2_urlw" value="<?php echo htmlspecialchars($verbraucher2_urlwold) ?>"><br>
	<br>
	</div>
	<div class="row">
		URL des Verbrauchers Momentanleistung in Watt.<br><br>
	</div>
	<div class="row">
       		<b><label for="verbraucher2_urlh">Verbraucher 2 URL:</label></b>
	<input size="50" type="text" name="verbraucher2_urlh" id="verbraucher2_urlh" value="<?php echo htmlspecialchars($verbraucher2_urlhold) ?>"><br>

	<br>
	</div>
	<div class="row">
		URL des Verbrauchers Zählerststandes in Watt Stunden.<br><br>
	</div>
</div>
<div id="v2modbus">
	<div class="row">
       		<b><label for="verbraucher2_source">Verbraucher 2 Source:</label></b>
        	<input type="text" name="verbraucher2_source" id="verbraucher2_source" value="<?php echo $verbraucher2_sourceold ?>"><br>
	<br>
	</div>
	<div class="row">
		Bei lokal angeschlossenem Zähler ist dies /dev/ttyUSB3 (z.B.). Wird ein Modbus Ethernet Konverter genutzt, z.B. der aus dem Shop, hier die IP Adresse eintragen.<br><br>
	</div>
	<div class="row">
       		<b><label for="verbraucher2_id">Verbraucher 2 ID:</label></b>
        	<input type="text" name="verbraucher2_id" id="verbraucher2_id" value="<?php echo $verbraucher2_idold ?>"><br>
	<br>
	</div>
	<div class="row">
		Modbus ID.<br><br>
	</div>
</div>
<div id="v2tasmota">
	<div class="row">
       		<b><label for="verbraucher2_ip">Verbraucher 2 IP:</label></b>
        	<input type="text" name="verbraucher2_ip" id="verbraucher2_ip" value="<?php echo $verbraucher2_ipold ?>"><br>
	<br>
	</div>
	<div class="row">
		IP Adresse des Tasmota Sonoff Geräts.<br><br>
	</div>
</div>

</div><br>

<script>
function display_verbraucher2 () {
	$('#v2http').hide(); 
	$('#v2modbus').hide();
	$('#v2tasmota').hide();
if($('#verbraucher2_typ').val() == 'http') {
$('#v2http').show();
}
if($('#verbraucher2_typ').val() == 'mpm3pm') {
$('#v2modbus').show();
}
if($('#verbraucher2_typ').val() == 'sdm630') {
$('#v2modbus').show();
}
if($('#verbraucher2_typ').val() == 'sdm120') {
$('#v2modbus').show();
}
if($('#verbraucher2_typ').val() == 'tasmota') {
$('#v2tasmota').show();
}

}
display_verbraucher2();
$('#verbraucher2_typ').change(function(){
	display_verbraucher2();
});
</script>

<script>
$(function() {
      if($('#verbraucher2_aktiv').val() == '0') {
		$('#verbraucher2ausdiv').show();
		$('#verbraucher2andiv').hide();
      } else {
		$('#verbraucher2ausdiv').hide();
	       	$('#verbraucher2andiv').show();
      }

	$('#verbraucher2_aktiv').change(function(){
	      if($('#verbraucher2_aktiv').val() == '0') {
			$('#verbraucher2ausdiv').show();
			$('#verbraucher2andiv').hide();
	      } else {
			$('#verbraucher2ausdiv').hide();
		       	$('#verbraucher2andiv').show();
	      }
	    });
});
</script>








</div>
<div class="col-xs-1">
</div>

<button type="submit" class="btn btn-primary btn-green">Save</button>
 </form><br><br />

<br><br>
<br><br>

 <button onclick="window.location.href='./index.php'" class="btn btn-primary btn-blue">Zurück</button>
<br><br>
<div class="row">
<div class="text-center">
Open Source made with love!<br>
<form action="https://www.paypal.com/cgi-bin/webscr" method="post" target="_top">
<input type="hidden" name="cmd" value="_s-xclick">
<input type="hidden" name="hosted_button_id" value="2K8C4Y2JTGH7U">
<input type="image" src="./img/btn_donate_SM.gif" border="0" name="submit" alt="Jetzt einfach, schnell und sicher online bezahlen – mit PayPal.">
<img alt="" border="0" src="./img/pixel.gif" width="1" height="1">
</form>
</div></div>



</div>
<script>
	var settingspwaktold = <?php echo $settingspwaktold ?>;

	var settingspwold = <?php echo $settingspwold ?>;
if ( settingspwaktold == 1 ) {
passWord();
}
function passWord() {
var testV = 1;
var pass1 = prompt('Einstellungen geschützt, bitte Password eingeben:','');

while (testV < 3) {
	if (!pass1) 
		history.go(-1);
	if (pass1 == settingspwold) {
		break;
	} 
	testV+=1;
	var pass1 = prompt('Passwort falsch','Password');
}
if (pass1!="password" & testV == 3) 
	history.go(-1);
return " ";
} 
</script>
</body></html>
