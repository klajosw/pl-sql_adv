C:\Oracle\oradata\TRAININGGLOB\training
/
CREATE TABLESPACE tbs_lob 
DATAFILE 'C:\Oracle\oradata\TRAININGGLOB\training\tbs_lob.DBF'
SIZE 100M SEGMENT SPACE MANAGEMENT AUTO;
/
CREATE TABLE exercises (
    id          NUMBER(6)       GENERATED BY DEFAULT AS IDENTITY NOT NULL,
    filename    VARCHAR2(100)   NOT NULL,
    content     CLOB            NOT NULL)
LOB(content) STORE AS SECUREFILE(TABLESPACE tbs_lob COMPRESS HIGH DEDUPLICATE);
/
CREATE DIRECTORY exercises_dir AS 'C:\Student\Exercises';
/
DECLARE
    l_dest_offset INTEGER;    l_src_offset INTEGER;
    l_warning INTEGER;        l_lang_context INTEGER;
    l_exf BFILE;              l_tempc CLOB;
    CURSOR cfiles IS
        SELECT COLUMN_VALUE FROM split(directory_list('C:\Student\Exercises'), ':');
BEGIN
    DELETE FROM exercises;
    FOR rfiles IN cfiles LOOP
        DBMS_OUTPUT.PUT_LINE(rfiles.COLUMN_VALUE);
        IF UPPER(rfiles.COLUMN_VALUE) LIKE '%.SQL' THEN
            l_exf := BFILENAME('EXERCISES_DIR', rfiles.COLUMN_VALUE);    
            DBMS_LOB.OPEN(l_exf, DBMS_LOB.FILE_READONLY);
            IF DBMS_LOB.GETLENGTH(l_exf) > 0 THEN --ne adjon hib�t �res bet�lt�sn�l
                DBMS_LOB.CREATETEMPORARY(l_tempc, TRUE);
                l_src_offset := 1; l_dest_offset := 1;
                l_lang_context := 0; l_warning := 0;
                DBMS_LOB.LOADCLOBFROMFILE(l_tempc, l_exf, DBMS_LOB.LOBMAXSIZE, 
                    l_dest_offset, l_src_offset, 873, l_lang_context, l_warning);
                INSERT INTO exercises (filename, content)
                VALUES (rfiles.COLUMN_VALUE, l_tempc);
                DBMS_LOB.FREETEMPORARY(l_tempc);
            END IF;    
            DBMS_LOB.CLOSE(l_exf);
        END IF;
    END LOOP;
END;
/
--m�sik megold�s
DECLARE
    l_dest_offset INTEGER;    l_src_offset INTEGER;
    l_warning INTEGER;        l_lang_context INTEGER;
    l_exf BFILE;              l_tempc CLOB;
    CURSOR cfiles IS
        SELECT COLUMN_VALUE FROM split(directory_list('C:\Student\Exercises'), ':');
BEGIN
    DELETE FROM exercises;
    FOR rfiles IN cfiles LOOP
        DBMS_OUTPUT.PUT_LINE(rfiles.COLUMN_VALUE);
        IF UPPER(rfiles.COLUMN_VALUE) LIKE '%.SQL' THEN
            l_exf := BFILENAME('EXERCISES_DIR', rfiles.COLUMN_VALUE);    
            DBMS_LOB.OPEN(l_exf, DBMS_LOB.FILE_READONLY);
            IF DBMS_LOB.GETLENGTH(l_exf) > 0 THEN --ne adjon hib�t �res bet�lt�sn�l
                INSERT INTO exercises (filename, content)
                VALUES (rfiles.COLUMN_VALUE, EMPTY_CLOB())
                RETURNING content INTO l_tempc;
                --DBMS_LOB.CREATETEMPORARY(l_tempc, TRUE);
                l_src_offset := 1; l_dest_offset := 1;
                l_lang_context := 0; l_warning := 0;
                DBMS_LOB.LOADCLOBFROMFILE(l_tempc, l_exf, DBMS_LOB.LOBMAXSIZE, 
                    l_dest_offset, l_src_offset, 873, l_lang_context, l_warning);
                --DBMS_LOB.FREETEMPORARY(l_tempc);
            END IF;    
            DBMS_LOB.CLOSE(l_exf);
        END IF;
    END LOOP;
END;
/

SELECT * FROM exercises;