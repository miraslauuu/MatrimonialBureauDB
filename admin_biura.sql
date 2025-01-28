    /************************************************************
                        BIURO MATRYMONIALNE
                              (ADMIN)
     ************************************************************/
SET SERVEROUTPUT ON; 

-- =====================================================================
-- 1) USUNIĘCIE TRIGGERÓW
-- =====================================================================
DROP TRIGGER trg_check_data_urodzenia;
DROP TRIGGER trg_check_randka_self;
DROP TRIGGER trg_log_operacji;
DROP TRIGGER trg_check_underage;
DROP TRIGGER trg_klient_auto;
DROP TRIGGER trg_opiekun_auto;
DROP TRIGGER trg_randka_auto;

-- =====================================================================
-- 2) USUNIĘCIE TABEL KONWENCJONALNYCH
-- =====================================================================
DROP TABLE OpinieRandek;
DROP TABLE LogOperacji;


-- =====================================================================
-- 3) USUNIĘCIE TABEL OBIEKTOWYCH
-- =====================================================================
DROP TABLE RandkiObjTable;
DROP TABLE OpiekunowieObjTable;
DROP TABLE KlienciObjTable;


-- =====================================================================
-- 4) USUNIĘCIE PAKIETÓW (ciało + specyfikacja)
-- =====================================================================
DROP PACKAGE BODY PakietBiuro;
DROP PACKAGE PakietBiuro;
DROP PACKAGE BODY PakietKlient;
DROP PACKAGE PakietKlient;

-- =====================================================================
-- 5) USUNIĘCIE TYPÓW OBIEKTOWYCH 
--    (w odwrotnej kolejności zależności):
--    - TypOpiekun używa KlientRefTab
--    - TypRandka ma REF do TypKlient
--    - TypKlient jest UNDER TypOsoba
--    - TypOsoba zawiera TypAdres
-- =====================================================================
DROP TYPE TypOpiekun FORCE;
DROP TYPE KlientRefTab FORCE;
DROP TYPE TypRandka FORCE;
DROP TYPE TypKlient FORCE;
DROP TYPE TypOsoba FORCE;
DROP TYPE TypAdres FORCE;


-- =====================================================================
-- 7) USUNIĘCIE SEKWENCJI
-- =====================================================================

DROP SEQUENCE SEQ_OPIEKUN_ID;
DROP SEQUENCE SEQ_OSOBA_ID;
DROP SEQUENCE SEQ_RANDKA_ID;

-- =====================================================================
-- 8) USUNIĘCIE RÓL
-- =====================================================================
DROP ROLE Administrator;
DROP ROLE Employee;


-- =====================================================================
-- 9) USUNIĘCIE UŻYTKOWNIKÓW (z uwzględnieniem CASCADE)
-- =====================================================================
DROP USER admin CASCADE;
DROP USER employee_user CASCADE;


    /************************************************************
      Definicje Typów i Ciał
     ************************************************************/
     
CREATE OR REPLACE TYPE TypAdres AS OBJECT (
    ulica          VARCHAR2(100),
    nr_domu        VARCHAR2(10),
    nr_mieszkania  VARCHAR2(10),
    kod_pocztowy   VARCHAR2(10),
    miasto         VARCHAR2(50),
    MEMBER FUNCTION pokaz_adres RETURN VARCHAR2
) NOT FINAL;
/

CREATE OR REPLACE TYPE BODY TypAdres AS
    MEMBER FUNCTION pokaz_adres RETURN VARCHAR2 IS
    BEGIN
        RETURN ulica || ' ' || nr_domu 
               || CASE 
                     WHEN nr_mieszkania IS NOT NULL THEN '/' || nr_mieszkania 
                     ELSE '' 
                  END
               || ', ' || kod_pocztowy || ' ' || miasto;
    END pokaz_adres;
END;
/

-- Definicja TypOsoba
CREATE OR REPLACE TYPE TypOsoba
AS OBJECT (
    osoba_id       NUMBER,
    imie           VARCHAR2(50),
    nazwisko       VARCHAR2(50),
    data_urodzenia DATE,
    adres          TypAdres,  
    MEMBER PROCEDURE pokaz_dane,
    MEMBER FUNCTION get_imie_nazwisko RETURN VARCHAR2
) NOT FINAL;
/

CREATE OR REPLACE TYPE BODY TypOsoba AS
    MEMBER PROCEDURE pokaz_dane IS
    BEGIN
        DBMS_OUTPUT.PUT_LINE('Osoba ID: ' || osoba_id);
        DBMS_OUTPUT.PUT_LINE('Imię i nazwisko: ' || imie || ' ' || nazwisko);
        DBMS_OUTPUT.PUT_LINE('Data urodzenia: ' || TO_CHAR(data_urodzenia, 'YYYY-MM-DD'));
        DBMS_OUTPUT.PUT_LINE('Adres: ' || adres.pokaz_adres());
    END pokaz_dane;

    MEMBER FUNCTION get_imie_nazwisko RETURN VARCHAR2 IS
    BEGIN
        RETURN imie || ' ' || nazwisko;
    END;
END;
/

-- Definicja TypKlient, która dziedziczy po TypOsoba 
CREATE OR REPLACE TYPE TypKlient UNDER TypOsoba (
    status_klienta       VARCHAR2(20),
    preferencje          VARCHAR2(200),
    cechy                VARCHAR2(500),
    plec                 VARCHAR2(10),
    orientacja_seksualna VARCHAR2(30),
    preferowany_min_wiek NUMBER,
    preferowany_max_wiek NUMBER,
    MEMBER FUNCTION pelne_dane RETURN VARCHAR2
);

/
CREATE OR REPLACE TYPE BODY TypKlient AS
    MEMBER FUNCTION pelne_dane RETURN VARCHAR2 IS
        v_wiek NUMBER;
    BEGIN
        -- Proste wyliczenie różnicy lat (przybliżone):
        v_wiek := EXTRACT(YEAR FROM SYSDATE) - EXTRACT(YEAR FROM data_urodzenia);

        RETURN 'Klient ID: ' || osoba_id
               || ', ' || imie || ' ' || nazwisko
               || ', Wiek: ' || v_wiek
               || ', Miasto: ' || adres.miasto
               || ', Status: ' || status_klienta
               || ', Preferencje: ' || preferencje
               || ', Cechy: ' || cechy
               || ', Płeć: ' || plec
               || ', Orientacja: ' || orientacja_seksualna
               || ', Min. wiek preferowany: ' || preferowany_min_wiek
               || ', Max. wiek preferowany: ' || preferowany_max_wiek;
    END;
END;
/



-- Definicja TypRandka
CREATE OR REPLACE TYPE TypRandka AS OBJECT (
    randka_id      NUMBER,
    data_od        DATE,
    data_do        DATE,
    miejsce        VARCHAR2(100),
    klient1_ref    REF TypKlient, 
    klient2_ref    REF TypKlient, 
    MEMBER FUNCTION opis RETURN VARCHAR2
);
/

CREATE OR REPLACE TYPE BODY TypRandka AS
    MEMBER FUNCTION opis RETURN VARCHAR2 IS
    BEGIN
        RETURN 'Randka ID: ' || randka_id 
               || ', od: ' || TO_CHAR(data_od, 'YYYY-MM-DD')
               || ' do: ' || TO_CHAR(data_do, 'YYYY-MM-DD')
               || ', miejsce: ' || miejsce;
    END opis;
END;
/

CREATE OR REPLACE TYPE KlientRefTab AS TABLE OF REF TypKlient; --typ kolekcji w postaci tabeli zagnieżdżonej
/

-- Definicja TypOpiekun (posiada listę podopiecznych - referencje do KlientRefTab)
CREATE OR REPLACE TYPE TypOpiekun AS OBJECT (
    opiekun_id   NUMBER,
    imie         VARCHAR2(50),
    nazwisko     VARCHAR2(50),
    podopieczni  KlientRefTab,       
    MEMBER FUNCTION pokaz_opiekuna RETURN VARCHAR2
);
/

CREATE OR REPLACE TYPE BODY TypOpiekun AS
    MEMBER FUNCTION pokaz_opiekuna RETURN VARCHAR2 IS
    BEGIN
        RETURN 'Opiekun: ' || imie || ' ' || nazwisko 
               || ' (ID=' || opiekun_id || ')';
    END pokaz_opiekuna;
END;
/

CREATE TABLE KlienciObjTable OF TypKlient (
    CONSTRAINT pk_klienci_obj PRIMARY KEY (osoba_id)
)
OBJECT IDENTIFIER IS PRIMARY KEY;
/

CREATE TABLE RandkiObjTable OF TypRandka (
    
    CONSTRAINT pk_randki_obj PRIMARY KEY (randka_id)
);
/

-- Tabela OpiekunowieObjTable z NESTED TABLE
CREATE TABLE OpiekunowieObjTable OF TypOpiekun (
    CONSTRAINT pk_opiekun PRIMARY KEY (opiekun_id)
)
NESTED TABLE podopieczni STORE AS podopieczni_storage
RETURN AS LOCATOR;
/


CREATE TABLE OpinieRandek (
    opinia_id NUMBER GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
    randka_id NUMBER REFERENCES RandkiObjTable(randka_id),
    klient_id NUMBER REFERENCES KlienciObjTable(osoba_id),
    ocena NUMBER CHECK (ocena BETWEEN 1 AND 5),
    komentarz CLOB
);
/



-- Ustawienie SCOPE dla REF (klient1_ref i klient2_ref) -> muszą wskazywać na KlienciObjTable
ALTER TABLE RandkiObjTable
    ADD SCOPE FOR (klient1_ref) IS KlienciObjTable;

ALTER TABLE RandkiObjTable
    ADD SCOPE FOR (klient2_ref) IS KlienciObjTable;

-- Ustawienie SCOPE w tabeli zagnieżdżonej (podopieczni_storage) -> REF do KlienciObjTable
ALTER TABLE podopieczni_storage
  ADD SCOPE FOR (COLUMN_VALUE) IS KlienciObjTable;

/


-- Sekwencje i triggery do autonumeracji (osoba_id, randka_id, opiekun_id)

CREATE SEQUENCE seq_osoba_id
   START WITH 1
   INCREMENT BY 1
   NOCACHE 
   NOORDER;
/


CREATE OR REPLACE TRIGGER trg_klient_auto
BEFORE INSERT ON KlienciObjTable
FOR EACH ROW
WHEN (new.osoba_id IS NULL)
BEGIN
    :NEW.osoba_id := seq_osoba_id.NEXTVAL;
END;
/

CREATE SEQUENCE seq_randka_id
   START WITH 1
   INCREMENT BY 1
   NOCACHE;
/
CREATE OR REPLACE TRIGGER trg_randka_auto
BEFORE INSERT ON RandkiObjTable
FOR EACH ROW
WHEN (new.randka_id IS NULL)
BEGIN
    :NEW.randka_id := seq_randka_id.NEXTVAL;
END;
/

CREATE SEQUENCE seq_opiekun_id
   START WITH 1
   INCREMENT BY 1
   NOCACHE;
/
CREATE OR REPLACE TRIGGER trg_opiekun_auto
BEFORE INSERT ON OpiekunowieObjTable
FOR EACH ROW
WHEN (new.opiekun_id IS NULL)
BEGIN
    :NEW.opiekun_id := seq_opiekun_id.NEXTVAL;
END;


/
    /************************************************************
      Tworzenie Pakietów (implementacja logiki biznesowej)
     ************************************************************/
CREATE OR REPLACE PACKAGE PakietBiuro AS
    
    TYPE refCursorKlient IS REF CURSOR;
    TYPE refCursorOpiekun IS REF CURSOR;
    TYPE refCursorRandka  IS REF CURSOR;

    PROCEDURE dodaj_klienta(
        p_imie               VARCHAR2,
        p_nazwisko           VARCHAR2,
        p_data_ur            DATE,
        p_ulica              VARCHAR2,
        p_nr_domu            VARCHAR2,
        p_nr_mieszkania      VARCHAR2,
        p_kod_pocztowy       VARCHAR2,
        p_miasto             VARCHAR2,
        p_status             VARCHAR2,
        p_preferencje        VARCHAR2,
        p_cechy              VARCHAR2,
        p_plec               VARCHAR2,
        p_orientacja_seksualna VARCHAR2,
        p_min_wiek           NUMBER,
        p_max_wiek           NUMBER
    );

    PROCEDURE wyswietl_klienta(p_osoba_id NUMBER);

    PROCEDURE pobierz_klientow(
        p_wynik OUT refCursorKlient
    );

    PROCEDURE dodaj_opiekuna(
        p_imie       VARCHAR2,
        p_nazwisko   VARCHAR2
    );
    
    PROCEDURE dodaj_klienta_do_opiekuna(
        p_opiekun_id NUMBER,
        p_osoba_id   NUMBER
    );

    PROCEDURE pobierz_opiekunow(
        p_wynik OUT refCursorOpiekun
    );

    PROCEDURE pokaz_podopiecznych(p_opiekun_id IN NUMBER);

    PROCEDURE dodaj_randke(
        p_data_od        DATE,
        p_data_do        DATE,
        p_miejsce        VARCHAR2,
        p_klient1_id     NUMBER,
        p_klient2_id     NUMBER
    );

    PROCEDURE pobierz_randki(
        p_wynik OUT refCursorRandka
    );

    PROCEDURE znajdz_pare(
        p_osoba_id       NUMBER,
        p_wynik          OUT refCursorKlient
    );

    PROCEDURE dodaj_opinie(
        p_randka_id NUMBER,
        p_klient_id NUMBER,
        p_ocena NUMBER,
        p_komentarz CLOB
    );

    PROCEDURE historia_randek(
        p_klient_id NUMBER,
        p_wynik OUT refCursorRandka
    );

    PROCEDURE wyszukaj_klienta_po_cechach(
    p_cechy_zadane   IN VARCHAR2,   -- np. "wysoki, brunet"
    p_plec           IN VARCHAR2,   -- płeć poszukiwanej osoby
    p_wiek_szuk_od   IN NUMBER,     -- wiek minimalny poszukiwanej osoby
    p_wiek_szuk_do   IN NUMBER,     -- wiek maksymalny poszukiwanej osoby
    p_orientacja     IN VARCHAR2,   -- np. "kobieta", "mezczyzna", "obojetnie"
    p_wiek_od        IN NUMBER,     -- nasz wiek minimalny, który musi tolerować kandydat
    p_wiek_do        IN NUMBER,     -- nasz wiek maksymalny
    p_wynik          OUT refCursorKlient
    );

END PakietBiuro;

/

create or replace PACKAGE BODY PakietBiuro AS

    /************************************************************
      1) OBSŁUGA KLIENTÓW
     ************************************************************/
  PROCEDURE dodaj_klienta(
    p_imie               VARCHAR2,
    p_nazwisko           VARCHAR2,
    p_data_ur            DATE,
    p_ulica              VARCHAR2,
    p_nr_domu            VARCHAR2,
    p_nr_mieszkania      VARCHAR2,
    p_kod_pocztowy       VARCHAR2,
    p_miasto             VARCHAR2,
    p_status             VARCHAR2,
    p_preferencje        VARCHAR2,
    p_cechy              VARCHAR2,
    p_plec               VARCHAR2,
    p_orientacja_seksualna VARCHAR2,
    p_min_wiek           NUMBER,
    p_max_wiek           NUMBER
) IS
    v_count NUMBER;
BEGIN
    -- Sprawdzenie, czy nie ma duplikatu (imie, nazwisko, data urodzenia, adres)

    SELECT COUNT(*)
      INTO v_count
      FROM KlienciObjTable k
     WHERE k.imie = p_imie
       AND k.nazwisko = p_nazwisko
       AND k.data_urodzenia = p_data_ur
       AND k.adres.ulica = p_ulica
       AND k.adres.nr_domu = p_nr_domu
       AND NVL(k.adres.nr_mieszkania, 'BRAK') = NVL(p_nr_mieszkania, 'BRAK')
       AND k.adres.kod_pocztowy = p_kod_pocztowy
       AND k.adres.miasto = p_miasto;

    IF v_count > 0 THEN
       RAISE_APPLICATION_ERROR(-20050,
         'Klient o takich danych (imie, nazwisko, data_urodzenia, adres) już istnieje!');
    END IF;

    -- 2) Wstawienie nowego klienta (ID = NULL → generowane z sekwencji przez trigger)
    INSERT INTO KlienciObjTable
    VALUES (
       TypKlient(
          NULL, -- osoba_id => generowane automatycznie
          p_imie,
          p_nazwisko,
          p_data_ur,
          TypAdres(p_ulica, p_nr_domu, p_nr_mieszkania, p_kod_pocztowy, p_miasto),
          p_status,
          p_preferencje,
          p_cechy,
          p_plec,
          p_orientacja_seksualna,
          p_min_wiek,
          p_max_wiek
       )
    );

    DBMS_OUTPUT.PUT_LINE('Dodano nowego klienta (ID generowane).');

EXCEPTION
    WHEN OTHERS THEN
       DBMS_OUTPUT.PUT_LINE('Błąd (dodaj_klienta): ' || SQLERRM);
END dodaj_klienta;



PROCEDURE wyswietl_klienta(p_osoba_id NUMBER) IS
        v_klient TypKlient;
    BEGIN
        SELECT VALUE(k)
        INTO v_klient
        FROM KlienciObjTable k
        WHERE k.osoba_id = p_osoba_id;

        DBMS_OUTPUT.PUT_LINE('*** Dane klienta ***');
        DBMS_OUTPUT.PUT_LINE(v_klient.pelne_dane);
        DBMS_OUTPUT.PUT_LINE('Adres: ' || v_klient.adres.pokaz_adres());
        DBMS_OUTPUT.PUT_LINE('********************');
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            DBMS_OUTPUT.PUT_LINE('Brak klienta o ID=' || p_osoba_id);
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Bład (wyswietl_klienta): ' || SQLERRM);
    END wyswietl_klienta;


PROCEDURE pobierz_klientow(
        p_wynik OUT refCursorKlient
    ) IS
    BEGIN
        OPEN p_wynik FOR
            SELECT VALUE(k)
              FROM KlienciObjTable k;
    END pobierz_klientow;




    /************************************************************
      2) OBS?UGA OPIEKUNÓW
     ************************************************************/
   PROCEDURE dodaj_opiekuna(
    p_imie     VARCHAR2,
    p_nazwisko VARCHAR2
) IS
    v_count NUMBER;
BEGIN
    -- Sprawdzenie, czy istnieje opiekun o tym samym imieniu i nazwisku
    SELECT COUNT(*)
      INTO v_count
      FROM OpiekunowieObjTable o
     WHERE o.imie     = p_imie
       AND o.nazwisko = p_nazwisko;

    IF v_count > 0 THEN
       RAISE_APPLICATION_ERROR(-20052,
         'Opiekun o imieniu i nazwisku ' || p_imie || ' ' || p_nazwisko
         || ' już istnieje w systemie!');
    END IF;

    -- Wstawienie nowego opiekuna z ID = NULL (generowanego przez trigger)
    INSERT INTO OpiekunowieObjTable
    VALUES(
        TypOpiekun(
            opiekun_id  => NULL,
            imie        => p_imie,
            nazwisko    => p_nazwisko,
            podopieczni => KlientRefTab()
        )
    );

    DBMS_OUTPUT.PUT_LINE('Dodano nowego opiekuna (ID generowane).');

EXCEPTION
    WHEN DUP_VAL_ON_INDEX THEN
        DBMS_OUTPUT.PUT_LINE('Błąd: duplikat klucza! (dodaj_opiekuna)');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Błąd (dodaj_opiekuna): ' || SQLERRM);
END dodaj_opiekuna;

PROCEDURE dodaj_klienta_do_opiekuna(
    p_opiekun_id NUMBER,
    p_osoba_id   NUMBER
) IS
    v_opiekun      TypOpiekun;
    v_klient_ref   REF TypKlient;
    v_count        NUMBER;
BEGIN
    -- 1) Pobranie opiekuna
    SELECT VALUE(o)
      INTO v_opiekun
      FROM OpiekunowieObjTable o
     WHERE o.opiekun_id = p_opiekun_id;

    -- 2) Pobranie REF do klienta
    SELECT REF(k)
      INTO v_klient_ref
      FROM KlienciObjTable k
     WHERE k.osoba_id = p_osoba_id;

    -- 3) Sprawdzenie, czy ten REF jest już w kolekcji podopiecznych u jakiegoś innego opiekuna
    SELECT COUNT(*)
      INTO v_count
      FROM OpiekunowieObjTable o,
           TABLE(o.podopieczni) p
     WHERE p.COLUMN_VALUE = v_klient_ref;  -- p to element typu REF TypKlient

    IF v_count > 0 THEN
       -- Ten klient jest już podopiecznym kogoś
       RAISE_APPLICATION_ERROR(-20070,
         'Klient o ID='||p_osoba_id||' jest już przypisany opiekuna!');
    END IF;

    -- 4) Dodanie klienta do listy podopiecznych
    -- (sprawdzamy też, czy w samym opiekunie v_opiekun nie jest pusty i ewentualnie go inicjujemy)
    IF v_opiekun.podopieczni IS NULL THEN
       v_opiekun.podopieczni := KlientRefTab();
    END IF;

    v_opiekun.podopieczni.EXTEND(1);
    v_opiekun.podopieczni(v_opiekun.podopieczni.LAST) := v_klient_ref;

    -- 5) Zaktualizowanie tabeli
    UPDATE OpiekunowieObjTable o
       SET VALUE(o) = v_opiekun
     WHERE o.opiekun_id = p_opiekun_id;

    DBMS_OUTPUT.PUT_LINE('Dodano klienta o ID=' || p_osoba_id
                         || ' do opiekuna o ID=' || p_opiekun_id);

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Błąd: Nie znaleziono opiekuna lub klienta.');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Błąd (dodaj_klienta_do_opiekuna): ' || SQLERRM);
END dodaj_klienta_do_opiekuna;




    PROCEDURE pobierz_opiekunow(
        p_wynik OUT refCursorOpiekun
    ) IS
    BEGIN
        OPEN p_wynik FOR
            SELECT VALUE(o)
              FROM OpiekunowieObjTable o;
    END pobierz_opiekunow;


PROCEDURE pokaz_podopiecznych(p_opiekun_id IN NUMBER) IS
    v_opiekun TypOpiekun;
    v_podopieczny REF TypKlient;
    v_klient TypKlient;
BEGIN
    -- Pobierz opiekuna
    SELECT VALUE(o)
    INTO v_opiekun
    FROM OpiekunowieObjTable o
    WHERE o.opiekun_id = p_opiekun_id;

    IF v_opiekun.podopieczni IS NOT NULL THEN
        FOR i IN 1..v_opiekun.podopieczni.COUNT LOOP
            v_podopieczny := v_opiekun.podopieczni(i);

            SELECT DEREF(v_podopieczny)
            INTO v_klient
            FROM DUAL;

            DBMS_OUTPUT.PUT_LINE('Podopieczny ' || i || ': ' ||
                                 v_klient.imie || ' ' || v_klient.nazwisko);
        END LOOP;
    ELSE
        DBMS_OUTPUT.PUT_LINE('Opiekun o ID=' || p_opiekun_id || ' nie ma podopiecznych.');
    END IF;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Nie znaleziono opiekuna o ID=' || p_opiekun_id);
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Wystąpił błąd: ' || SQLERRM);
END pokaz_podopiecznych;


    /************************************************************
      3) OBSŁUGA RANDKI
     ************************************************************/
 PROCEDURE dodaj_randke(
    p_data_od     DATE,
    p_data_do     DATE,
    p_miejsce     VARCHAR2,
    p_klient1_id  NUMBER,
    p_klient2_id  NUMBER
) IS
    v_count NUMBER;
    v_kl1   REF TypKlient;
    v_kl2   REF TypKlient;
BEGIN
    -- 1) Walidacja od-do
    IF p_data_do < p_data_od THEN
        RAISE_APPLICATION_ERROR(-20010, 'Data zakończenia nie może być wcześniejsza od rozpoczęcia!');
    END IF;
    IF p_data_od < TRUNC(SYSDATE) THEN
   RAISE_APPLICATION_ERROR(-20030, 'Data rozpoczęcia randki nie może być w przeszłości!');
END IF;
    IF p_data_do < TRUNC(SYSDATE) THEN
   RAISE_APPLICATION_ERROR(-20031, 'Data rozpoczęcia randki nie może być w przeszłości!');
END IF;


    -- 2) Sprawdzamy, czy w bazie nie istnieje randka o tych samych parametrach
    SELECT COUNT(*)
      INTO v_count
      FROM RandkiObjTable r
     WHERE r.data_od = p_data_od
       AND r.data_do = p_data_do
       AND r.miejsce = p_miejsce
       AND (
            (DEREF(r.klient1_ref).osoba_id = p_klient1_id 
             AND DEREF(r.klient2_ref).osoba_id = p_klient2_id)
            OR
            (DEREF(r.klient1_ref).osoba_id = p_klient2_id
             AND DEREF(r.klient2_ref).osoba_id = p_klient1_id)
           );

    IF v_count > 0 THEN
       RAISE_APPLICATION_ERROR(-20051,
         'Taka randka już istnieje (ci sami klienci, przedział dat, miejsce)!');
    END IF;

    -- 3) Pobieramy REF do klientów
    SELECT REF(k)
      INTO v_kl1
      FROM KlienciObjTable k
     WHERE k.osoba_id = p_klient1_id;

    SELECT REF(k)
      INTO v_kl2
      FROM KlienciObjTable k
     WHERE k.osoba_id = p_klient2_id;

    -- 4) INSERT
    INSERT INTO RandkiObjTable
    VALUES (
        TypRandka(
            NULL,
            p_data_od,
            p_data_do,
            p_miejsce,
            v_kl1,
            v_kl2
        )
    );

    DBMS_OUTPUT.PUT_LINE('Dodano randkę (ID generowane).');

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Błąd: nie znaleziono jednego z klientów!');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Błąd (dodaj_randke): ' || SQLERRM);
END dodaj_randke;



PROCEDURE pobierz_randki(
    p_wynik OUT refCursorRandka
) IS
BEGIN
    -- W tym zapytaniu pobieramy szczegóły
    -- Również dołączamy opinie (ocena, komentarz) z tabeli OpinieRandek.
    
    OPEN p_wynik FOR
        SELECT r.randka_id,
               r.data_od,
               r.data_do,
               r.miejsce,
               DEREF(r.klient1_ref).imie || ' ' || DEREF(r.klient1_ref).nazwisko AS klient1,
               DEREF(r.klient2_ref).imie || ' ' || DEREF(r.klient2_ref).nazwisko AS klient2,
               (SELECT LISTAGG('['||o.ocena||'] '||o.komentarz, '; ')
                  FROM OpinieRandek o
                 WHERE o.randka_id = r.randka_id
               ) AS opinie
        FROM RandkiObjTable r
        ORDER BY r.randka_id;

END pobierz_randki;


     PROCEDURE znajdz_pare(
      p_osoba_id NUMBER,
      p_wynik    OUT refCursorKlient
  ) IS
      v_count NUMBER;
      v_klient TypKlient;
  BEGIN
        ----------------------------------------------------------------------------
      -- Wyświetlenie danych osoby dla której szukamy
      ----------------------------------------------------------------------------
   BEGIN
        SELECT VALUE(k)
          INTO v_klient
          FROM KlienciObjTable k
         WHERE k.osoba_id = p_osoba_id;

        DBMS_OUTPUT.PUT_LINE('*** Szukamy pary dla: ***');
        DBMS_OUTPUT.PUT_LINE(v_klient.pelne_dane);
        DBMS_OUTPUT.PUT_LINE('***************************');
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            DBMS_OUTPUT.PUT_LINE('Brak klienta o ID='||p_osoba_id||'. Przerywam.');
            OPEN p_wynik FOR SELECT 1 FROM DUAL WHERE 1=0; -- pusty kursor
            RETURN;
    END;
      ----------------------------------------------------------------------------
      -- (A) Najpierw sprawdzamy, czy w ogóle są jacyś kandydaci spełniający kryteria
      ----------------------------------------------------------------------------
      SELECT COUNT(*) INTO v_count
      FROM KlienciObjTable k
      WHERE k.osoba_id != p_osoba_id
        -- 1) Brak negatywnych opinii (<3) w przeszłych randkach pomiędzy tymi osobami:
        AND NOT EXISTS (
            SELECT 1
            FROM RandkiObjTable r
                 LEFT JOIN OpinieRandek opinia1
                        ON opinia1.randka_id = r.randka_id
                        AND opinia1.klient_id = p_osoba_id
                 LEFT JOIN OpinieRandek opinia2
                        ON opinia2.randka_id = r.randka_id
                        AND opinia2.klient_id = k.osoba_id
            WHERE 
                  -- To musi być randka między tymi dwiema osobami:
                  ( (DEREF(r.klient1_ref).osoba_id = p_osoba_id 
                     AND DEREF(r.klient2_ref).osoba_id = k.osoba_id)
                    OR 
                    (DEREF(r.klient2_ref).osoba_id = p_osoba_id 
                     AND DEREF(r.klient1_ref).osoba_id = k.osoba_id)
                  )
                  -- A jednocześnie ocena < 3 z którejkolwiek strony
                  AND (opinia1.ocena < 3 OR opinia2.ocena < 3)
        )
        -- 2) Orientacja musi się zgadzać z obu stron na 100%
        AND (
           (
             k.orientacja_seksualna = 'obojetnie'
             OR
             (k.orientacja_seksualna = 'mezczyzna' AND 
               (SELECT plec FROM KlienciObjTable WHERE osoba_id = p_osoba_id) = 'mezczyzna')
             OR
             (k.orientacja_seksualna = 'kobieta' AND 
               (SELECT plec FROM KlienciObjTable WHERE osoba_id = p_osoba_id) = 'kobieta')
           )
           AND
           (
             (SELECT orientacja_seksualna 
              FROM KlienciObjTable 
              WHERE osoba_id = p_osoba_id
             ) = 'obojetnie'
             OR
             (
               (SELECT orientacja_seksualna 
                FROM KlienciObjTable 
                WHERE osoba_id = p_osoba_id
               ) = 'mezczyzna'
               AND k.plec = 'mezczyzna'
             )
             OR
             (
               (SELECT orientacja_seksualna 
                FROM KlienciObjTable 
                WHERE osoba_id = p_osoba_id
               ) = 'kobieta'
               AND k.plec = 'kobieta'
             )
           )
        )
        -- 3) Wiek musi się zgadzać z obu stron na 100%
        AND (
            -- k. preferuje mój wiek
            k.preferowany_min_wiek <= (
                SELECT EXTRACT(YEAR FROM SYSDATE) - EXTRACT(YEAR FROM data_urodzenia)
                FROM KlienciObjTable
                WHERE osoba_id = p_osoba_id
            )
            AND k.preferowany_max_wiek >= (
                SELECT EXTRACT(YEAR FROM SYSDATE) - EXTRACT(YEAR FROM data_urodzenia)
                FROM KlienciObjTable
                WHERE osoba_id = p_osoba_id
            )
            -- Ja preferuję wiek k
            AND (SELECT preferowany_min_wiek
                 FROM KlienciObjTable
                 WHERE osoba_id = p_osoba_id
                )
                <= EXTRACT(YEAR FROM SYSDATE) - EXTRACT(YEAR FROM k.data_urodzenia)
            AND (SELECT preferowany_max_wiek
                 FROM KlienciObjTable
                 WHERE osoba_id = p_osoba_id
                )
                >= EXTRACT(YEAR FROM SYSDATE) - EXTRACT(YEAR FROM k.data_urodzenia)
        );

      IF v_count = 0 THEN
          DBMS_OUTPUT.PUT_LINE('Nie znaleziono żadnej pasującej osoby.');
          -- Zwróć pusty zbiór, żeby kursor był poprawny, ale pusty!!!!!
          OPEN p_wynik FOR SELECT VALUE(k) FROM KlienciObjTable k WHERE 1=0;
      ELSE
          ----------------------------------------------------------------------------
          -- (B) Jeśli są kandydaci, to otwieramy kursor z właściwym zamówieniem
          ----------------------------------------------------------------------------
          OPEN p_wynik FOR
            SELECT VALUE(k)
            FROM KlienciObjTable k
            WHERE k.osoba_id != p_osoba_id
              AND NOT EXISTS (
                  SELECT 1
                  FROM RandkiObjTable r
                       LEFT JOIN OpinieRandek opinia1
                              ON opinia1.randka_id = r.randka_id
                              AND opinia1.klient_id = p_osoba_id
                       LEFT JOIN OpinieRandek opinia2
                              ON opinia2.randka_id = r.randka_id
                              AND opinia2.klient_id = k.osoba_id
                  WHERE 
                        ( (DEREF(r.klient1_ref).osoba_id = p_osoba_id 
                           AND DEREF(r.klient2_ref).osoba_id = k.osoba_id)
                          OR
                          (DEREF(r.klient2_ref).osoba_id = p_osoba_id 
                           AND DEREF(r.klient1_ref).osoba_id = k.osoba_id)
                        )
                        AND (opinia1.ocena < 3 OR opinia2.ocena < 3)
              )
              -- 100% orientacja
              AND (
                  (
                    k.orientacja_seksualna = 'obojetnie'
                    OR
                    (k.orientacja_seksualna = 'mezczyzna' AND 
                      (SELECT plec FROM KlienciObjTable WHERE osoba_id = p_osoba_id) = 'mezczyzna')
                    OR
                    (k.orientacja_seksualna = 'kobieta' AND 
                      (SELECT plec FROM KlienciObjTable WHERE osoba_id = p_osoba_id) = 'kobieta')
                  )
                  AND
                  (
                    (SELECT orientacja_seksualna 
                     FROM KlienciObjTable 
                     WHERE osoba_id = p_osoba_id
                    ) = 'obojetnie'
                    OR
                    (
                      (SELECT orientacja_seksualna 
                       FROM KlienciObjTable 
                       WHERE osoba_id = p_osoba_id
                      ) = 'mezczyzna'
                      AND k.plec = 'mezczyzna'
                    )
                    OR
                    (
                      (SELECT orientacja_seksualna 
                       FROM KlienciObjTable 
                       WHERE osoba_id = p_osoba_id
                      ) = 'kobieta'
                      AND k.plec = 'kobieta'
                    )
                  )
              )
              -- 100% wiek
              AND (
                k.preferowany_min_wiek <= (
                    SELECT EXTRACT(YEAR FROM SYSDATE) - EXTRACT(YEAR FROM data_urodzenia)
                    FROM KlienciObjTable
                    WHERE osoba_id = p_osoba_id
                )
                AND k.preferowany_max_wiek >= (
                    SELECT EXTRACT(YEAR FROM SYSDATE) - EXTRACT(YEAR FROM data_urodzenia)
                    FROM KlienciObjTable
                    WHERE osoba_id = p_osoba_id
                )
                AND (SELECT preferowany_min_wiek
                     FROM KlienciObjTable
                     WHERE osoba_id = p_osoba_id
                    )
                    <= EXTRACT(YEAR FROM SYSDATE) - EXTRACT(YEAR FROM k.data_urodzenia)
                AND (SELECT preferowany_max_wiek
                     FROM KlienciObjTable
                     WHERE osoba_id = p_osoba_id
                    )
                    >= EXTRACT(YEAR FROM SYSDATE) - EXTRACT(YEAR FROM k.data_urodzenia)
              )
            ORDER BY 
              (
                -- Im więcej zbieżnych cech z moimi preferencjami...
                REGEXP_COUNT(
                  k.cechy, 
                  '(' || REPLACE(
                    (SELECT preferencje 
                     FROM KlienciObjTable 
                     WHERE osoba_id = p_osoba_id
                    ), 
                    ',', '|'
                  ) || ')',
                  1, 'i'
                )
                +
                -- ...i moich cech z preferencjami k...
                REGEXP_COUNT(
                  (SELECT cechy 
                   FROM KlienciObjTable 
                   WHERE osoba_id = p_osoba_id
                  ),
                  '(' || REPLACE(k.preferencje, ',', '|') || ')',
                  1, 'i'
                )
              ) DESC;
      END IF;

  END znajdz_pare;




PROCEDURE dodaj_opinie(
    p_randka_id NUMBER,
    p_klient_id NUMBER,
    p_ocena NUMBER,
    p_komentarz CLOB
) IS
    v_count NUMBER;
BEGIN
    SELECT COUNT(*)
    INTO v_count
    FROM RandkiObjTable r
    WHERE r.randka_id = p_randka_id
      AND (DEREF(r.klient1_ref).osoba_id = p_klient_id OR DEREF(r.klient2_ref).osoba_id = p_klient_id);

    IF v_count = 0 THEN
        RAISE_APPLICATION_ERROR(-20005, 'Klient nie uczestniczył w tej randce!');
    END IF;

    INSERT INTO OpinieRandek (randka_id, klient_id, ocena, komentarz)
    VALUES (p_randka_id, p_klient_id, p_ocena, p_komentarz);

    DBMS_OUTPUT.PUT_LINE('Dodano opinię o randce');
EXCEPTION
    WHEN DUP_VAL_ON_INDEX THEN
        DBMS_OUTPUT.PUT_LINE('Opinia dla tej randki już istnieje!');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Błąd (dodaj_opinie): ' || SQLERRM);
END dodaj_opinie;

  PROCEDURE historia_randek(
      p_klient_id NUMBER,
      p_wynik OUT refCursorRandka
  ) IS
  BEGIN
      OPEN p_wynik FOR
        SELECT r.randka_id,
               r.data_od,
               r.data_do,
               r.miejsce,
               DEREF(r.klient1_ref).imie || ' ' || DEREF(r.klient1_ref).nazwisko AS klient1,
               DEREF(r.klient2_ref).imie || ' ' || DEREF(r.klient2_ref).nazwisko AS klient2,
               (SELECT ocena
                  FROM OpinieRandek o
                 WHERE o.randka_id = r.randka_id
                   AND o.klient_id = p_klient_id
               ) AS ocena,
               (SELECT komentarz
                  FROM OpinieRandek o
                 WHERE o.randka_id = r.randka_id
                   AND o.klient_id = p_klient_id
               ) AS komentarz
        FROM RandkiObjTable r
        WHERE DEREF(r.klient1_ref).osoba_id = p_klient_id
           OR DEREF(r.klient2_ref).osoba_id = p_klient_id;
  END historia_randek;

PROCEDURE wyszukaj_klienta_po_cechach(
    p_cechy_zadane   IN VARCHAR2,   -- np. "wysoki, brunet"
    p_plec           IN VARCHAR2,   -- płeć poszukiwanej osoby
    p_wiek_szuk_od   IN NUMBER,     -- wiek minimalny poszukiwanej osoby
    p_wiek_szuk_do   IN NUMBER,     -- wiek maksymalny poszukiwanej osoby
    p_orientacja     IN VARCHAR2,   -- np. "kobieta", "mezczyzna", "obojetnie"
    p_wiek_od        IN NUMBER,     -- nasz wiek minimalny, który musi tolerować kandydat
    p_wiek_do        IN NUMBER,     -- nasz wiek maksymalny
    p_wynik          OUT refCursorKlient
) IS
    v_count NUMBER;
BEGIN
    ----------------------------------------------------------------------------
    -- 1) Sprawdzenmy czy istnieje klient spełniający warunki:
    ----------------------------------------------------------------------------
    SELECT COUNT(*)
      INTO v_count
      FROM KlienciObjTable k
     WHERE 
       -- (a) Płeć
       k.plec = p_plec
       -- (b) Wiek kandydata musi być w [p_wiek_szuk_od, p_wiek_szuk_do]
       AND (EXTRACT(YEAR FROM SYSDATE) - EXTRACT(YEAR FROM k.data_urodzenia))
           BETWEEN p_wiek_szuk_od AND p_wiek_szuk_do
       -- (c) Orientacja
       AND (
         p_orientacja = 'obojetnie'
         OR k.orientacja_seksualna = p_orientacja
       )
       -- (d)(e) Kandydat toleruje nasz wiek
       AND k.preferowany_min_wiek <= p_wiek_do
       AND k.preferowany_max_wiek >= p_wiek_od;

    IF v_count = 0 THEN
        DBMS_OUTPUT.PUT_LINE('Nie znaleziono klientów spełniających warunki.');
        OPEN p_wynik FOR SELECT 1 FROM DUAL WHERE 1=0; -- pusty kursor
    ELSE
        ----------------------------------------------------------------------------
        -- 2) Skoro są wyniki, otwieramy kursor z tymi samymi warunkami + sortowanie:
        ----------------------------------------------------------------------------
        OPEN p_wynik FOR
            SELECT VALUE(k)
              FROM KlienciObjTable k
             WHERE k.plec = p_plec
               AND (EXTRACT(YEAR FROM SYSDATE) - EXTRACT(YEAR FROM k.data_urodzenia))
                   BETWEEN p_wiek_szuk_od AND p_wiek_szuk_do
               AND (
                 p_orientacja = 'obojetnie'
                 OR k.orientacja_seksualna = p_orientacja
               )
               AND k.preferowany_min_wiek <= p_wiek_do
               AND k.preferowany_max_wiek >= p_wiek_od
             ORDER BY REGEXP_COUNT(
                 k.cechy,
                 '(' || REPLACE(p_cechy_zadane, ',', '|') || ')',
                 1,
                 'i'
             ) DESC;
    END IF;
END wyszukaj_klienta_po_cechach;




END PakietBiuro;
/


-- PakietKlient - uproszczony dla roli Client
CREATE OR REPLACE PACKAGE PakietKlient AS

    TYPE refCursor IS REF CURSOR;

    PROCEDURE pobierz_klientow(
        p_wynik OUT refCursor
    );


    PROCEDURE wyszukaj_klienta_po_cechach(
    p_cechy_zadane   IN VARCHAR2,   -- np. "wysoki, brunet"
    p_plec           IN VARCHAR2,   -- płeć poszukiwanej osoby
    p_wiek_szuk_od   IN NUMBER,     -- wiek minimalny poszukiwanej osoby
    p_wiek_szuk_do   IN NUMBER,     -- wiek maksymalny poszukiwanej osoby
    p_orientacja     IN VARCHAR2,   -- np. "kobieta", "mezczyzna", "obojetnie"
    p_wiek_od        IN NUMBER,     -- nasz wiek minimalny, który musi tolerować kandydat
    p_wiek_do        IN NUMBER,     -- nasz wiek maksymalny
    p_wynik          OUT refCursor
    );


END PakietKlient;
/

CREATE OR REPLACE PACKAGE BODY PakietKlient AS

    PROCEDURE pobierz_klientow(
        p_wynik OUT refCursor
    ) IS
    BEGIN
        OPEN p_wynik FOR
            SELECT VALUE(k)
            FROM KlienciObjTable k;  -- dostęp przez SELECT
    END pobierz_klientow;


PROCEDURE wyszukaj_klienta_po_cechach(
    p_cechy_zadane   IN VARCHAR2,   -- np. "wysoki, brunet"
    p_plec           IN VARCHAR2,   -- płeć poszukiwanej osoby
    p_wiek_szuk_od   IN NUMBER,     -- wiek minimalny poszukiwanej osoby
    p_wiek_szuk_do   IN NUMBER,     -- wiek maksymalny poszukiwanej osoby
    p_orientacja     IN VARCHAR2,   -- np. "kobieta", "mezczyzna", "obojetnie"
    p_wiek_od        IN NUMBER,     -- nasz wiek minimalny, który musi tolerować kandydat
    p_wiek_do        IN NUMBER,     -- nasz wiek maksymalny
    p_wynik          OUT refCursor
) IS
    v_count NUMBER;
BEGIN
    ----------------------------------------------------------------------------
    -- 1) Sprawdzenie czy istnieje klient spełniający warunki:
    ----------------------------------------------------------------------------
    SELECT COUNT(*)
      INTO v_count
      FROM KlienciObjTable k
     WHERE 
       -- (a) Płeć
       k.plec = p_plec
       -- (b) Wiek kandydata musi być w [p_wiek_szuk_od, p_wiek_szuk_do]
       AND (EXTRACT(YEAR FROM SYSDATE) - EXTRACT(YEAR FROM k.data_urodzenia))
           BETWEEN p_wiek_szuk_od AND p_wiek_szuk_do
       -- (c) Orientacja
       AND (
         p_orientacja = 'obojetnie'
         OR k.orientacja_seksualna = p_orientacja
       )
       -- (d)(e) Kandydat toleruje nasz wiek
       AND k.preferowany_min_wiek <= p_wiek_do
       AND k.preferowany_max_wiek >= p_wiek_od;

    IF v_count = 0 THEN
        DBMS_OUTPUT.PUT_LINE('Nie znaleziono klientów spełniających warunki.');
        OPEN p_wynik FOR SELECT 1 FROM DUAL WHERE 1=0; -- pusty kursor
    ELSE
        ----------------------------------------------------------------------------
        -- 2) Skoro są wyniki, otwieramy kursor z tymi samymi warunkami + sortowanie:
        ----------------------------------------------------------------------------
        OPEN p_wynik FOR
            SELECT VALUE(k)
              FROM KlienciObjTable k
             WHERE k.plec = p_plec
               AND (EXTRACT(YEAR FROM SYSDATE) - EXTRACT(YEAR FROM k.data_urodzenia))
                   BETWEEN p_wiek_szuk_od AND p_wiek_szuk_do
               AND (
                 p_orientacja = 'obojetnie'
                 OR k.orientacja_seksualna = p_orientacja
               )
               AND k.preferowany_min_wiek <= p_wiek_do
               AND k.preferowany_max_wiek >= p_wiek_od
             ORDER BY REGEXP_COUNT(
                 k.cechy,
                 '(' || REPLACE(p_cechy_zadane, ',', '|') || ')',
                 1,
                 'i'
             ) DESC;
    END IF;
END wyszukaj_klienta_po_cechach;

END PakietKlient;
/

    /************************************************************
      Obsługa bazy obiektowej (triggery, procedury, obsługa błędów i inne)
     ************************************************************/
     
-- Trigger sprawdzający niepełnoletnich klientów

CREATE OR REPLACE TRIGGER trg_check_underage
BEFORE INSERT OR UPDATE ON KlienciObjTable
FOR EACH ROW
DECLARE
    v_wiek NUMBER;
BEGIN
    v_wiek := TRUNC(MONTHS_BETWEEN(SYSDATE, :NEW.data_urodzenia) / 12);

    IF v_wiek < 18 THEN
        RAISE_APPLICATION_ERROR(-20012, 'Niepełnoletni użytkownicy nie są dozwoleni!');
    END IF;
END;
/

-- Trigger uniemożliwiający przypisanie tego samego klienta1 i klienta2 w RandkiObjTable

CREATE OR REPLACE TRIGGER trg_check_randka_self
BEFORE INSERT OR UPDATE ON RandkiObjTable
FOR EACH ROW
DECLARE
    v_id1 NUMBER;
    v_id2 NUMBER;
BEGIN

    SELECT DEREF(:NEW.klient1_ref).osoba_id,
           DEREF(:NEW.klient2_ref).osoba_id
      INTO v_id1, v_id2
      FROM DUAL;

    IF v_id1 = v_id2 THEN
        RAISE_APPLICATION_ERROR(-20001,
            'Ten sam klient nie może być klientem1 i klientem2!');
    END IF;
END;
/


-- Tabela do logowania operacji
CREATE TABLE LogOperacji (
    id_log        NUMBER GENERATED BY DEFAULT AS IDENTITY,
    nazwa_tabeli  VARCHAR2(50),
    typ_operacji  VARCHAR2(10),
    data_operacji TIMESTAMP DEFAULT SYSTIMESTAMP,
    szczegoly     CLOB,
    uzytkownik VARCHAR2(50)
);
/

-- Trigger logujący operacje na KlienciObjTable
CREATE OR REPLACE TRIGGER trg_log_operacji
AFTER INSERT OR UPDATE OR DELETE ON KlienciObjTable
FOR EACH ROW
BEGIN
    IF INSERTING THEN
        INSERT INTO LogOperacji (nazwa_tabeli, typ_operacji, szczegoly, uzytkownik)
        VALUES (
            'KlienciObjTable',
            'INSERT',
            'Dodano nowy rekord o ID: ' || :NEW.osoba_id,
            USER
        );
    ELSIF UPDATING THEN
        INSERT INTO LogOperacji (nazwa_tabeli, typ_operacji, szczegoly, uzytkownik)
        VALUES (
            'KlienciObjTable',
            'UPDATE',
            'Zaktualizowano rekord o ID: ' || :NEW.osoba_id,
            USER
        );
    ELSIF DELETING THEN
        INSERT INTO LogOperacji (nazwa_tabeli, typ_operacji, szczegoly, uzytkownik)
        VALUES (
            'KlienciObjTable',
            'DELETE',
            'Usunięto rekord o ID: ' || :OLD.osoba_id,
            USER
        );
    END IF;
END;
/

SELECT * FROM LogOperacji;
/



/************************************************************
      ROLE 
************************************************************/

-- Uprawnienia pełne do tabel obiektowych i logów, plus EXECUTE pakietu
CREATE ROLE Administrator;
GRANT ALL ON KlienciObjTable TO Administrator;
GRANT ALL ON RandkiObjTable TO Administrator;
GRANT ALL ON OpiekunowieObjTable TO Administrator;
GRANT ALL ON LogOperacji TO Administrator;
GRANT EXECUTE ON PakietBiuro TO Administrator;


-- Dodatkowe uprawnienia systemowe
GRANT CREATE ANY TABLE TO Administrator;
GRANT DROP ANY TABLE TO Administrator;
GRANT CREATE USER TO Administrator;
GRANT DROP USER TO Administrator;
GRANT GRANT ANY PRIVILEGE TO Administrator;

CREATE ROLE Employee;
-- Uprawnienia dla pracownika
GRANT SELECT, INSERT, UPDATE ON admin.KlienciObjTable TO Employee;
GRANT SELECT, INSERT ON admin.RandkiObjTable TO Employee;
GRANT SELECT ON admin.OpiekunowieObjTable TO Employee;
GRANT EXECUTE ON admin.PakietBiuro TO Employee;
GRANT EXECUTE ANY TYPE TO Employee;
GRANT SELECT, INSERT, UPDATE ON LogOperacji TO employee_user;


CREATE ROLE Client;
-- Uprawnienia dla klienta
GRANT SELECT ON admin.KlienciObjTable TO Client; 
GRANT EXECUTE ON admin.PakietKlient TO Client;
GRANT EXECUTE ANY TYPE TO Client;
GRANT EXECUTE ANY TYPE TO client_user;
GRANT EXECUTE ON admin.PakietKlient TO client_user;



-- Tworzenie użytkowników i przypisywanie ról
CREATE USER admin IDENTIFIED BY admin_password;
GRANT Administrator TO admin;

CREATE USER employee_user IDENTIFIED BY employee_password;
GRANT Employee TO employee_user;

CREATE USER client_user IDENTIFIED BY client_password;
GRANT Client TO client_user;







