# RowingChampionships_database

## Autor
**Imię Nazwisko:** Olga Rodziewicz  

## Temat projektu
Zawody sportowe, sportowcy, wyniki tych zawodów (na przykładzie Młodzieżowych Mistrzostw Polski w wioślarstwie - MP).  

---

## Opis projektu

### 1.1 Klient
Przewodniczący Komitetu Organizacyjnego z ramienia PZTW (Polski Związek Towarzystw Wioślarskich).  

### 1.2 Cel bazy
Celem bazy jest ułatwienie pracy głównemu sędziemu w przypisywaniu wyścigów sędziom, zapobieganie opóźnieniom oraz organizowanie wyników.  

### 1.3 Problemy klienta
- Brak organizacji zawodów.
- Opóźnienia wyścigów.
- Źle zgłoszone osady.
- Brak transparentności wyników.  

### 1.4 Użytkownicy systemu
- Komitet Organizacyjny.
- Sędzia Główny.
- Sędziowie.
- Trenerzy.
- Zawodnicy i kibice.  

---

## 2. Diagram ERD

![Diagram ERD](img/Erd_final.png)  


---

## 3. Szczegółowy opis encji i relacji

### 3.1 Zawodnik
| Nazwa        | Klucz | Typ      | Opis                                                              |
|--------------|-------|----------|-------------------------------------------------------------------|
| Pesel        | Tak   | INTEGER  | Pesel zawodnika.                                                  |
| Imię         | Nie   | VARCHAR  | Imię zawodnika, zaczyna się od dużej litery, bez znaków specjalnych. |
| Nazwisko     | Nie   | VARCHAR  | Jak wyżej.                                                       |
| Data_urodzenia | Nie   | DATE     | Data urodzenia zawodnika w formacie `YYYY-MM-DD`.                |
| Płeć         | Nie   | CHAR(1)  | Wartości: "M" (mężczyzna), "K" (kobieta).                        |
| Klub         | Nie   | INTEGER  | Odniesienie do klubu (klucz obcy do `Klub`).                     |

### 3.2 Klub
| Nazwa        | Klucz | Typ      | Opis                                                              |
|--------------|-------|----------|-------------------------------------------------------------------|
| skrót_nazwy  | Tak   | CHAR(5)  | Unikalny identyfikator klubu.                                     |
| Pełna_Nazwa  | Nie   | VARCHAR  | Pełna nazwa klubu.                                               |
| Wzór_wioseł  | Nie   | VARCHAR  | Opis koloru i zdobień wioseł.                                    |

### 3.3 Trener
| Nazwa                | Klucz | Typ      | Opis                                                           |
|----------------------|-------|----------|----------------------------------------------------------------|
| nr_licencji_trenera  | Tak   | INTEGER  | Unikalny numer licencji trenera.                              |
| Imię                 | Nie   | VARCHAR  | Imię trenera.                                                 |
| Nazwisko             | Nie   | VARCHAR  | Nazwisko trenera.                                             |
| Klub                 | Nie   | INTEGER  | Odniesienie do klubu, w którym pracuje (klucz obcy do `Klub`). |
| Data_wazności_licencji | Nie   | DATE     | Data ważności licencji trenerskiej.                           |

### 3.4 Sędzia
| Nazwa                | Klucz | Typ      | Opis                                                           |
|----------------------|-------|----------|----------------------------------------------------------------|
| nr_licencji_sędziego | Tak   | INTEGER  | Unikalny numer licencji sędziego.                             |
| Imię                 | Nie   | VARCHAR  | Imię sędziego.                                                |
| Nazwisko             | Nie   | VARCHAR  | Nazwisko sędziego.                                            |
| Data_wazności_licencji | Nie   | DATE     | Data ważności licencji sędziowskiej.                          |

### 3.5 Osada
| Nazwa                  | Klucz | Typ      | Opis                                                           |
|------------------------|-------|----------|----------------------------------------------------------------|
| id_osady               | Tak   | VARCHAR  | Unikalny identyfikator osady.                                 |
| Trener                 | Nie   | INTEGER  | Odniesienie do trenera (klucz obcy do `Trener`).              |
| Łódź                   | Nie   | VARCHAR  | Nazwa łodzi używanej przez osadę.                             |
| Status_opłaty_startowej | Nie   | CHAR(11) | Status płatności: "nieopłacone", "opłacone".                  |

### 3.6 Wyścigi
| Nazwa       | Klucz | Typ       | Opis                                                                 |
|-------------|-------|-----------|----------------------------------------------------------------------|
| nr_wyścigu  | Tak   | INTEGER   | Unikalny identyfikator wyścigu, np. YYMMDDNN.                       |
| data        | Nie   | DATE      | Data wyścigu w formacie `YYYY-MM-DD`.                               |
| sędzia      | Nie   | INTEGER   | Odniesienie do sędziego nadzorującego wyścig (klucz obcy do `Sędzia`). |
| godzina     | Nie   | TIME      | Godzina rozpoczęcia wyścigu w formacie `HH:MM`.                     |
| kategoria   | Nie   | INTEGER   | Odniesienie do kategorii wyścigu (klucz obcy do `Kategorie`).       |
| opis        | Nie   | VARCHAR   | Dodatkowy opis wyścigu, np. "finał", "eliminacje".                  |

### 3.7 Członek Osady
| Nazwa      | Klucz | Typ       | Opis                                                             |
|------------|-------|-----------|------------------------------------------------------------------|
| Zawodnik   | Tak   | INTEGER   | Odniesienie do zawodnika (klucz obcy do `Zawodnik`).             |
| Osada      | Tak   | INTEGER   | Odniesienie do osady (klucz obcy do `Osada`).                   |
| czy_sternik| Nie   | BOOLEAN   | Czy zawodnik pełni rolę sternika w osadzie (wartość logiczna).  |

### 3.8 Zgłoszenie do Wyścigu
| Nazwa                 | Klucz | Typ       | Opis                                                               |
|-----------------------|-------|-----------|--------------------------------------------------------------------|
| Osada                | Tak   | INTEGER   | Odniesienie do osady zgłoszonej do wyścigu (klucz obcy do `Osada`).|
| Wyścig               | Tak   | INTEGER   | Odniesienie do wyścigu, w którym startuje osada (klucz obcy do `Wyścig`). |
| Czy_dopuszczono_do_startu | Nie   | BOOLEAN   | Czy osada spełnia warunki kategorii (np. zgodność płci i liczby zawodników). |

### 3.9 Wyniki
| Nazwa       | Klucz | Typ       | Opis                                                               |
|-------------|-------|-----------|--------------------------------------------------------------------|
| Wyścig      | Tak   | INTEGER   | Odniesienie do wyścigu, w którym uzyskano wynik (klucz obcy do `Wyścig`). |
| Osada       | Tak   | INTEGER   | Odniesienie do osady, która uzyskała wynik (klucz obcy do `Osada`). |
| miejsce     | Nie   | INTEGER   | Pozycja osady w wyścigu (1–8).                                     |
| czas        | Nie   | TIME      | Czas uzyskany przez osadę w wyścigu.                              |

### 3.10 Kategoria
| Nazwa          | Klucz | Typ       | Opis                                                             |
|----------------|-------|-----------|------------------------------------------------------------------|
| symbol         | Tak   | VARCHAR   | Unikalny symbol kategorii, np. "4xKBL".                         |
| nazwa          | Nie   | VARCHAR   | Pełna nazwa kategorii, np. "Czwórka podwójna kobiet w kategorii lekkiej". |
| ilość_osób     | Nie   | INTEGER   | Liczba osób w osadzie startującej w danej kategorii (1, 2, 4, 8).|
| płeć           | Nie   | CHAR(1)   | Płeć zawodników: "M" lub "K".                                   |
| maks_wiek      | Nie   | INTEGER   | Maksymalny wiek zawodników w kategorii.                         |
| wymaga_sternika| Nie   | BOOLEAN   | Czy kategoria wymaga sternika (wartość logiczna).               |

---

## 4. Schemat relacyjnej bazy danych

```sql
KLUB (skrót_nazwy, Pełna_nazwa, Wzór_wioseł)
ZAWODNIK (Pesel, Imię, Nazwisko, Data_urodzenia, Płeć, trenuje REF Klub)
TRENER (nr_licencji_trenera, Imię, Nazwisko, pracuje REF Klub, data_ważności_licencji)
OSADA (id_osady, nadzoruje REF trener, łódź)
CZŁONEK_OSADY (przynależy REF zawodnik, należy do REF Osada, czy sternik)
SĘDZIA (nr_licencji_sędziego, Imię, Nazwisko, data_ważności_licencji)
KATEGORIE (symbol, nazwa, ilość osób, płeć, Maks_wiek, Wymaga_sternika)
WYŚCIG (nr_wyścigu, data, sędziuje REF sędzia, godzina, przypisany do REF Kategoria, opis)
ZGŁOSZENIE_DO_WYSCIGU (zgłasza się REF osada, zgłasza się do REF wyścig, status płatności, Czy_dopuszczono_do_startu)
WYNIKI (uzyskane w REF Wyścig, uzyskane przez REF Osada, miejsce, czas)
```

---

## 5. Podsumowanie

Baza danych dla organizacji zawodów wioślarskich zapewnia uporządkowanie i transparentność, wspomaga pracę organizatorów oraz zawodników. System umożliwia efektywne zarządzanie wszystkimi aspektami zawodów, od rejestracji po wyniki końcowe.

