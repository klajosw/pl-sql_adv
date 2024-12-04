--2-6. fizetés
SELECT * FROM SCOTT.emp e ORDER BY e.sal DESC 
OFFSET 1 ROWS FETCH NEXT 5 ROWS ONLY;

--további egyforma értékek listázása
SELECT * FROM SCOTT.emp e ORDER BY e.sal DESC 
OFFSET 0 ROWS FETCH NEXT 2 ROWS WITH TIES;
/
CREATE OR REPLACE FUNCTION SCOTT.topnsal(p_n NUMBER) RETURN NUMBER IS
    l_sum NUMBER(10,2);
BEGIN
    SELECT SUM(sal) INTO l_sum FROM 
        (   SELECT e.sal FROM SCOTT.emp e ORDER BY e.sal DESC 
            OFFSET 0 ROWS FETCH NEXT p_n ROWS ONLY );
    RETURN l_sum;        
END topnsal;
/
SELECT SCOTT.topnsal(5) FROM DUAL;

