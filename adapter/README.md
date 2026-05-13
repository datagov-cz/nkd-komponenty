# Adaptér na externí služby

Tato komponenta obsahuje následující adaptéry na externí služby:
- ms-adaptér -
  [Adaptér pro přístup ke službám skrze Microsoft Graph API](https://github.com/datagov-cz/ms-adapter/) je spouštěný ve dvou režimech.
  První umožňuje stažení seznamu (registrovaných aplikací), druhý pak adresáře (přílohy k registracím),
  V prvním režimu provádí stáhnutí seznamu registrovaných aplikací, ve druhém pak obrázkových příloh.
- isds-adapter -
  [Adaptér pro stažení datových zpráv](https://github.com/datagov-cz/isds-adapter/).

## Konfigurace

Spouštění adaptérů je zajištěné pomocí Cronu jehož konfigurace je v souboru `./crontab`.

Konfigurace předaná isds-adaptéru je uložena v `/opt/isds-adapter/configuration.properties`.
V tomto souboru jsou definovány i cestu k načtení certifikátů a uložení stažených zpráv.
Ve výchozím nastavení se certifikáty čtou z adresáře `/data/certificates`, který je naplněný certifikáty z `./certificates` v tomto repositáři.

Obsah `.env` souboru:
```ini
# Konfigurace pro ms-adaptér popsaná v jeho dokumentaci.
MS_APPLICATION=
MS_TENANT=
MS_SECRET=

# Odpovídá argumentu "site" jak je popsán v dokumentaci k ms-adaptéru.
# Jedná se o stránku/skupiny s registracemi aplikací.
MS_SITE=

# Odpovídá argumentu "list" jak je popsán v dokumentaci k ms-adaptéru.
# Jedná se o list s registracemi aplikací.
MS_APPLICATIONS_LIST=

# Odpovídá argumentu "path" jak je popsán v dokumentaci k ms-adaptéru.
# Jedná se o cestu oddělenou pomocí znaku `/`.
# První část cesty je jméno knihovny, následují jména adresářů.
# Cesta vede do adresáře obrázků pro aplikace.
MS_APPLICATIONS_PATH=

# Odpovídá argumentu "list" jak je popsán v dokumentaci k ms-adaptéru.
# Jedná se o list s registracemi aplikací.
MS_SUGGESTIONS_LIST=

# Odpovídá argumentu "list" jak je popsán v dokumentaci k ms-adaptéru.
# Jedná se o list s poskytovateli.
MS_ALLOWED_PUBLISHERS_LIST=

# Konfigurace isds-adaptéru popsaná v jeho dokumentaci.
ISDS_LOGIN=
ISDS_PASSWORD=
ISDS_URL=
```

## Datová úložiště

Veškerá stažená data jsou uložena v adresáři `/data/adapter/` následujícím způsobem:
- `/data/adapter/applications/content.trig` -
  List registrovaných aplikací.
- `/data/adapter/applications-images/` -
  Přílohy k registrovaným aplikacím.
- `/data/adapter/registrations` -
  Datové zprávy, nastaveno v konfiguraci isds-adaptéru.
- `/data/adapter/suggestions/content.trig` -
  List registrovaných požadavků na zveřejnění datových sad.
- `/data/adapter/suggestions/allowed-publishers.trig` -
  List povolených poskytovatelů.

Aplikace běží pod uživatelem 5987:5987 pro kterého je třeba nastavit práva v datovém úložišti.

## Logování

Adaptéry zapisují logy ve formát JSON do adresáře `/data/log/`.
Jedná se o přesměrování výstupu z adaptérů a je tedy třeba zajistit jeho pravidelné mazání, či rotaci.

## Porty

Tento image nevystavuje žádné porty.

## Vstupní body

- `/opt/adapter/applications-list.sh`
  Stáhne seznam aplikací.
- `/opt/adapter/applications-image.sh`
  Stáhne obrázky pro aplikace.
- `/opt/adapter/suggestions-list.sh`
  Stáhne seznam navržených datových sad pro zveřejnění.
- `/opt/adapter/allowed-publishers-list.sh`
  Stáhne seznam povolených poskytovatelů.
- `/opt/adapter/isds.sh`
  Stáhne zprávy z ISDS.

## Poznámky pro vývoj
