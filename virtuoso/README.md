# Virtuoso databáze

Tento obraz je založený na [Virtuoso Open Source 7](https://hub.docker.com/r/openlink/virtuoso-opensource-7/), změny proti základnímu obrazu jsou následují.
- Při spuštění je instalován [Faceted Browsing Service](https://vos.openlinksw.com/owiki/wiki/VOS/VirtuosoFacetsWebService) plugin.
- Zvýšen limit `MaxConstructTriples = 100000` - potřebný pro dotazy ohledně datové kvality

## Konfigurace

Obsah `.env` souboru:
```ini
# Heslo pro "dba" uživatele.
DBA_PASSWORD=
# Heslo pro "dva" uživatele.
DAV_PASSWORD=
# Přenastavení hodnot z konfigurace.
# https://hub.docker.com/r/openlink/virtuoso-opensource-7/#updating-virtuosoini-via-environment-settings
VIRT_PARAMETERS_NUMBEROFBUFFERS=
VIRT_PARAMETERS_MAXDIRTYBUFFERS=
```

## Datová úložiště

Data jsou uložena do adresáře `/database` pro uživatele `1001:1001`.

## Logování

Logy jsou zapisovány do `/database`.

## Porty

- 1111 - ODBC 2 / JDBC / ADO.Net / OLE-DB / ISQL data server
- 8890 - HTTP

## Vstupní body

## Poznámky pro vývoj

- Adresář `initdb.d` obsahuje inicializační skripty ke spuštění.
