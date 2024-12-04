CREATE OR REPLACE FUNCTION SCOTT.topnsal(p_n NUMBER) RETURN NUMBER IS
    l_sum NUMBER(10,2);
BEGIN
    SELECT SUM(sal) INTO l_sum FROM 
        (   SELECT e.sal FROM SCOTT.emp e ORDER BY e.sal DESC 
            OFFSET 0 ROWS FETCH NEXT p_n ROWS ONLY );
    RETURN l_sum;        
END topnsal;
/
CREATE OR REPLACE FUNCTION SCOTT.topnsal(p_n NUMBER) RETURN NUMBER IS
    l_sum NUMBER(10,2);
    l_dummy CHAR(1); --nem "veszi észre"
BEGIN
    SELECT SUM(sal) INTO l_sum FROM  --észleli a "fel nem használt" értékadást
        (   SELECT e.sal FROM SCOTT.emp e ORDER BY e.sal DESC 
            OFFSET 0 ROWS FETCH NEXT p_n ROWS ONLY );
    RETURN 10;        
END topnsal;
/
SELECT SCOTT.topnsal(5) FROM DUAL;
/
SELECT * FROM ALL_ERRORS;
SELECT * FROM USER_ERRORS;

SELECT * FROM ALL_OBJECTS 
WHERE OWNER = 'SCOTT' AND OBJECT_TYPE IN ('FUNCTION', 'PROCEDURE');
/
CREATE OR REPLACE PROCEDURE SCOTT.topnsal_caller IS
BEGIN
    DBMS_OUTPUT.PUT_LINE(SCOTT.topnsal(10));
END topnsal_caller;
/
BEGIN
    SCOTT.topnsal_caller;
END;
/
ALTER PROCEDURE SCOTT.topnsal_caller COMPILE;
/
SELECT NAME, PLSQL_WARNINGS FROM ALL_PLSQL_OBJECT_SETTINGS WHERE OWNER = 'SCOTT';
/
ALTER SESSION SET PLSQL_WARNINGS='ENABLE:ALL';
/
ALTER PROCEDURE SCOTT.topnsal_caller COMPILE;
/
/*
PLW-05018: unit TOPNSAL_CALLER omitted optional AUTHID clause; 
default value DEFINER used
*/

