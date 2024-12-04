CREATE OR REPLACE FUNCTION SCOTT.topnsal(p_n NUMBER) RETURN NUMBER IS
    l_sum NUMBER(10,2);
BEGIN
    $IF DBMS_DB_VERSION.VERSION >= 12 $THEN
    SELECT SUM(sal) INTO l_sum FROM 
        (   SELECT e.sal FROM SCOTT.emp e ORDER BY e.sal DESC 
            OFFSET 0 ROWS FETCH NEXT p_n ROWS ONLY );
    $ELSE
    akármilyen hibás rész lehet itt
    SELECT SUM(sal) INTO l_sum FROM 
        (   SELECT e.sal FROM SCOTT.emp e ORDER BY e.sal DESC )
    WHERE ROWNUM <= p_n;
    $END    
    RETURN l_sum;            
END topnsal;

