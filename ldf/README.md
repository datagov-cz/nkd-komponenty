# Linked Data Fragments

Komponenta Národního katalogu dat zpřístupňující Linked Data Fragments (LDF) server.

## Konfigurace

Obsah `.env` souboru:
```ini
# Port pro LDF server.
LDF_PORT=3000
# Počet vláken LDF serveru.
LDF_WORKERS=4
# Base URL for LDF server, must not end with '/'.
LDF_BASE_URL=
# URL of SPARQL serveru.
LDF_SPARQL=
# Port kontrolního HTTP rozhraní.
PORT=5000
# Přístupový token pro reload.
RELOAD_TOKEN=
```

## Datová úložiště

Komponenta předpokládá existenci souboru `/data/nkod.hdt`.

## Logování

Standardní výstup.

## Porty

Dle konfigurace.

## Vstupní body


## Poznámky pro vývoj

- Soubor `configuration.json` je tvořen z `configuration.template.json` nahrazením `{LDF_}` za obsah proměnných prostředí.
