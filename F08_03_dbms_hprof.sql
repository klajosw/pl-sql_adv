CREATE DIRECTORY plshprof_dir AS 'C:\Student\Trace';

--SYS (TRAINING) userrel:
GRANT EXECUTE ON DBMS_HPROF TO SYSTEM;

--SYSTEM userrel
BEGIN
    DBMS_HPROF.START_PROFILING('PLSHPROF_DIR', 'hproftrace1.txt');
END;        
/
SELECT * FROM SCOTT.emp e;
SELECT * FROM SCOTT.salgrade sg;
SELECT COUNT(*) FROM SH.costs;
UPDATE OE.customers SET credit_limit = credit_limit / 2;
SELECT * FROM SCOTT.dept d;
DELETE FROM SCOTT.dept WHERE deptno = 40;
SELECT SCOTT.topnsal(10) FROM DUAL;
/
BEGIN
    SCOTT.topnsal_caller;
END;
/
BEGIN
    DBMS_HPROF.STOP_PROFILING;
END;
/
plshprof -output C:\Student\Trace\hproftrace1 C:\Student\Trace\hproftrace1.txt
/
CREATE OR REPLACE FUNCTION integersum(p_n NUMBER) RETURN NUMBER IS
    s NUMBER := 0; i NUMBER := 1;
BEGIN
    LOOP
        s := s + i;
        EXIT WHEN i = p_n;
        i := i + 1;
    END LOOP;
    RETURN s;
END;
/
CREATE OR REPLACE PROCEDURE integersum_caller IS
BEGIN
    DBMS_OUTPUT.PUT_LINE(integersum(10000000));
END;
/
BEGIN
    DBMS_HPROF.START_PROFILING('PLSHPROF_DIR', 'integersum_interpreted.trc');
    integersum_caller;
    DBMS_HPROF.STOP_PROFILING;
END; 
/
ALTER FUNCTION integersum COMPILE PLSQL_CODE_TYPE=NATIVE;
/
BEGIN
    DBMS_HPROF.START_PROFILING('PLSHPROF_DIR', 'integersum_native.trc');
    integersum_caller;
    DBMS_HPROF.STOP_PROFILING;
END; 
/
plshprof -output C:\Student\Trace\interpreted C:\Student\Trace\integersum_interpreted.trc
plshprof -output C:\Student\Trace\native C:\Student\Trace\integersum_native.trc
/
SELECT * FROM ALL_PLSQL_OBJECT_SETTINGS WHERE NAME LIKE '%INTEGER%';
