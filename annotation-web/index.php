<?php
?>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
   "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
<link rel="stylesheet" href="style.css"/>
<title>Hodnocení překladu testovací sady pro WMT SAO</title>
</head>
<body>
<script src="form.js"></script>

<h1>Hodnocení překladu testovací sady pro WMT SAO</h1>
  
<form name="annot_form" action="http://ufal.mff.cuni.cz/wmt19-elitr-testsuite/submit.php" method="post" onsubmit="return validateForm()">
<div class="annot-info">
	<div><label>Kód dokumentu</label><input type="text" name="code" required="required"/></div>
	<div><label>Jméno anotátora</label><input type="text" name="annot-name" required="required"/></div>
	<div><label>Odborník v dané tématice</label><input type="checkbox" name="annot-expert" value="true"/></div>
</div>
<div class="transl inline-radio">
	<div class="radio-title"><span>Směr překladu</span></div>
	<div class="radio-items">
	<div><input type="radio" name="transl" value="en-cs" checked="checked"/><label>angličtina → čeština</label></div>
	<div><input type="radio" name="transl" value="en-de"/><label>angličtina → němčina</label></div>
	<div><input type="radio" name="transl" value="de-en"/><label>němčina → angličtina</label></div>
	</div>
</div> 
<div class="item inline-radio">
	<div class="radio-title"><span>Pravopis a tvarosloví</span></div>
	<div class="radio-items">
	<div><input type="radio" name="morph" value="0"/><label>Zásadně narušuje</label></div>
	<div><input type="radio" name="morph" value="1"/><label>Spíš narušuje</label></div>
	<div><input type="radio" name="morph" value="2"/><label>Spíš nenarušuje</label></div>
	<div><input type="radio" name="morph" value="3"/><label>Nenarušuje</label></div>
	</div>
</div> 
<div class="item inline-radio">
	<div class="radio-title"><span>Slovní zásoba - adekvátnost užitého lexika</span></div>
	<div class="radio-items">
	<div><input type="radio" name="lex-adeq" value="0"/><label>Zásadně narušuje</label></div>
	<div><input type="radio" name="lex-adeq" value="1"/><label>Spíš narušuje</label></div>
	<div><input type="radio" name="lex-adeq" value="2"/><label>Spíš nenarušuje</label></div>
	<div><input type="radio" name="lex-adeq" value="3"/><label>Nenarušuje</label></div>
	</div>
</div> 
<div class="item inline-radio">
	<div class="radio-title"><span>Slovní zásoba - porozumění textu (z hlediska ???užitého lexika???)</span></div>
	<div class="radio-items">
	<div><input type="radio" name="lex-compreh" value="0"/><label>Zásadně narušuje</label></div>
	<div><input type="radio" name="lex-compreh" value="1"/><label>Spíš narušuje</label></div>
	<div><input type="radio" name="lex-compreh" value="2"/><label>Spíš nenarušuje</label></div>
	<div><input type="radio" name="lex-compreh" value="3"/><label>Nenarušuje</label></div>
	</div>
</div> 
<div class="item inline-radio">
	<div class="radio-title"><span>Syntax</span></div>
	<div class="radio-items">
	<div><input type="radio" name="syntax" value="0"/><label>Zásadně narušuje</label></div>
	<div><input type="radio" name="syntax" value="1"/><label>Spíš narušuje</label></div>
	<div><input type="radio" name="syntax" value="2"/><label>Spíš nenarušuje</label></div>
	<div><input type="radio" name="syntax" value="3"/><label>Nenarušuje</label></div>
	</div>
</div> 
<div class="item inline-radio">
	<div class="radio-title"><span>Koherence a celkové porozumění textu</span></div>
	<div class="radio-items">
	<div><input type="radio" name="coherence" value="0"/><label>Zásadně narušuje</label></div>
	<div><input type="radio" name="coherence" value="1"/><label>Spíš narušuje</label></div>
	<div><input type="radio" name="coherence" value="2"/><label>Spíš nenarušuje</label></div>
	<div><input type="radio" name="coherence" value="3"/><label>Nenarušuje</label></div>
	</div>
</div> 
<div class="item textbox">
	<label>Nejhorší chyby</label><textarea name="errors"></textarea>
</div>
<div class="item textbox">
	<label>Poznámky</label><textarea name="notes"></textarea>
</div>
<div class="submit">
	<input type="submit" name="submit" value="Odeslat hodnocení"/>
</div>
</form>
</body>
</html>
