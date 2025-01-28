    /************************************************************
      Wypełnianie tabel danymi oraz testowanie przyjętych założeń
                            (PRACOWNIK)
     ************************************************************/

SET SERVEROUTPUT ON;
     
         /************************************************************
                            DODAWANIE KLIENTÓW
     ************************************************************/

BEGIN
    -- Jan Kowalski
    admin.PakietBiuro.dodaj_klienta(
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


-- Próba dodania istniejącego klienta

BEGIN
    -- Jan Kowalski
    admin.PakietBiuro.dodaj_klienta(
        p_imie           => 'Jan',
        p_nazwisko       => 'Kowalski',
        p_data_ur        => DATE '1990-01-01',
        p_ulica          => 'Główna',
        p_nr_domu        => '10',
        p_nr_mieszkania  => NULL,
        p_kod_pocztowy   => '00-001',
        p_miasto         => 'Warszawa',
        p_status         => 'nieaktywny',
        p_preferencje    => 'kino, wysoka, blondynka',
        p_cechy          => 'kino, wysoki, brunet',
        p_plec           => 'mezczyzna',
        p_orientacja_seksualna => 'mezczyzna',
        p_min_wiek       => 25,
        p_max_wiek       => 40
    );
END;
/

BEGIN
    -- Anna Nowak
    admin.PakietBiuro.dodaj_klienta(
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
    admin.PakietBiuro.dodaj_klienta(
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
    admin.PakietBiuro.dodaj_klienta(
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
    admin.PakietBiuro.dodaj_klienta(
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
    admin.PakietBiuro.dodaj_klienta(
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
    admin.PakietBiuro.dodaj_klienta(
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
    admin.PakietBiuro.dodaj_klienta(
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
    admin.PakietBiuro.dodaj_klienta(
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
    admin.PakietBiuro.dodaj_klienta(
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
    admin.PakietBiuro.dodaj_klienta(
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
    admin.PakietBiuro.dodaj_klienta(
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
    admin.PakietBiuro.dodaj_klienta(
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
    admin.PakietBiuro.dodaj_klienta(
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
    admin.PakietBiuro.dodaj_klienta(
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
    admin.PakietBiuro.dodaj_klienta(
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
    admin.PakietBiuro.dodaj_klienta(
        p_imie           => 'Przyszły',
        p_nazwisko       => 'Klient',
        p_data_ur        => SYSDATE - 3,  -- niepełnoletni!
        p_ulica          => 'Fikcyjna',
        p_nr_domu        => '1',
        p_nr_mieszkania  => NULL,
        p_kod_pocztowy   => '00-999',
        p_miasto         => 'Nieznane',
        p_status         => 'aktywny',
        p_preferencje    => 'brak',
        p_cechy          => 'spanie, jedzenie, lysy',
        p_plec           => 'trans',
        p_orientacja_seksualna => 'kobieta',
        p_min_wiek       => 69,
        p_max_wiek       => 100
    );
END;
/
     
         /************************************************************
                            WYŚWIETLANIE WSZYSTKICH KLIENTÓW
     ************************************************************/

DECLARE
    -- Posługujemy się nazwami z schematem `admin`, jeśli tam jest pakiet i typ.
    -- Jeśli tworzysz je w swoim aktualnym schemacie, możesz pominąć prefix `admin.`
    v_cursor admin.PakietBiuro.refCursorKlient;
    v_klient admin.TypKlient;
BEGIN
    -- Wywołanie procedury z parametrem OUT (typ REF CURSOR)
    admin.PakietBiuro.pobierz_klientow(v_cursor);

    LOOP
        -- Odczytujemy zwrócony obiekt TypKlient
        FETCH v_cursor INTO v_klient;
        EXIT WHEN v_cursor%NOTFOUND;

        -- Wypisujemy dane np. za pomocą metody pelne_dane lub get_imie_nazwisko
        DBMS_OUTPUT.PUT_LINE(v_klient.pelne_dane);
    END LOOP;

    CLOSE v_cursor;
END;
/
BEGIN
    -- Wyświetlenie danych istniejącego klienta
    admin.PakietBiuro.wyswietl_klienta(p_osoba_id => 1);
END;
/

BEGIN
    -- Próba wyświetlenia nieistniejącego klienta
    admin.PakietBiuro.wyswietl_klienta(p_osoba_id => 999);
END;
/
     
         /************************************************************
                            OBSŁUGA OPIEKUNÓW
     ************************************************************/

BEGIN
    admin.PakietBiuro.dodaj_opiekuna(
        p_imie       => 'Magdalena',
        p_nazwisko   => 'Kowalska'
    );
END;
/

BEGIN
    admin.PakietBiuro.dodaj_opiekuna(
        p_imie       => 'Marcin',
        p_nazwisko   => 'Opiekun'
    );
END;
/

BEGIN
    admin.PakietBiuro.dodaj_opiekuna(
        p_imie       => 'Marcin',
        p_nazwisko   => 'Opiekun'
    );
END;
/

DECLARE
    v_cursor   admin.PakietBiuro.refCursorOpiekun; 
    v_opiekun  admin.TypOpiekun;
BEGIN
    -- Zamiast przypisania (v_cursor := ... ) wywołujemy PROCEDURĘ z parametrem OUT
    admin.PakietBiuro.pobierz_opiekunow(v_cursor);

    LOOP
        FETCH v_cursor INTO v_opiekun;
        EXIT WHEN v_cursor%NOTFOUND;

        DBMS_OUTPUT.PUT_LINE(v_opiekun.pokaz_opiekuna);
    END LOOP;

    CLOSE v_cursor;
END;
/


BEGIN
    -- Próba przypisania nieistniejącego klienta
    admin.PakietBiuro.dodaj_klienta_do_opiekuna(p_opiekun_id => 2, p_osoba_id => 999);
END;
/

BEGIN
    admin.PakietBiuro.dodaj_klienta_do_opiekuna(
        p_opiekun_id => 1,
        p_osoba_id   => 1
    );
END;
/

BEGIN
-- Próba przypisania tego samego klienta do opiekuna
    admin.PakietBiuro.dodaj_klienta_do_opiekuna(
        p_opiekun_id => 1,
        p_osoba_id   => 1
    );
END;
/


BEGIN
    admin.PakietBiuro.dodaj_klienta_do_opiekuna(
-- Próba pzypisania klienta przypisanego do opiekuna do innego opiekuna
        p_opiekun_id => 1,
        p_osoba_id   => 2
    );
END;
/

BEGIN
    admin.PakietBiuro.dodaj_klienta_do_opiekuna(
        p_opiekun_id => 2,
        p_osoba_id   => 4
    );
END;
/
BEGIN
    admin.PakietBiuro.dodaj_klienta_do_opiekuna(
        p_opiekun_id => 1,
        p_osoba_id   => 4
    );
END;
/

BEGIN
    admin.PakietBiuro.dodaj_klienta_do_opiekuna(
        p_opiekun_id => 1,
        p_osoba_id   => 5
    );
END;
/
BEGIN
    admin.PakietBiuro.dodaj_klienta_do_opiekuna(
        p_opiekun_id => 2,
        p_osoba_id   => 6
    );
END;
/
BEGIN
    admin.PakietBiuro.dodaj_klienta_do_opiekuna(
        p_opiekun_id => 2,
        p_osoba_id   => 7
    );
END;
/
BEGIN
    admin.PakietBiuro.dodaj_klienta_do_opiekuna(
        p_opiekun_id => 2,
        p_osoba_id   => 8
    );
END;
/
BEGIN
    admin.PakietBiuro.dodaj_klienta_do_opiekuna(
        p_opiekun_id => 1,
        p_osoba_id   => 9
    );
END;
/
BEGIN
    admin.PakietBiuro.dodaj_klienta_do_opiekuna(
        p_opiekun_id => 2,
        p_osoba_id   => 10
    );
END;
/
BEGIN
    admin.PakietBiuro.dodaj_klienta_do_opiekuna(
        p_opiekun_id => 1,
        p_osoba_id   => 11
    );
END;
/
BEGIN
    admin.PakietBiuro.dodaj_klienta_do_opiekuna(
        p_opiekun_id => 2,
        p_osoba_id   => 12
    );
END;
/
BEGIN
    admin.PakietBiuro.dodaj_klienta_do_opiekuna(
        p_opiekun_id => 1,
        p_osoba_id   => 13
    );
END;
/


BEGIN
    admin.PakietBiuro.dodaj_klienta_do_opiekuna(
        p_opiekun_id => 1,
        p_osoba_id   => 14
    );
END;
/

BEGIN
    admin.PakietBiuro.dodaj_klienta_do_opiekuna(
        p_opiekun_id => 1,
        p_osoba_id   => 15
    );
END;
/

BEGIN
    admin.PakietBiuro.dodaj_klienta_do_opiekuna(
        p_opiekun_id => 2,
        p_osoba_id   => 16
    );
END;
/
BEGIN
    admin.PakietBiuro.pokaz_podopiecznych(1);
END;
/
BEGIN
    admin.PakietBiuro.pokaz_podopiecznych(2);
END;
/
     
         /************************************************************
                            OBSŁUGA PROCESU MATCH-MAKING
     ************************************************************/


DECLARE
    v_cursor admin.PakietBiuro.refCursorKlient;
    v_klient admin.TypKlient;
BEGIN
    admin.PakietBiuro.znajdz_pare(
        p_osoba_id => 1,
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
    v_cursor admin.PakietBiuro.refCursorKlient;
    v_klient admin.TypKlient;
BEGIN
    -- Znajdź pary dla klienta o ID=16
    admin.PakietBiuro.znajdz_pare(
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
    v_cursor admin.PakietBiuro.refCursorKlient;
    v_klient admin.TypKlient;
BEGIN
    admin.PakietBiuro.wyszukaj_klienta_po_cechach(
        p_cechy_zadane => 'wysoki, brunet',
        p_plec         => 'kobieta',
        p_wiek_od      => 29, -- przedzial wiekowy w ktorym preferowany przedzial wiekowy poszukiwanej osoby musi sie miescic
        p_wiek_do      => 30, 
        p_orientacja   => 'mezczyzna',
        p_wiek_szuk_od => 29, -- przedzial wiekowy w ktorym wiek poszukiwanej osoby musi sie miescic
        p_wiek_szuk_do => 30, 
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
    admin.PakietBiuro.dodaj_randke(
        p_data_od        => SYSDATE - 10,  -- 10 dni temu
        p_data_do        => SYSDATE - 5,
        p_miejsce        => 'TestBar',
        p_klient1_id     => 1,
        p_klient2_id     => 2
    );
END;
/
BEGIN
    -- Próba dodania randki z tym samym klientem (powinien został zgloszony ERROR)
    admin.PakietBiuro.dodaj_randke(
        p_data_od     => DATE '2025-02-01',
        p_data_do     => DATE '2025-02-15',
        p_miejsce        => 'Park',
        p_klient1_id     => 1,
        p_klient2_id     => 1
    );
END;
/

BEGIN
    admin.PakietBiuro.dodaj_randke(
        p_data_od     => DATE '2025-02-01',
        p_data_do     => DATE '2025-02-15',
        p_miejsce        => 'Restauracja',
        p_klient1_id     => 1, -- ID pierwszego klienta
        p_klient2_id     => 2  -- ID drugiego klienta
    );
    DBMS_OUTPUT.PUT_LINE('Randka została dodana.');
END;
/

BEGIN
    admin.PakietBiuro.dodaj_opinie(
        p_randka_id => 1,  
        p_klient_id => 1,  
        p_ocena     => 1, 
        p_komentarz => 'Spotkanie było rozczarowujące, brak chemii.'

    );
END;
/
BEGIN
    admin.PakietBiuro.dodaj_opinie(
        p_randka_id => 1, 
        p_klient_id => 2, 
        p_ocena     => 5,  
        p_komentarz => 'Świetne spotkanie, bardzo miła osoba!'
    );
    DBMS_OUTPUT.PUT_LINE('Opinia klienta została dodana.');
END;

/

DECLARE
    v_cursor   admin.PakietBiuro.refCursorRandka;
    
    TYPE randkaRec IS RECORD (
        randka_id  NUMBER,
        data_od    DATE,
        data_do    DATE,
        miejsce    VARCHAR2(100),
        klient1    VARCHAR2(200),
        klient2    VARCHAR2(200),
        ocena      NUMBER,
        komentarz  CLOB
    );
    v_randka randkaRec;
BEGIN

    admin.PakietBiuro.historia_randek(
        p_klient_id => 1,
        p_wynik     => v_cursor
    );

    LOOP
        FETCH v_cursor INTO v_randka;
        EXIT WHEN v_cursor%NOTFOUND;

        DBMS_OUTPUT.PUT_LINE('Randka ID='||v_randka.randka_id
            ||', od='||TO_CHAR(v_randka.data_od,'YYYY-MM-DD')
            ||', do='||TO_CHAR(v_randka.data_do,'YYYY-MM-DD')
            ||', miejsce='||v_randka.miejsce
        );
        DBMS_OUTPUT.PUT_LINE('Klient1: '||v_randka.klient1);
        DBMS_OUTPUT.PUT_LINE('Klient2: '||v_randka.klient2);
        DBMS_OUTPUT.PUT_LINE('Ocena='||v_randka.ocena
                             ||', Komentarz='||v_randka.komentarz);
        DBMS_OUTPUT.PUT_LINE('----------------------------');
    END LOOP;

    CLOSE v_cursor;
END;
/


DECLARE
    v_cursor   admin.PakietBiuro.refCursorRandka;  -- kursor z pakietu (schemat 'admin')
    
    -- Definiujemy lokalny rekord do FETCH:
    TYPE randkaRec IS RECORD (
        randka_id  NUMBER,
        data_od    DATE,
        data_do    DATE,
        miejsce    VARCHAR2(100),
        klient1    VARCHAR2(200),
        klient2    VARCHAR2(200),
        opinie     CLOB
    );
    v_randka randkaRec;
BEGIN
    -- Wywołanie procedury pobierz_randki
    admin.PakietBiuro.pobierz_randki(v_cursor);

    LOOP
        FETCH v_cursor INTO v_randka;
        EXIT WHEN v_cursor%NOTFOUND;

        DBMS_OUTPUT.PUT_LINE('Randka ID='||v_randka.randka_id 
            ||', od='||TO_CHAR(v_randka.data_od,'YYYY-MM-DD')
            ||', do='||TO_CHAR(v_randka.data_do,'YYYY-MM-DD')
            ||', miejsce='||v_randka.miejsce
        );
        DBMS_OUTPUT.PUT_LINE('Klient1: '||v_randka.klient1);
        DBMS_OUTPUT.PUT_LINE('Klient2: '||v_randka.klient2);
        DBMS_OUTPUT.PUT_LINE('Opinie: '||v_randka.opinie);
        DBMS_OUTPUT.PUT_LINE('----------------------------');
    END LOOP;

    CLOSE v_cursor;
END;
/


SELECT * FROM admin.LogOperacji;
/
