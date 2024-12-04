SELECT * FROM PM.print_media
WHERE ad_sourcetext LIKE '%Price%';

SELECT * FROM ALL_DIRECTORIES
/
DECLARE
    l_dirobj VARCHAR2(30);
    l_file VARCHAR2(200);
    l_path VARCHAR2(200);
    CURSOR cpm IS SELECT product_id, ad_graphic FROM PM.print_media;
BEGIN
    FOR rpm IN cpm LOOP
        DBMS_OUTPUT.PUT_LINE(rpm.product_id);
        DBMS_LOB.filegetname(rpm.ad_graphic, l_dirobj, l_file);
        DBMS_OUTPUT.PUT_LINE(l_dirobj);
        DBMS_OUTPUT.PUT_LINE(l_file);
        SELECT directory_path INTO l_path FROM ALL_DIRECTORIES 
        WHERE directory_name = l_dirobj;
        DBMS_OUTPUT.PUT_LINE(l_path);
        IF DBMS_LOB.fileexists(rpm.ad_graphic) = 0 THEN
            DBMS_OUTPUT.PUT_LINE('Nem létezik!');
        ELSE    
            DBMS_OUTPUT.PUT_LINE('Létezik!');
        END IF;    
    END LOOP;
END;
