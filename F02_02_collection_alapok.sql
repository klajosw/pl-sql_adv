/*
VARRAY          1..100 (minden elem letezik es elore megadod a meretet)
NESTED TABLE    5..10000 (lyukak is lehetnek es a meret dinamikus)
ASSOCIATIVE             (kulcs-ertek parok)
*/
DECLARE
    TYPE t_num_list IS TABLE OF NUMBER(5); --szamok sorozata, nested table
    colla t_num_list;
    TYPE t_assoc IS TABLE OF NUMBER(8) INDEX BY VARCHAR2(3);
    collb t_assoc;
BEGIN
    --colla := t_num_list(); --uresre inicializalas
    colla := t_num_list(5, 10, 15); --inicializalas 3 elemmel
    colla.EXTEND(2); --2 elem hozzaadasa (NULL)
    DBMS_OUTPUT.PUT_LINE(colla.COUNT);
    DBMS_OUTPUT.PUT_LINE(colla(3));
    colla(5) := 50;
    FOR i IN colla.FIRST..colla.LAST LOOP --ovatosan, mert lyukak eseten hibas!
        DBMS_OUTPUT.PUT_LINE(colla(i));
    END LOOP;
    collb('HUF') := 100000;
    collb('EUR') := 500;
    collb('USD') := 800;
    DBMS_OUTPUT.PUT_LINE(collb('EUR'));
END;
    