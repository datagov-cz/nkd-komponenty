# Jekyll

Pro update obsahu webových stránek, je třeba nastavit Github hook na adresu `/api/on-github-push.php`.

## Vstupní body

- `/opt/entrypoint.sh`
  Výchozí vstupní bod, inicializuje data a spustí Apache.

## Konfigurace

Obsah `.env` souboru:
```ini
# Výchozí branch.
GITHUB_BRANCH=main
# Název repositáře ve tvaru {team}/{repository}
GITHUB_REPOSITORY=datagov-cz/data.gov.cz
# Secret z Github konfigurace.
GITHUB_SECRET=
# Port pro Apache server.
PORT=80
```

## Datová úložiště

Data stažená z externích zdrojů jsou uložena do adresáře `/data/website`.
Pro urychlení spuštění je vhodné ho připojit jako volume.

## Logování

API funkce, pro synchronizaci, zapisuje výsledek do adresáře `/data/log/github.log`.
Tento soubor je přepsán s každou synchronizací.

## Porty

Komponenta poslouchá na následujících portech:
- `{PORT}` - HTTP server.
