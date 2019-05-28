// Included fastclick.js to make the inputs quicker to respond to taps on mobile

if ('addEventListener' in document) {
    document.addEventListener('DOMContentLoaded', function() {
        FastClick.attach(document.body);
    }, false);
}

function validateForm() {
  var transl = document.forms["annot_form"]["transl"].value;
  var ids = new Set([]);
  if (transl == "en-cs") {
    ids = new Set(["abeceda", "ambice", "amulet", "artikl", "azalka", "biograf", "bojkot", "bordel", "briketa", "chlast", "chodec", "choroba", "chudoba", "cizina", "divadlo", "dohoda", "dotace", "drzost", "dvorek", "embryo", "energie", "exodus", "fazole", "fialka", "fialovo", "floutek", "fotbal", "geolog", "glamour", "harburn", "hlahol", "homole", "hostie", "houska", "impuls", "injekce", "inkoust", "jahoda", "kachna", "kaktus", "klubko", "kobliha", "kobylka", "kohout", "komise", "koncert", "kontakt", "kostka", "koupel", "krabice", "kreace", "kredenc", "krocan", "krutost", "kultura", "kyvadlo", "lavina", "leopard", "libost", "listina", "madame", "malina", "maminka", "martini", "megafon", "melasa", "metoda", "ministr", "mlsnost", "mocnost", "monolog", "mozaika", "narcis", "nesmysl", "nevina", "newton", "nocleh", "novinka", "noviny", "obchod", "oblast", "obloha", "obluda", "obsluha", "odvaha", "odznak", "opasek", "opilost", "opozice", "oslava", "osypky", "pahorek", "pavouk", "plamen", "plenka", "pleskot", "pochva", "podium", "podnos", "pohovka", "pohovor", "poklad", "pokles", "poloha", "pomyje", "ponorka", "poplach", "postava", "potopa", "pouzdro", "povlak", "pracka", "prales", "pravice", "pravnuk", "profil", "prorok", "pustina", "rovina", "rozloha", "rozmach", "sekvoje", "semeno", "semestr", "sfinga", "sillos", "skladba", "skupina", "slabost", "slanina", "sloupek", "smaragd", "soubor", "stehno", "stream", "stromek", "studie", "sugesce", "svoboda", "tabulka", "tajnost", "teniska", "tkanivo", "tlumok", "toulka", "tyranie", "uzenka", "varhany", "venkov", "vidlice", "vitrina", "vizita", "volant", "vrabec", "vrstva", "vzhled", "zbytek", "zmetek", "zrcadlo", "zvonek"]);
  } else {
    ids = new Set(["absence", "anthrax", "anyting", "artist", "basket", "belief", "bicycle", "bladder", "blower", "cleaser", "clothes", "dealer", "defence", "dempsey", "denial", "dioxide", "emotion", "enovate", "feeder", "freeze", "hackles", "hanging", "health", "instant", "leather", "looser", "mantra", "morale", "ousting", "pewter", "preview", "pricing", "regime", "rescuer", "scenery", "serpent", "servant", "shelter", "silkie", "solving", "someone", "stamina", "tattoo", "thesis", "trailor", "trickle", "tsunami", "winger"]);
  }
  var code = document.forms["annot_form"]["code"].value;
  if (!ids.has(code)) {
    alert("Dokument s kódem '" + code + "' neexistuje.");
    return false;
  }
}
