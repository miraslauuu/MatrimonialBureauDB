    /************************************************************
                        WYŚWIETLANIE DANCYH
                            (KLIENT)
     ************************************************************/


SET SERVEROUTPUT ON;


DECLARE
    v_cursor admin.PakietKlient.refCursor;
    v_klient admin.TypKlient;
BEGIN
    -- Wywołanie procedury z parametrem OUT (typ REF CURSOR)
    admin.PakietKlient.pobierz_klientow(v_cursor);

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
DECLARE
    v_cursor admin.PakietKlient.refCursor;
    v_klient admin.TypKlient;
BEGIN
    admin.PakietKlient.wyszukaj_klienta_po_cechach(
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

