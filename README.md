# BelGrammarTools
Various supplementary tools, used by the other repositories

## construct-wordforms-bel.rb

    git clone https://github.com/Belarus/GrammarDB.git
    ruby construct-wordforms-bel.rb > wordforms-bel.txt

## wordforms-bel.txt

Each line represents a single lemma/headword with a list of whitespace separated possible inflections.
Uses UTF-8 format, [U+02BC apostrophes](https://en.wikipedia.org/wiki/Apostrophe#Unicode) and
[U+0301 stress marks](https://en.wikipedia.org/wiki/Acute_accent).

Both this file and the original [GrammarDB](https://github.com/Belarus/GrammarDB) it was
constructed from are licensed under Creative Commons Attribution-ShareAlike 4.0 International License.
