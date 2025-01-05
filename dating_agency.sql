    /************************************************************
      BIURO MATRYMONIALNE
     ************************************************************/
SET SERVEROUTPUT ON; 

    /************************************************************
      Definicje Typów i Ciał
     ************************************************************/
     
-- Definicja TypAdres
CREATE OR REPLACE TYPE TypAdres AS OBJECT (
    ulica          VARCHAR2(100),
    nr_domu        VARCHAR2(10),
    nr_mieszkania  VARCHAR2(10),
    kod_pocztowy   VARCHAR2(10),
    miasto         VARCHAR2(50),
    MEMBER FUNCTION pokaz_adres RETURN VARCHAR2
);
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

-- Definicja TypKlient
CREATE OR REPLACE TYPE TypKlient UNDER TypOsoba (
    status_klienta   VARCHAR2(20),  
    preferencje      VARCHAR2(200),  
    MEMBER FUNCTION pelne_dane RETURN VARCHAR2
);
/

CREATE OR REPLACE TYPE BODY TypKlient AS
    MEMBER FUNCTION pelne_dane RETURN VARCHAR2 IS
    BEGIN
        RETURN 'Klient: ' || imie || ' ' || nazwisko 
               || ', preferencje: ' || preferencje
               || ', status: ' || status_klienta;
    END;
END;
/

-- Definicja TypRandka
CREATE OR REPLACE TYPE TypRandka AS OBJECT (
    randka_id       NUMBER,
    data_spotkania  DATE,
    miejsce         VARCHAR2(100),
    klient1_ref     REF TypKlient, 
    klient2_ref     REF TypKlient, 
    MEMBER FUNCTION opis RETURN VARCHAR2
);
/

CREATE OR REPLACE TYPE BODY TypRandka AS
    MEMBER FUNCTION opis RETURN VARCHAR2 IS
    BEGIN
        RETURN 'Randka ID: ' || randka_id 
               || ', data: ' || TO_CHAR(data_spotkania, 'YYYY-MM-DD')
               || ', miejsce: ' || miejsce;
    END opis;
END;
/

-- Definicja KlientRefTab (NESTED TABLE)
CREATE OR REPLACE TYPE KlientRefTab AS TABLE OF REF TypKlient;
/

-- Definicja TypOpiekun
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

-- Tabela KlienciObjTable
CREATE TABLE KlienciObjTable OF TypKlient (
    CONSTRAINT pk_klienci_obj PRIMARY KEY (osoba_id)
)
OBJECT IDENTIFIER IS PRIMARY KEY;
/

-- Tabela RandkiObjTable
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
ALTER TABLE podopieczni_storage
ADD CONSTRAINT pk_podopieczni PRIMARY KEY (NESTED_TABLE_ID);


/
    /************************************************************
      Tworzenie Pakietów (implementacha logiki biznesowej)
     ************************************************************/
CREATE OR REPLACE PACKAGE PakietBiuro AS
    
    TYPE refCursorKlient IS REF CURSOR;
    TYPE refCursorOpiekun IS REF CURSOR;
    TYPE refCursorRandka  IS REF CURSOR;

    PROCEDURE dodaj_klienta(
        p_osoba_id       NUMBER,
        p_imie           VARCHAR2,
        p_nazwisko       VARCHAR2,
        p_data_ur        DATE,
        p_ulica          VARCHAR2,
        p_nr_domu        VARCHAR2,
        p_nr_mieszkania  VARCHAR2,
        p_kod_pocztowy   VARCHAR2,
        p_miasto         VARCHAR2,
        p_status         VARCHAR2,
        p_preferencje    VARCHAR2
    );

    PROCEDURE wyswietl_klienta(p_osoba_id NUMBER);

    FUNCTION pobierz_klientow RETURN refCursorKlient;


    PROCEDURE dodaj_opiekuna(
        p_opiekun_id     NUMBER,
        p_imie           VARCHAR2,
        p_nazwisko       VARCHAR2
    );

    PROCEDURE dodaj_klienta_do_opiekuna(
        p_opiekun_id NUMBER,
        p_osoba_id   NUMBER
    );

    FUNCTION pobierz_opiekunow RETURN refCursorOpiekun;


    PROCEDURE dodaj_randke(
        p_randka_id      NUMBER,
        p_data_spotkania DATE,
        p_miejsce        VARCHAR2,
        p_klient1_id     NUMBER,
        p_klient2_id     NUMBER
    );

    FUNCTION pobierz_randki RETURN refCursorRandka;

END PakietBiuro;
/

CREATE OR REPLACE PACKAGE BODY PakietBiuro AS

    /************************************************************
      1) OBSŁUGA KLIENTÓW
     ************************************************************/
    PROCEDURE dodaj_klienta(
        p_osoba_id       NUMBER,
        p_imie           VARCHAR2,
        p_nazwisko       VARCHAR2,
        p_data_ur        DATE,
        p_ulica          VARCHAR2,
        p_nr_domu        VARCHAR2,
        p_nr_mieszkania  VARCHAR2,
        p_kod_pocztowy   VARCHAR2,
        p_miasto         VARCHAR2,
        p_status         VARCHAR2,
        p_preferencje    VARCHAR2
    ) IS
    BEGIN
        INSERT INTO KlienciObjTable
        VALUES (
            TypKlient(
                p_osoba_id,
                p_imie,
                p_nazwisko,
                p_data_ur,
                TypAdres(p_ulica, p_nr_domu, p_nr_mieszkania, p_kod_pocztowy, p_miasto),
                p_status,
                p_preferencje
            )
        );
        DBMS_OUTPUT.PUT_LINE('Dodano nowego klienta o ID=' || p_osoba_id);
    EXCEPTION
        WHEN DUP_VAL_ON_INDEX THEN
            DBMS_OUTPUT.PUT_LINE('Błąd: Klient o ID='||p_osoba_id||' już istnieje!');
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
            DBMS_OUTPUT.PUT_LINE('Błąd (wyswietl_klienta): ' || SQLERRM);
    END wyswietl_klienta;


    FUNCTION pobierz_klientow RETURN refCursorKlient IS
        v_cursor refCursorKlient;
    BEGIN

        OPEN v_cursor FOR
            SELECT VALUE(k)
            FROM KlienciObjTable k;
        RETURN v_cursor;
    END pobierz_klientow;



    /************************************************************
      2) OBSŁUGA OPIEKUNÓW
     ************************************************************/
    PROCEDURE dodaj_opiekuna(
        p_opiekun_id NUMBER,
        p_imie       VARCHAR2,
        p_nazwisko   VARCHAR2
    ) IS
    BEGIN
        INSERT INTO OpiekunowieObjTable
        VALUES(
            TypOpiekun(
                opiekun_id   => p_opiekun_id,
                imie         => p_imie,
                nazwisko     => p_nazwisko,
                podopieczni  => KlientRefTab()  
            )
        );

        DBMS_OUTPUT.PUT_LINE('Dodano nowego opiekuna o ID=' || p_opiekun_id);
    EXCEPTION
        WHEN DUP_VAL_ON_INDEX THEN
            DBMS_OUTPUT.PUT_LINE('Błąd: Opiekun o ID='||p_opiekun_id||' już istnieje!');
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Błąd (dodaj_opiekuna): ' || SQLERRM);
    END dodaj_opiekuna;


    PROCEDURE dodaj_klienta_do_opiekuna(
        p_opiekun_id NUMBER,
        p_osoba_id   NUMBER
    ) IS
        v_opiekun  TypOpiekun; 
        v_ref_kl   REF TypKlient;
        idx        PLS_INTEGER;
    BEGIN
        SELECT VALUE(o)
        INTO v_opiekun
        FROM OpiekunowieObjTable o
        WHERE o.opiekun_id = p_opiekun_id;

        SELECT REF(k)
        INTO v_ref_kl
        FROM KlienciObjTable k
        WHERE k.osoba_id = p_osoba_id;

        v_opiekun.podopieczni.EXTEND(1);
        idx := v_opiekun.podopieczni.LAST;
        v_opiekun.podopieczni(idx) := v_ref_kl;

        UPDATE OpiekunowieObjTable o
           SET VALUE(o) = v_opiekun
         WHERE o.opiekun_id = p_opiekun_id;

        DBMS_OUTPUT.PUT_LINE('Dodano klienta o ID='||p_osoba_id||
                             ' do opiekuna ID='||p_opiekun_id);

    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            DBMS_OUTPUT.PUT_LINE('Brak opiekuna lub klienta o podanym ID!');
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Błąd (dodaj_klienta_do_opiekuna): ' || SQLERRM);
    END dodaj_klienta_do_opiekuna;


    FUNCTION pobierz_opiekunow RETURN refCursorOpiekun IS
        v_cursor refCursorOpiekun;
    BEGIN
        OPEN v_cursor FOR
            SELECT VALUE(o)
            FROM OpiekunowieObjTable o;
        RETURN v_cursor;
    END pobierz_opiekunow;



    /************************************************************
      3) OBSŁUGA RANDKI
     ************************************************************/
    PROCEDURE dodaj_randke(
        p_randka_id      NUMBER,
        p_data_spotkania DATE,
        p_miejsce        VARCHAR2,
        p_klient1_id     NUMBER,
        p_klient2_id     NUMBER
    ) IS
        v_kl1 REF TypKlient;
        v_kl2 REF TypKlient;
    BEGIN
        SELECT REF(k)
        INTO v_kl1
        FROM KlienciObjTable k
        WHERE k.osoba_id = p_klient1_id;
        
        SELECT REF(k)
        INTO v_kl2
        FROM KlienciObjTable k
        WHERE k.osoba_id = p_klient2_id;

        IF p_data_spotkania < SYSDATE THEN
            RAISE_APPLICATION_ERROR(-20003, 'Data spotkania nie może być w przeszłości!');
        END IF;
        
        INSERT INTO RandkiObjTable
        VALUES (
            TypRandka(
                p_randka_id,
                p_data_spotkania,
                p_miejsce,
                v_kl1,
                v_kl2
            )
        );
        DBMS_OUTPUT.PUT_LINE('Dodano randkę o ID=' || p_randka_id);

    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            DBMS_OUTPUT.PUT_LINE('Błąd: nie znaleziono jednego z klientów!');
        WHEN DUP_VAL_ON_INDEX THEN
            DBMS_OUTPUT.PUT_LINE('Błąd: Randka o ID='||p_randka_id||' już istnieje!');
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Błąd (dodaj_randke): ' || SQLERRM);
    END dodaj_randke;


    FUNCTION pobierz_randki RETURN refCursorRandka IS
        v_cursor refCursorRandka;
    BEGIN
        OPEN v_cursor FOR
            SELECT VALUE(r)
            FROM RandkiObjTable r;
        RETURN v_cursor;
    END pobierz_randki;

END PakietBiuro;
/
    /************************************************************
      Obsługa bazy obiektowej (triggery, procedury, obsługa błędów i inne)
     ************************************************************/
     
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

CREATE OR REPLACE TRIGGER trg_check_data_urodzenia
BEFORE INSERT OR UPDATE ON KlienciObjTable
FOR EACH ROW
BEGIN
    IF :NEW.data_urodzenia > SYSDATE THEN
        RAISE_APPLICATION_ERROR(-20002, 'Data urodzenia nie może być w przyszłości!');
    END IF;
END;
/

CREATE TABLE LogOperacji (
    id_log        NUMBER GENERATED BY DEFAULT AS IDENTITY,
    nazwa_tabeli  VARCHAR2(50),
    typ_operacji  VARCHAR2(10),
    data_operacji TIMESTAMP DEFAULT SYSTIMESTAMP,
    szczegoly     CLOB
);
/
CREATE OR REPLACE TRIGGER trg_log_operacji
AFTER INSERT OR UPDATE OR DELETE ON KlienciObjTable
FOR EACH ROW
BEGIN
    IF INSERTING THEN
        INSERT INTO LogOperacji (nazwa_tabeli, typ_operacji, szczegoly)
        VALUES (
            'KlienciObjTable',
            'INSERT',
            'Dodano nowy rekord o ID: ' || :NEW.osoba_id
        );
    ELSIF UPDATING THEN
        INSERT INTO LogOperacji (nazwa_tabeli, typ_operacji, szczegoly)
        VALUES (
            'KlienciObjTable',
            'UPDATE',
            'Zaktualizowano rekord o ID: ' || :NEW.osoba_id
        );
    ELSIF DELETING THEN
        INSERT INTO LogOperacji (nazwa_tabeli, typ_operacji, szczegoly)
        VALUES (
            'KlienciObjTable',
            'DELETE',
            'Usunięto rekord o ID: ' || :OLD.osoba_id
        );
    END IF;
END;

/


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
    /************************************************************
      Wypełnianie tabel danymi oraz testowanie przyjętych założeń
     ************************************************************/

BEGIN
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
        p_preferencje    => 'kino, spacery'
    );

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
        p_preferencje    => 'muzyka, taniec'
    );
END;
/

BEGIN
    PakietBiuro.dodaj_opiekuna(
        p_opiekun_id => 1,
        p_imie       => 'Magdalena',
        p_nazwisko   => 'Kowalska'
    );

    PakietBiuro.dodaj_klienta_do_opiekuna(
        p_opiekun_id => 1,
        p_osoba_id   => 1
    );

    PakietBiuro.dodaj_klienta_do_opiekuna(
        p_opiekun_id => 1,
        p_osoba_id   => 2
    );
END;
/

BEGIN
    -- Próba dodania klienta z przyszłą datą urodzenia (powinien zostać zgłoszony ERROR)
    PakietBiuro.dodaj_klienta(
        p_osoba_id       => 3,
        p_imie           => 'Przyszły',
        p_nazwisko       => 'Klient',
        p_data_ur        => SYSDATE + 1,  -- Data w przyszłości!
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

BEGIN
    -- Wyświetlenie danych istniejącego klienta
    PakietBiuro.wyswietl_klienta(p_osoba_id => 1);

    -- Próba wyświetlenia nieistniejącego klienta
    PakietBiuro.wyswietl_klienta(p_osoba_id => 999);
END;
/

BEGIN
    PakietBiuro.dodaj_opiekuna(
        p_opiekun_id => 2,
        p_imie       => 'Marcin',
        p_nazwisko   => 'Opiekun'
    );

    -- Przypisanie klientów do opiekuna
    PakietBiuro.dodaj_klienta_do_opiekuna(p_opiekun_id => 2, p_osoba_id => 1);
    PakietBiuro.dodaj_klienta_do_opiekuna(p_opiekun_id => 2, p_osoba_id => 2);

    -- Próba przypisania nieistniejącego klienta
    PakietBiuro.dodaj_klienta_do_opiekuna(p_opiekun_id => 2, p_osoba_id => 999);
END;
/

BEGIN
    PakietBiuro.dodaj_randke(
        p_randka_id      => 1,
        p_data_spotkania => SYSDATE + 1,
        p_miejsce        => 'Restauracja',
        p_klient1_id     => 1,
        p_klient2_id     => 2
    );

    -- Próba dodania randki z tym samym klientem (powinien zostać zgłoszony ERROR)
    PakietBiuro.dodaj_randke(
        p_randka_id      => 2,
        p_data_spotkania => SYSDATE + 1,
        p_miejsce        => 'Park',
        p_klient1_id     => 1,
        p_klient2_id     => 1
    );
END;
/

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

SELECT * FROM LogOperacji;

/

/************************************************************
      ROLE 
     ************************************************************/

--  Administrator (dowolne uprawnienia)
CREATE ROLE Administrator;

GRANT ALL ON KlienciObjTable TO Administrator;
GRANT ALL ON RandkiObjTable TO Administrator;
GRANT ALL ON OpiekunowieObjTable TO Administrator;
GRANT ALL ON podopieczni_storage TO Administrator;
GRANT ALL ON LogOperacji TO Administrator;
GRANT EXECUTE ON PakietBiuro TO Administrator;

GRANT CREATE ANY TABLE TO Administrator;
GRANT DROP ANY TABLE TO Administrator;
GRANT CREATE USER TO Administrator;
GRANT DROP USER TO Administrator;
GRANT GRANT ANY PRIVILEGE TO Administrator;

--Employee (Brak możliwości usuwania danych i modyfikowania struktur bazy)
CREATE ROLE Employee;


GRANT SELECT, INSERT, UPDATE ON KlienciObjTable TO Employee;
GRANT SELECT, INSERT ON RandkiObjTable TO Employee;
GRANT SELECT ON OpiekunowieObjTable TO Employee;
GRANT EXECUTE ON PakietBiuro TO Employee;

-- Tworzenie użytkownika admin i emp
CREATE USER admin IDENTIFIED BY admin_password;
GRANT Administrator TO admin;

CREATE USER employee IDENTIFIED BY employee_password;
GRANT Employee TO employee;

