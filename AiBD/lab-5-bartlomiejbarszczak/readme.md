# Laboratorium Analiza i bazy danych

## Łańcuchy znaków i wyrażenia regularne

## Wprowadzenie

W każdym silniku baz danych istnieją mechanizmy do porównywania, dopasowywania i manipulowania ciągami znaków (*string*).

Oprócz podstawowej funkcjonalności polegającej na odpowiedzi na pytanie „czy ten ciąg pasuje do tego wzoru?" w bazach danych istnieją operatory i funkcje do wyodrębniania, zastępowania i podziałów pasujących podciągów do wzorca podanego przez użytkownika.

Istnieją trzy osobne podejścia do dopasowywania wzorców zapewniane przez PostgreSQL:
- LIKE/ILIKE,
- SIMILAR TO (standard SQL:1999),
- wyrażenia regularne w stylu POSIX.

Ten dokument ma na celu przybliżenie podstawowych funkcji działania na ciągach znakowych w PostgreSQL.

## LIKE/ILIKE

Wyrażenie LIKE zwraca wartość *true*, jeśli ciąg znaków odpowiada dokładnie podanemu wzorcowi. ILIKE natomiast to klauzula umożliwiająca dopasowanie wzorca jednak nie zwraca ona uwagę na wielkość liter. Wyrażeniem przeciwnym jest NOT LIKE lub NOT ILIKE. Składnia tego wyrażenia to:

```sql
string (LIKE\|ILIKE) wzorzec 
```

```sql
string NOT (LIKE\|ILIKE) wzorzec
```

Przy tym typie klauzuli wzorce tworzymy przy użyciu dwóch operatorów: - \_ - zastępuje pojedynczy znak, - % - zastępuje dowolną długość znaków.

#### Przykład:

| Wyrażenie         | Wynik |
|-------------------|------:|
| 'abc' LIKE 'abc'  |  true |
| 'abc' LIKE 'a%'   |  true |
| 'abc' LIKE '*b*'  |  true |
| 'abc' LIKE 'c'    | false |
| 'ABC' ILIKE 'abc' |  true |
| 'ABC' LIKE 'abc'  | false |

Klauzule LIKE/ILIKE można zastąpić operatorami: - \~\~ równoważny do LIKE - ~~\* równoważny do ILIKE\
- !~~ równoważny do LIKE\
- !\~\~\* równoważny do NOT ILIKE

## SIMILAR TO

Klauzula SIMILAR TO tak samo jak LIKE/ILIKE zwraca wartość *true* lub *false* w zależności od tego, czy podany wzorzec pasuje do podanego ciągu. Różnica pomiędzy tymi operatorami polega na tym, że SIMILAR TO interpretuje wzorzec za pomocą definicji wyrażenia regularnego w standardzie SQL. Wyrażenia regularne SQL są połączeniem notacji LIKE i zwykłej notacji wyrażeń regularnych (POSIX).

Składnia tego zapytania ma postać:

```sql
string SIMILAR TO wzorzec
```

```sql
string NOT SIMILAR TO wzorzec
```

Oprócz funkcji zapożyczonych z LIKE, SIMILAR TO obsługuje te metaznaki pasujące do wzorca zapożyczone z wyrażeń regularnych POSIX:

-   \| - oznacza naprzemienność (jedną z dwóch alternatyw).
-   \* - oznacza powtórzenie poprzedniego elementu zero lub więcej razy.
-   \+ - oznacza powtórzenie poprzedniego elementu jeden lub więcej razy.
-   ? - oznacza powtórzenie poprzedniego elementu zero lub jeden raz.
-   {m} - oznacza powtórzenie poprzedniego elementu dokładnie m razy.
-   {m,} - oznacza powtórzenie poprzedniego elementu m lub więcej razy.
-   {m, n} - oznacza powtórzenie poprzedniego elementu co najmniej mi nie więcej niż n razy.

Nawiasów () można używać do grupowania elementów w jeden element logiczny. Wyrażenie w nawiasie $$...$$ określa klasę znaków, podobnie jak w wyrażeniach regularnych POSIX.

| Wyrażenie                   | Wynik |
|-----------------------------|------:|
| 'abc' SIMILAR TO 'abc'      |  true |
| 'abc' SIMILAR TO 'a'        | false |
| 'abc' SIMILAR TO '%(b\|d)%' |  true |
| 'abc' SIMILAR TO '(b\|c)%'  | false |

## Składnia POSIX

Wyrażenia regularne POSIX zapewniają więcej reguł tworzenia wzorców niż operatory LIKE i SIMILAR TO. Wiele narzędzi uniksowych, takich jak grep, sed lub awk, używa języka dopasowywania wzorców podobnego do tego używanego w PostgreSQL.

Wyrażenie regularne to opis ciągu znaków przy użyciu symboli w celu utworzenia wzorca ciągu, która umożliwia dopasowanie wzorców. Mówi się, że łańcuch pasuje do wyrażenia regularnego, jeśli jest on członkiem zbioru regularnego opisanego przez wyrażenie regularne. Podobnie jak w przypadku LIKE, znaki wzorcowe dokładnie pasują do znaków łańcuchowych, chyba że są znakami specjalnymi w języku wyrażeń regularnych - ale wyrażenia regularne używają innych znaków specjalnych niż LIKE. W przeciwieństwie do wzorców LIKE, wyrażenie regularne może pasować w dowolnym miejscu ciągu, chyba że wyrażenie regularne jest wyraźnie zakotwiczone na początku (\^) lub na końcu łańcucha (\$).

Używanie tego rodzaju dopasowania ciągu znaków odbywa się przez operatory:

-   \~ pasuje do wzorca , wielkość liter ma znaczenie
-   \~\* pasuje do wzorca , wielkość liter nie ma znaczenie\
-   !\~ nie pasuje do wzorca , wielkość liter ma znaczenie\
-   !\~\* nie pasuje do wzorca , wielkość liter nie ma znaczenie

#### Przykład:

| Wyrażenie           | Wynik |
|---------------------|------:|
| 'abc' \~ 'abc'      |  true |
| 'abc' \~ '\^a'      |  true |
| 'abc' \~ '(b\|d)'   |  true |
| 'abc' \~ '\^(b\|c)' | false |

Język zapytań regularnych w PostgreSQL który będzie omawiany na zajęciach składa się z:

| Wzorzec | Dopasowanie                                                              |
|------------------------------------|------------------------------------|
| \*      | sekwencja 0 lub więcej dopasowań atomu                                   |
| \+      | sekwencja 1 lub więcej dopasowań atomu                                   |
| ?       | sekwencja 0 lub 1 dopasowań atomu                                        |
| {m.}    | sekwencja dokładnie m dopasowań atomu                                    |
| {m,}    | sekwencja m lub więcej dopasowań atomu                                   |
| {m, n}  | sekwencja od m do n (włącznie) dopasowań atomu; m nie może przekraczać n |
| \^      | dopasuj od początku łańcucha znaków                                      |
| \$      | dopasuj od końca łańcucha znaków                                         |

Formularze używające {...} są znane jako granice. Liczby min w granicach są liczbami całkowitymi dziesiętnymi bez znaku z dopuszczalnymi wartościami od 0 do 255 włącznie.

Pełny opis omawianych funkcjonalności dostępny jest w [dokumentacji PostgreSQL](https://www.postgresql.org/docs/9.3/functions-matching.html)

## Wybrane funkcje działające na znakach

Poza funkcją dopasowania w PostgreSQL istnieje również szereg funkcji predefiniowanych niepozwalających działanie ciągach znaków. W poniższej tabeli przedstawiono wybrane funkcje:

| Funkcja        | Opis                                                                                                      |                      Przykład                      |              Wynik |
|:-----------------|:-----------------|:-----------------:|-----------------:|
| ASCII          | Zwraca wartość kodu ASCII znaku lub punktu kodu Unicode znaku UTF8<br><br>                                |                    ASCII ('A')                     |                 65 |
| CHR            | Konwertuj kod ASCII na znak lub punkt kodu Unicode na znak UTF8<br><br>                                   |                      CHR (65)                      |                'A' |
| CONCAT         | Połączenie dwóch lub więcej ciągów w jeden<br><br>                                                        |               CONCAT('A', 'B', 'C')                |              'ABC' |
| CONCAT_WS      | Połączenie ciągów znaków z separatorem<br><br>                                                            |           CONCAT_WS(',', 'A', 'B', 'C')            |          'A, B, C' |
| FORMAT         | Łącznie ciągów zgodnie z zadanym wzorcem formatowania<br><br>                                             |          FORMAT('Witaj% s', 'PostgreSQL')          | 'Witaj PostgreSQL' |
| INITCAP        | Konwertuj łańcuch znaków w styl nagłówka<br><br>                                                          |                INITCAP('CZEść wAM')                |        "Cześć Wam" |
| LEFT           | Zwraca pierwszy n znaku z lewej strony ciągu<br><br>                                                      |                   LEFT('ABC', 1)                   |                'A' |
| LENGTH         | Zwraca liczbę znaków w ciągu<br><br>                                                                      |                   LENGTH('ABC')                    |                  3 |
| LOWER          | Konwertuj ciąg na małe litery<br><br>                                                                     |                LOWER ('czEŚĆ wAM')                 |        'cześć wam' |
| LPAD           | Uzupełnieni z lewej strony ciągu do zadanej długości zadanym ciągiem<br><br>                              |                LPAD('123', 5, '00')                |            '00123' |
| LTRIM          | Usuwanie najdłuższego ciąg zawierającego określone znaki z lewej strony ciągu wejściowego<br><br>         |                  LTRIM ('00123')                   |              '123' |
| MD5            | Zwraca skrót MD5 ciągu szesnastkowego<br><br>                                                             |                     MD5('ABC')                     |                    |
| POSITION       | Zwraca lokalizację pod łańcucha w ciągu<br><br>                                                           |               POSTION('B' w 'A B C')               |                  3 |
| REGEXP_MATCHES | Dopasuj wyrażenie regularne POSIX do łańcucha i zwraca pasujące podciągi<br><br>                          |    REGEXP_MATCHES ('ABC', '\^(A)(..)\$', 'g');     |              {ABC} |
| REGEXP_REPLACE | Zamienia podciągi pasujące do wyrażenia regularnego POSIX na nowy podciąg<br><br>                         | REGEXP_REPLACE ('John Doe','(.*)(.*)','\\2, \\1′); |        'Doe, John' |
| REPEAT         | Powtarza ciąg określoną liczbę razy<br><br>                                                               |                  REPEAT('\*', 5)                   |       '\*\*\*\*\*' |
| REPLACE        | Zamienia wszystkie wystąpienia w ciągu pod łańcucha z podciągu na zadany <br><br>REPLACE('ABC', 'B', 'A') |                       'AAC'                        |                    |
| REVERSE        | Odwrócenie ciągu<br><br>                                                                                  |               REVERSE ('ABC') 'CBA'                |                    |
| RIGHT          | Zwraca ostatnie n znaków w ciągu. Kiedy n jest ujemne, zwracaj wszystkie oprócz pierwszego<br><br>        |                  RIGHT('ABC', 2)                   |               'BC' |
| RPAD           | Uzupełnieni z prawej strony ciągu do zadanej długości zadanym ciągiem<br><br>                             |                RPAD('ABC', 6, 'xo')                |           'ABCxox' |
| RTRIM          | Usuwa najdłuższy ciąg zawierający określone znaki z prawej strony ciągu wejściowego<br><br>               |              RTRIM 'abcxxzx', 'xyz')               |              'abc' |
| SPLIT_PART     | Dzieli ciąg na określonym ograniczniku i zwraca n-ty pod łańcuch<br><br>                                  |          SPLIT_PART('2017-12-31′,'-', 2)           |               '12' |
| SUBSTRING      | Wyodrębnia podciąg z ciągu<br><br>                                                                        |               SUBSTRING('ABC', 1,1)                |                'A' |
| TRIM           | Usuwa najdłuższy ciąg zawierający określone znaki z lewej, prawej lub obu ciągów wejściowych<br><br>      |                    TRIM('ABC')                     |              'ABC' |
| UPPER          | Konwertuje ciąg na wielkie litery<br><br>                                                                 |                 UPPER('CZEść wAM')                 |        'CZEŚĆ WAM' |

## Testy jednostkowe

Testy są skonstuowane tak by uruchamiały się za każdym razem gdy uruchamia się skrypt main.R. Z tego powodu nie można w nim edytować lini kodu które znajdują się pomiędzy znacznikami:

``` r
# NIE EDYTOWAĆ *****************************************************************
...
# ******************************************************************************
```

Dodatkowo w obszarza zabronionym do edycji znajduje się połączenie do bazy danych które możńa używać w funkcjach do wykonania. Zabronine jest również przeprowadzanie zmian w katalogu **tests** i wszystkich podkatalogach.

## Zadania:

1.  Znajdź wszystkie nazwy krajów rozpoczynających się na P.
2.  Znajdź wszystkie nazwy krajów rozpoczynających się P i kończących na s.
3.  Znajdź wszystkie tytuły filmów, w których znajdują się cyfry.
4.  Znajdź wszystkich pracowników z podwójnym imieniem lub nazwiskiem.
5.  Znajdź wszystkie nazwiska aktorów rozpoczynających się od P lub C i mających 5 znaków.
6.  Znajdź wszystkie tytuły filmów, w których występują słowa Trip lub Alone.
7.  Przeanalizuj zapytania:
    -   select first_name from actor where first_name \~ '\^Al[a:z,1:9]\*'
    -   select first_name from actor where first_name \~\* '\^al[a:z,1:9]\*'
