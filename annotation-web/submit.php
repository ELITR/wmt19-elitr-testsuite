<?php
  error_reporting(E_ALL ^ E_NOTICE);
  // Import variables but escape HTML entities
  foreach ($_POST as $var => $val) {
    $invar[$var] = htmlspecialchars($val);
    // print "VAR $var: $val, $invar[$var]<br/>\n";
  }


  // Save all the details to my log!
  $logfile = "./annot.log";  // where to store the log
  $admin_mail = "mnovak@ufal.mff.cuni.cz";

  $ip=getenv("REMOTE_ADDR");
  if(isset($_COOKIE["user"])) {
    $user = $_COOKIE["user"];
  } else {
    $user = md5($ip.time());
  }
  setcookie("user", $user, time()+60*60*24*365*2, "/");
  $referer = getenv("HTTP_REFERER");
  $agent = getenv("HTTP_USER_AGENT");
  $time = date("Y-m-d H:i:s");

  $logline = "$time\t$ip\t$user\t$referer\t$agent";
  $vars = array(
    "code",
    "transl",
    "annot-name",
    "annot-expert",
    "morph",
    "lex-adeq",
    "lex-compreh",
    "syntax",
    "coherence",
    "errors",
    "notes",
    );
  foreach ($vars as $var) {
    $val = $invar[$var];
    $val = str_replace("\r\n", "\\n", $val);
    $val = str_replace("\n", "\\n", $val);
    $val = str_replace("\r", "\\n", $val);
    $val = str_replace("\t", "\\t", $val);
    $usevar[$var] = $val;
    $logline .= "\t$val";
  }
  $logline .= "\n";
  if(is_writeable($logfile) && ($fh = fopen($logfile,'a')) != FALSE){
    fwrite($fh, $logline);
    fclose($fh);
  } else {
    $mailerror = "CWD: ".getcwd()."\n"
      ."LOGFILE: ".$logfile."\n\n"
      .$logline;
    mail($admin_mail, "WMT SAO Testsuites cannot append annotation log", $mailerror);
  }

?>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
   "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
<meta http-equiv="refresh" content="5;url=http://ufal.mff.cuni.cz/wmt19-elitr-testsuite/index.php" />
<link rel="stylesheet" href="style.css"/>
<title>Hodnocení překladu testovací sady pro WMT SAO</title>
</head>
<body>
<h1>Hodnocení překladu testovací sady pro WMT SAO</h1>
<p>Vaše hodnocení bylo uloženo.</p>
<p>Za malý moment budete automaticky přesměrovaní zpět na <a href="http://ufal.mff.cuni.cz/wmt19-eli|</head>                                                                    
tr-testsuite/index.php" target="form">formulář hodnocení</a>.
</p>
</body>
</html>
