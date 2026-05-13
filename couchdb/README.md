# CouchDB databáze

## Konfigurace

Obsah `.env` souboru:
```ini
# Uživatelské jméno pro plný/administrátorský přístup.
COUCHDB_USER=
# Heslo
COUCHDB_PASSWORD=
```

## Datová úložiště

Data jsou uložena do adresáře `/opt/couchdb/data` pro uživatele `5984:5984`.

## Logování

Logy jsou zapisovány na standardní výstup.

## Porty

- 5984

## Vstupní body

## Poznámky pro vývoj

- Fauxton je dostupný na `http://localhost:5984/_utils/`.
