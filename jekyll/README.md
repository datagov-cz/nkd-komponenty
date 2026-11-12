# Jekyll

Komponenta sestavuje webové stránky pomocí Jekyll a servíruje je pomocí nginx.
Pro update obsahu webových stránek, je třeba nastavit Github hook na adresu `/api/on-github-push-data.php`.
Hook musí mít content type `application/json`, secret odpovídající `GITHUB_SECRET` a událost `push`.

Požadavky z Github přijímá [webhook](https://github.com/adnanh/webhook) naslouchající na `127.0.0.1:9000`, nginx na něj požadavky přeposílá.
Webhook ověřuje podpis `X-Hub-Signature-256`, typ události, větev a repositář.
Konfigurace je v souboru `./webhook/hooks.json`.

## Vstupní body

- `/jekyll-entrypoint.sh`
  Výchozí vstupní bod, inicializuje data, sestaví stránky a spustí webhook a nginx.

- `/opt/jekyll/update-content.sh`
  Provede synchronizaci a sestavení webových stránek.
  Je voláno v reakci na oprávněný požadavek na `/api/on-github-push-data.php`.
  Současně běží nejvýše jedno sestavení, další čekají na jeho dokončení.

## Konfigurace

Obsah `.env` souboru:
```ini
# Výchozí branch.
GITHUB_BRANCH=main
# Název repositáře ve tvaru {team}/{repository}
GITHUB_REPOSITORY=datagov-cz/data.gov.cz
# Secret z Github konfigurace.
GITHUB_SECRET=
# Port pro nginx server.
PORT=80
# Konfigurace k předání příkazu "jekyll build".
JEKYLL_BUILD_CONFIGURATION=
```

## Datová úložiště

Data stažená z externích zdrojů jsou uložena do adresáře `/data/website`.
Pro urychlení spuštění je vhodné ho připojit jako volume.

Sestavené stránky jsou uloženy do adresáře `/data/site/{čas}-{commit}`.
Odkaz `/data/site/current` ukazuje na poslední úspěšné sestavení a je přepnut až po jeho dokončení.
Ponechána jsou poslední dvě sestavení.

Data jsou vlastněna uživatelem `www-data`.

## Logování

Standardní výstup, včetně výstupu sestavení.

## Porty

Komponenta poslouchá na následujících portech:
- `{PORT}` - HTTP server.
