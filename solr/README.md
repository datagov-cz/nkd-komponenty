# Solr databáze

## Konfigurace

Tato komponenta nevyžaduje žádnou konfiguraci.

## Datová úložiště

Data jsou uložena do adresáře `/var/solr/data` pro uživatele `8983:8983`.

## Logování

Logy jsou uloženy do adresáře `/var/solr/logs`.
[Logování je konfigurováno](https://solr.apache.org/guide/solr/latest/deployment-guide/configuring-logging.html) rotací po 10 souborech o maximální velikosti souboru 32MB.

## Porty

- 8983

## Vstupní body

## Poznámky pro vývoj

- [Solr’s Configuration Files](https://solr.apache.org/guide/solr/latest/configuration-guide/configuration-files.html#solrs-configuration-files).
- Pokud bychom potřebovali synonyma nebo stop slova tak lze konfigurovat pomocí:
  ```xml
  <analyzer type="index">
    <filter class="solr.StopFilterFactory" words="/stopwords.txt" ignoreCase="true"/>
    <filter class="solr.SynonymGraphFilterFactory" expand="true" ignoreCase="true" synonyms="/synonyms.txt"/>
  </analyzer>
  ```
