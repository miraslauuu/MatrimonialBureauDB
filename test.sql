    /************************************************************
      Wypełnianie tabel danymi oraz testowanie przyjętych założeń
     ************************************************************/
     
     
     
         /************************************************************
                            DODAWANIE KLIENTÓW
     ************************************************************/

BEGIN
    -- Jan Kowalski
    PakietBiuro.dodaj_klienta(
        p_osoba_id       => 1,
        p_imie           => 'Jan',
        p_nazwisko       => 'Kowalski',
        p_data_ur        => DATE '1990-01-01',
        p_ulica          => 'Główna',
        p_nr_domu        => '10',
        p_nr_mieszkania  => NULL,
        p_kod_pocztowy   => '00-001',
        p_miasto         => 'Warszawa',
        p_status         => 'aktywny',
        p_preferencje    => 'kino, spacery, wysoka, blondynka',
        p_cechy          => 'kino, spacery, wysoki, brunet',
        p_plec           => 'mezczyzna',
        p_orientacja_seksualna => 'kobieta',
        p_min_wiek       => 25,
        p_max_wiek       => 35
    );
END;
/

BEGIN
    -- Anna Nowak
    PakietBiuro.dodaj_klienta(
        p_osoba_id       => 2,
        p_imie           => 'Anna',
        p_nazwisko       => 'Nowak',
        p_data_ur        => DATE '1992-03-15',
        p_ulica          => 'Zielona',
        p_nr_domu        => '5',
        p_nr_mieszkania  => '12',
        p_kod_pocztowy   => '00-002',
        p_miasto         => 'Kraków',
        p_status         => 'premium',
        p_preferencje    => 'sport, książki, wysoki, brunet',
        p_cechy          => 'sport, książki, wysoka, blondynka',
        p_plec           => 'kobieta',
        p_orientacja_seksualna => 'mezczyzna',
        p_min_wiek       => 25,
        p_max_wiek       => 35
    );
END;
/

BEGIN
    -- Marek Wiśniewski
    PakietBiuro.dodaj_klienta(
        p_osoba_id       => 3,
        p_imie           => 'Marek',
        p_nazwisko       => 'Wiśniewski',
        p_data_ur        => DATE '1985-07-20',
        p_ulica          => 'Lipowa',
        p_nr_domu        => '8',
        p_nr_mieszkania  => NULL,
        p_kod_pocztowy   => '00-003',
        p_miasto         => 'Łódź',
        p_status         => 'aktywny',
        p_preferencje    => 'muzyka, ambitna, blondynka',
        p_cechy          => 'muzyka, ambitny, brunet',
        p_plec           => 'mezczyzna',
        p_orientacja_seksualna => 'kobieta',
        p_min_wiek       => 30,
        p_max_wiek       => 40
    );
END;
/

BEGIN
    -- Ewa Kamińska
    PakietBiuro.dodaj_klienta(
        p_osoba_id       => 4,
        p_imie           => 'Ewa',
        p_nazwisko       => 'Kamińska',
        p_data_ur        => DATE '1995-09-10',
        p_ulica          => 'Brzozowa',
        p_nr_domu        => '2',
        p_nr_mieszkania  => '3',
        p_kod_pocztowy   => '00-004',
        p_miasto         => 'Gdańsk',
        p_status         => 'aktywny',
        p_preferencje    => 'podróże, ambitny, brunet',
        p_cechy          => 'podróże, ambitna, blondynka',
        p_plec           => 'kobieta',
        p_orientacja_seksualna => 'mezczyzna',
        p_min_wiek       => 20,
        p_max_wiek       => 30
    );
END;
/

BEGIN
    -- Piotr Lewandowski
    PakietBiuro.dodaj_klienta(
        p_osoba_id       => 5,
        p_imie           => 'Piotr',
        p_nazwisko       => 'Lewandowski',
        p_data_ur        => DATE '1987-12-25',
        p_ulica          => 'Topolowa',
        p_nr_domu        => '15',
        p_nr_mieszkania  => '8',
        p_kod_pocztowy   => '00-005',
        p_miasto         => 'Wrocław',
        p_status         => 'premium',
        p_preferencje    => 'kawa, fotografia, blondynka',
        p_cechy          => 'kawa, fotografia, brunet',
        p_plec           => 'mezczyzna',
        p_orientacja_seksualna => 'kobieta',
        p_min_wiek       => 28,
        p_max_wiek       => 38
    );
END;
/

BEGIN
    -- Alicja Wójcik
    PakietBiuro.dodaj_klienta(
        p_osoba_id       => 6,
        p_imie           => 'Alicja',
        p_nazwisko       => 'Wójcik',
        p_data_ur        => DATE '1990-11-05',
        p_ulica          => 'Jesionowa',
        p_nr_domu        => '3',
        p_nr_mieszkania  => NULL,
        p_kod_pocztowy   => '00-006',
        p_miasto         => 'Poznań',
        p_status         => 'aktywny',
        p_preferencje    => 'muzyka, ambitny, brunet',
        p_cechy          => 'muzyka, ambitna, blondynka',
        p_plec           => 'kobieta',
        p_orientacja_seksualna => 'mezczyzna',
        p_min_wiek       => 25,
        p_max_wiek       => 35
    );
END;
/
BEGIN
    -- Tomasz Zieliński
    PakietBiuro.dodaj_klienta(
        p_osoba_id       => 7,
        p_imie           => 'Tomasz',
        p_nazwisko       => 'Zieliński',
        p_data_ur        => DATE '1994-06-18',
        p_ulica          => 'Dębowa',
        p_nr_domu        => '12',
        p_nr_mieszkania  => '5',
        p_kod_pocztowy   => '00-007',
        p_miasto         => 'Szczecin',
        p_status         => 'premium',
        p_preferencje    => 'książki, spacery, ambitna, blondynka',
        p_cechy          => 'książki, spacery, ambitny, brunet',
        p_plec           => 'mezczyzna',
        p_orientacja_seksualna => 'kobieta',
        p_min_wiek       => 30,
        p_max_wiek       => 40
    );
END;
/

BEGIN
    -- Karolina Szymańska
    PakietBiuro.dodaj_klienta(
        p_osoba_id       => 8,
        p_imie           => 'Karolina',
        p_nazwisko       => 'Szymańska',
        p_data_ur        => DATE '1997-04-02',
        p_ulica          => 'Grabowa',
        p_nr_domu        => '7',
        p_nr_mieszkania  => NULL,
        p_kod_pocztowy   => '00-008',
        p_miasto         => 'Bydgoszcz',
        p_status         => 'aktywny',
        p_preferencje    => 'bieganie, ambitny, brunet',
        p_cechy          => 'bieganie, ambitna, blondynka',
        p_plec           => 'kobieta',
        p_orientacja_seksualna => 'mezczyzna',
        p_min_wiek       => 22,
        p_max_wiek       => 32
    );
END;
/

BEGIN
    -- Jakub Dąbrowski
    PakietBiuro.dodaj_klienta(
        p_osoba_id       => 9,
        p_imie           => 'Jakub',
        p_nazwisko       => 'Dąbrowski',
        p_data_ur        => DATE '1993-02-10',
        p_ulica          => 'Świerkowa',
        p_nr_domu        => '4',
        p_nr_mieszkania  => '6',
        p_kod_pocztowy   => '00-009',
        p_miasto         => 'Katowice',
        p_status         => 'aktywny',
        p_preferencje    => 'kino, sport, wysoka, blondynka',
        p_cechy          => 'kino, sport, wysoki, brunet',
        p_plec           => 'mezczyzna',
        p_orientacja_seksualna => 'kobieta',
        p_min_wiek       => 27,
        p_max_wiek       => 37
    );
END;
/

BEGIN
    -- Magdalena Baran
    PakietBiuro.dodaj_klienta(
        p_osoba_id       => 10,
        p_imie           => 'Magdalena',
        p_nazwisko       => 'Baran',
        p_data_ur        => DATE '1988-08-12',
        p_ulica          => 'Wrzosowa',
        p_nr_domu        => '6',
        p_nr_mieszkania  => '2',
        p_kod_pocztowy   => '00-010',
        p_miasto         => 'Lublin',
        p_status         => 'aktywny',
        p_preferencje    => 'taniec, kawa, ambitny, brunet',
        p_cechy          => 'taniec, kawa, ambitna, blondynka',
        p_plec           => 'kobieta',
        p_orientacja_seksualna => 'mezczyzna',
        p_min_wiek       => 26,
        p_max_wiek       => 36
    );
END;
/

BEGIN
    -- Paweł Sikora
    PakietBiuro.dodaj_klienta(
        p_osoba_id       => 11,
        p_imie           => 'Paweł',
        p_nazwisko       => 'Sikora',
        p_data_ur        => DATE '1991-10-22',
        p_ulica          => 'Różana',
        p_nr_domu        => '9',
        p_nr_mieszkania  => NULL,
        p_kod_pocztowy   => '00-011',
        p_miasto         => 'Rzeszów',
        p_status         => 'premium',
        p_preferencje    => 'muzyka, sport, ambitna, blondynka',
        p_cechy          => 'muzyka, sport, ambitny, brunet',
        p_plec           => 'mezczyzna',
        p_orientacja_seksualna => 'kobieta',
        p_min_wiek       => 28,
        p_max_wiek       => 38
    );
END;
/

BEGIN
    -- Olga Rutkowska
    PakietBiuro.dodaj_klienta(
        p_osoba_id       => 12,
        p_imie           => 'Olga',
        p_nazwisko       => 'Rutkowska',
        p_data_ur        => DATE '1996-05-14',
        p_ulica          => 'Magnoliowa',
        p_nr_domu        => '11',
        p_nr_mieszkania  => '4',
        p_kod_pocztowy   => '00-012',
        p_miasto         => 'Białystok',
        p_status         => 'aktywny',
        p_preferencje    => 'fotografia, podróże, ambitny, brunet',
        p_cechy          => 'fotografia, podróże, ambitna, blondynka',
        p_plec           => 'kobieta',
        p_orientacja_seksualna => 'mezczyzna',
        p_min_wiek       => 24,
        p_max_wiek       => 34
    );
END;
/

BEGIN
    -- Wojciech Czarnecki
    PakietBiuro.dodaj_klienta(
        p_osoba_id       => 13,
        p_imie           => 'Wojciech',
        p_nazwisko       => 'Czarnecki',
        p_data_ur        => DATE '1990-03-03',
        p_ulica          => 'Akacjowa',
        p_nr_domu        => '14',
        p_nr_mieszkania  => '1',
        p_kod_pocztowy   => '00-013',
        p_miasto         => 'Gdynia',
        p_status         => 'aktywny',
        p_preferencje    => 'sport, bieganie, ambitna, blondynka',
        p_cechy          => 'sport, bieganie, ambitny, brunet',
        p_plec           => 'mezczyzna',
        p_orientacja_seksualna => 'kobieta',
        p_min_wiek       => 30,
        p_max_wiek       => 40
    );
END;
/
BEGIN
    -- Adam Kowalczyk
    PakietBiuro.dodaj_klienta(
        p_osoba_id       => 14,
        p_imie           => 'Adam',
        p_nazwisko       => 'Kowalczyk',
        p_data_ur        => DATE '1995-05-25',
        p_ulica          => 'Pogodna',
        p_nr_domu        => '10',
        p_nr_mieszkania  => '4',
        p_kod_pocztowy   => '00-014',
        p_miasto         => 'Gdynia',
        p_status         => 'aktywny',
        p_preferencje    => 'bieganie, ambitny, brunet',
        p_cechy          => 'bieganie, ambitny, brunet',
        p_plec           => 'mezczyzna',
        p_orientacja_seksualna => 'obojetnie',
        p_min_wiek       => 25,
        p_max_wiek       => 35
    );
END;
/

BEGIN
    -- Krzysztof Malinowski
    PakietBiuro.dodaj_klienta(
        p_osoba_id       => 15,
        p_imie           => 'Krzysztof',
        p_nazwisko       => 'Malinowski',
        p_data_ur        => DATE '1993-03-12',
        p_ulica          => 'Cicha',
        p_nr_domu        => '7',
        p_nr_mieszkania  => NULL,
        p_kod_pocztowy   => '00-015',
        p_miasto         => 'Poznań',
        p_status         => 'aktywny',
        p_preferencje    => 'bieganie, ambitna, blondynka',
        p_cechy          => 'bieganie, ambitny, brunet',
        p_plec           => 'mezczyzna',
        p_orientacja_seksualna => 'obojetnie',
        p_min_wiek       => 25,
        p_max_wiek       => 35
    );
END;
/
BEGIN
    -- Wladyslaw Doronczenkow
    PakietBiuro.dodaj_klienta(
        p_osoba_id       => 16,
        p_imie           => 'Wladyslaw',
        p_nazwisko       => 'Doronczenkow',
        p_data_ur        => DATE '1900-01-12',
        p_ulica          => 'Bialoruska',
        p_nr_domu        => '69',
        p_nr_mieszkania  => NULL,
        p_kod_pocztowy   => '00-013',
        p_miasto         => 'Kyiw',
        p_status         => 'aktywny',
        p_preferencje    => 'spanie, jedzenie, lysy',
        p_cechy          => 'spanie, jedzenie, lysy',
        p_plec           => 'trans',
        p_orientacja_seksualna => 'kobieta',
        p_min_wiek       => 69,
        p_max_wiek       => 100
    );
END;
/

BEGIN
    -- Próba dodania klienta z przyszłą datą urodzenia (powinien został zgłoszony ERROR)
    PakietBiuro.dodaj_klienta(
        p_osoba_id       => 17,
        p_imie           => 'Przyszły',
        p_nazwisko       => 'Klient',
        p_data_ur        => SYSDATE + 1,  -- Data w przyszłosci!
        p_ulica          => 'Fikcyjna',
        p_nr_domu        => '1',
        p_nr_mieszkania  => NULL,
        p_kod_pocztowy   => '00-999',
        p_miasto         => 'Nieznane',
        p_status         => 'aktywny',
        p_preferencje    => 'brak'
    );
END;
/
     
         /************************************************************
                            WYŚWIETLANIE WSZYSTKICH KLIENTÓW
     ************************************************************/

DECLARE
    v_cursor PakietBiuro.refCursorKlient;
    v_klient TypKlient;
BEGIN
    v_cursor := PakietBiuro.pobierz_klientow;

    LOOP
        FETCH v_cursor INTO v_klient;
        EXIT WHEN v_cursor%NOTFOUND;

        DBMS_OUTPUT.PUT_LINE(v_klient.pelne_dane);
    END LOOP;

    CLOSE v_cursor;
END;
/
BEGIN
    -- Wyświetlenie danych istniejącego klienta
    PakietBiuro.wyswietl_klienta(p_osoba_id => 1);

    -- Próba wyświetlenia nieistniejącego klienta
    PakietBiuro.wyswietl_klienta(p_osoba_id => 999);
END;
/
     
         /************************************************************
                            OBSŁUGA OPIEKUNÓW
     ************************************************************/

BEGIN
    PakietBiuro.dodaj_opiekuna(
        p_opiekun_id => 1,
        p_imie       => 'Magdalena',
        p_nazwisko   => 'Kowalska'
    );

END;
/


BEGIN
    PakietBiuro.dodaj_opiekuna(
        p_opiekun_id => 2,
        p_imie       => 'Marcin',
        p_nazwisko   => 'Opiekun'
    );

    -- Próba przypisania nieistniejącego klienta
    PakietBiuro.dodaj_klienta_do_opiekuna(p_opiekun_id => 2, p_osoba_id => 999);
END;
/
DECLARE
    v_cursor PakietBiuro.refCursorOpiekun;
    v_opiekun TypOpiekun;
BEGIN
    v_cursor := PakietBiuro.pobierz_opiekunow;

    LOOP
        FETCH v_cursor INTO v_opiekun;
        EXIT WHEN v_cursor%NOTFOUND;

        DBMS_OUTPUT.PUT_LINE(v_opiekun.pokaz_opiekuna);
    END LOOP;

    CLOSE v_cursor;
END;
/
BEGIN
    PakietBiuro.dodaj_klienta_do_opiekuna(
        p_opiekun_id => 1,
        p_osoba_id   => 1
    );
END;
/
BEGIN
    PakietBiuro.dodaj_klienta_do_opiekuna(
        p_opiekun_id => 1,
        p_osoba_id   => 2
    );
END;
/
BEGIN
    PakietBiuro.dodaj_klienta_do_opiekuna(
        p_opiekun_id => 2,
        p_osoba_id   => 4
    );
END;
/
BEGIN
    PakietBiuro.dodaj_klienta_do_opiekuna(
        p_opiekun_id => 1,
        p_osoba_id   => 5
    );
END;
/
BEGIN
    PakietBiuro.dodaj_klienta_do_opiekuna(
        p_opiekun_id => 2,
        p_osoba_id   => 6
    );
END;
/
BEGIN
    PakietBiuro.dodaj_klienta_do_opiekuna(
        p_opiekun_id => 2,
        p_osoba_id   => 7
    );
END;
/
BEGIN
    PakietBiuro.dodaj_klienta_do_opiekuna(
        p_opiekun_id => 2,
        p_osoba_id   => 8
    );
END;
/
BEGIN
    PakietBiuro.dodaj_klienta_do_opiekuna(
        p_opiekun_id => 1,
        p_osoba_id   => 9
    );
END;
/
BEGIN
    PakietBiuro.dodaj_klienta_do_opiekuna(
        p_opiekun_id => 2,
        p_osoba_id   => 10
    );
END;
/
BEGIN
    PakietBiuro.dodaj_klienta_do_opiekuna(
        p_opiekun_id => 1,
        p_osoba_id   => 11
    );
END;
/
BEGIN
    PakietBiuro.dodaj_klienta_do_opiekuna(
        p_opiekun_id => 2,
        p_osoba_id   => 12
    );
END;
/
BEGIN
    PakietBiuro.dodaj_klienta_do_opiekuna(
        p_opiekun_id => 1,
        p_osoba_id   => 13
    );
END;
/


BEGIN
    PakietBiuro.dodaj_klienta_do_opiekuna(
        p_opiekun_id => 1,
        p_osoba_id   => 14
    );
END;
/

BEGIN
    PakietBiuro.dodaj_klienta_do_opiekuna(
        p_opiekun_id => 1,
        p_osoba_id   => 15
    );
END;
/

BEGIN
    PakietBiuro.dodaj_klienta_do_opiekuna(
        p_opiekun_id => 2,
        p_osoba_id   => 16
    );
END;
/
BEGIN
    PakietBiuro.pokaz_podopiecznych(1);
END;
/
BEGIN
    PakietBiuro.pokaz_podopiecznych(2);
END;
/
     
         /************************************************************
                            OBSŁUGA PROCESU MATCH-MAKING
     ************************************************************/


DECLARE
    v_cursor PakietBiuro.refCursorKlient;
    v_klient TypKlient;
BEGIN
    PakietBiuro.znajdz_pare(
        p_osoba_id => 7,
        p_wynik    => v_cursor
    );

    LOOP
        FETCH v_cursor INTO v_klient;
        EXIT WHEN v_cursor%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE('Znaleziono klienta: ' || v_klient.pelne_dane);
    END LOOP;

    CLOSE v_cursor;
END;
/

DECLARE
    v_cursor PakietBiuro.refCursorKlient;
    v_klient TypKlient;
BEGIN
    -- Znajdź pary dla klienta o ID=16
    PakietBiuro.znajdz_pare(
        p_osoba_id => 16,
        p_wynik    => v_cursor
    );
    
    -- Dla tego klienta nie ma pary
    LOOP
        FETCH v_cursor INTO v_klient;
        EXIT WHEN v_cursor%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE('Znaleziono klienta: ' || v_klient.pelne_dane);
    END LOOP;

    CLOSE v_cursor;
END;
/

DECLARE
    v_cursor PakietBiuro.refCursorKlient;
    v_klient TypKlient;
BEGIN
    PakietBiuro.wyszukaj_klienta_po_cechach(
        p_cechy_zadane => 'wysoki, brunet',
        p_wynik        => v_cursor
    );

    LOOP
        FETCH v_cursor INTO v_klient;
        EXIT WHEN v_cursor%NOTFOUND;

        DBMS_OUTPUT.PUT_LINE('Znaleziono klienta: ' || v_klient.pelne_dane);
    END LOOP;

    CLOSE v_cursor;
END;
/
     
         /************************************************************
                        USTALANIE RANDEK I WYSTAWIANIA OPINII
     ************************************************************/

BEGIN
    -- Próba dodania randki z tym samym klientem (powinien został zgloszony ERROR)
    PakietBiuro.dodaj_randke(
        p_randka_id      => 2,
        p_data_spotkania => SYSDATE + 1,
        p_miejsce        => 'Park',
        p_klient1_id     => 1,
        p_klient2_id     => 1
    );
END;
/

BEGIN
    PakietBiuro.dodaj_randke(
        p_randka_id      => 2, -- Unikalne ID randki
        p_data_spotkania => SYSDATE + 7, -- Data randki (za 7 dni)
        p_miejsce        => 'Restauracja',
        p_klient1_id     => 1, -- ID pierwszego klienta
        p_klient2_id     => 6  -- ID drugiego klienta
    );
    DBMS_OUTPUT.PUT_LINE('Randka została dodana.');
END;
/

DECLARE
    v_cursor     PakietBiuro.refCursorRandka;
    v_randka     TypRandka;    -- obiekt randki
    v_klient1    TypKlient;    -- obiekt pierwszego klienta
    v_klient2    TypKlient;    -- obiekt drugiego klienta
BEGIN
    v_cursor := PakietBiuro.pobierz_randki;

    LOOP
        FETCH v_cursor INTO v_randka;
        EXIT WHEN v_cursor%NOTFOUND;  

        DBMS_OUTPUT.PUT_LINE('=== R A N D K A ===');
        DBMS_OUTPUT.PUT_LINE(v_randka.opis);

        SELECT DEREF(v_randka.klient1_ref)
          INTO  v_klient1
          FROM  DUAL;

        DBMS_OUTPUT.PUT_LINE('Klient1: ' 
            || v_klient1.imie || ' '
            || v_klient1.nazwisko
        );

        SELECT DEREF(v_randka.klient2_ref)
          INTO  v_klient2
          FROM  DUAL;

        DBMS_OUTPUT.PUT_LINE('Klient2: ' 
            || v_klient2.imie || ' '
            || v_klient2.nazwisko
        );

        DBMS_OUTPUT.PUT_LINE('--------------------');
    END LOOP;

    CLOSE v_cursor;
END;

/


BEGIN
    PakietBiuro.dodaj_opinie(
        p_randka_id => 1,  
        p_klient_id => 1,  
        p_ocena     => 1, 
        p_komentarz => 'Spotkanie było rozczarowujące, brak chemii.'

    );
    DBMS_OUTPUT.PUT_LINE('Opinia klienta 1 została dodana.');
END;
/
BEGIN
    PakietBiuro.dodaj_opinie(
        p_randka_id => 1, 
        p_klient_id => 2, 
        p_ocena     => 5,  
        p_komentarz => 'Świetne spotkanie, bardzo miła osoba!'
    );
    DBMS_OUTPUT.PUT_LINE('Opinia klienta 6 została dodana.');
END;
/


BEGIN
    PakietBiuro.dodaj_opinie(
        p_randka_id => 2,  
        p_klient_id => 1, 
        p_ocena     => 5,  
        p_komentarz => 'Spotkanie było super'

    );
    DBMS_OUTPUT.PUT_LINE('Opinia klienta 1 została dodana.');
END;
/
BEGIN
    PakietBiuro.dodaj_opinie(
        p_randka_id => 2, 
        p_klient_id => 6,  
        p_ocena     => 5,  
        p_komentarz => 'Świetne spotkanie, bardzo miła osoba!'
    );
    DBMS_OUTPUT.PUT_LINE('Opinia klienta 6 została dodana.');
END;
/
BEGIN
    PakietBiuro.dodaj_randke(
        p_randka_id      => 3, -- Unikalne ID randki
        p_data_spotkania => SYSDATE + 7, -- Data randki (za 7 dni)
        p_miejsce        => 'Restauracja',
        p_klient1_id     => 7, -- ID pierwszego klienta
        p_klient2_id     => 10  -- ID drugiego klienta
    );
    DBMS_OUTPUT.PUT_LINE('Randka została dodana.');
END;
/
BEGIN
    PakietBiuro.dodaj_opinie(
        p_randka_id => 3, 
        p_klient_id => 7,  
        p_ocena     => 5,  
        p_komentarz => 'Spotkanie było super'

    );
    DBMS_OUTPUT.PUT_LINE('Opinia klienta 1 została dodana.');
END;
/
BEGIN
    PakietBiuro.dodaj_opinie(
        p_randka_id => 3, 
        p_klient_id => 10, 
        p_ocena     => 5,  
        p_komentarz => 'Świetne spotkanie, bardzo miła osoba!'
    );
    DBMS_OUTPUT.PUT_LINE('Opinia klienta 6 została dodana.');
END;
/
DECLARE
    v_cursor PakietBiuro.refCursorRandka;
    v_randka TypRandka;
BEGIN
    v_cursor := PakietBiuro.pobierz_randki;

    LOOP
        FETCH v_cursor INTO v_randka;
        EXIT WHEN v_cursor%NOTFOUND;

        DBMS_OUTPUT.PUT_LINE(v_randka.opis);
    END LOOP;

    CLOSE v_cursor;
END;
/

DECLARE
    v_cursor  PakietBiuro.refCursorRandka;
    
    TYPE randkaRec IS RECORD (
        randka_id      NUMBER,
        data_spotkania DATE,
        miejsce        VARCHAR2(100),
        klient1        VARCHAR2(200),
        klient2        VARCHAR2(200),
        ocena          NUMBER,
        komentarz      CLOB
    );
    
    v_randka randkaRec;  
BEGIN
    PakietBiuro.historia_randek(
        p_klient_id => 1,
        p_wynik     => v_cursor
    );

    LOOP
        FETCH v_cursor INTO 
              v_randka.randka_id,
              v_randka.data_spotkania,
              v_randka.miejsce,
              v_randka.klient1,
              v_randka.klient2,
              v_randka.ocena,
              v_randka.komentarz;
        EXIT WHEN v_cursor%NOTFOUND;

        DBMS_OUTPUT.PUT_LINE(
            'Randka ID=' || v_randka.randka_id
            || ', data=' || TO_CHAR(v_randka.data_spotkania, 'YYYY-MM-DD')
            || ', miejsce=' || v_randka.miejsce
            || ', klient1=' || v_randka.klient1
            || ', klient2=' || v_randka.klient2
            || ', ocena='   || v_randka.ocena
            || ', komentarz=' || v_randka.komentarz
        );
    END LOOP;
    CLOSE v_cursor;
END;

/

SELECT * FROM LogOperacji;
/
