CREATE TYPE t_string_list IS TABLE OF VARCHAR2(100);
/
CREATE OR REPLACE FUNCTION split_pipelined(p_s VARCHAR2, p_separator VARCHAR2)
RETURN t_string_list PIPELINED IS
    --res t_string_list := t_string_list();
    l_s VARCHAR2(1000);      
    l_pos NUMBER(5);   
    l_temp VARCHAR2(1000);
BEGIN
    l_s := p_s;
    l_pos := INSTR(l_s, p_separator);
    WHILE l_pos > 0 LOOP
        l_temp := SUBSTR(l_s, 1, l_pos - 1); 
        IF LENGTH(l_temp) > 0 THEN
            --res.EXTEND;            
            --res(res.LAST) := l_temp;
            PIPE ROW(l_temp);
        END IF;
        l_s := SUBSTR(l_s, l_pos + LENGTH(p_separator));
        l_pos := INSTR(l_s, p_separator);
    END LOOP;
    IF LENGTH(l_s) > 0 THEN
        --res.EXTEND;        
        --res(res.LAST) := l_s;
        PIPE ROW(l_s);
    END IF;
    RETURN /*res*/;
END split_pipelined;
/
SELECT * FROM TABLE(split_pipelined(',bbb,cc,d', ','));
SELECT * FROM split_pipelined('abc', ',');
SELECT * FROM split_pipelined('abc,,,def,ghi', ',');
SELECT * FROM split_pipelined('abc<sep><sep>def<sep>ghi<sep>', '<sep>') WHERE ROWNUM < 3;

