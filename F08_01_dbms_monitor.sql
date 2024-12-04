BEGIN
    DBMS_MONITOR.SESSION_TRACE_ENABLE;
END;
/
SELECT * FROM SCOTT.emp e;
SELECT * FROM SCOTT.salgrade sg;

SELECT COUNT(*) FROM SH.costs;

UPDATE OE.customers SET credit_limit = credit_limit / 2;

SELECT * FROM SCOTT.dept d;
DELETE FROM SCOTT.dept WHERE deptno = 40;

SELECT SCOTT.topnsal(10) FROM DUAL;

ROLLBACK;
/
BEGIN
    DBMS_MONITOR.SESSION_TRACE_DISABLE;
END;
/
SELECT * FROM V$DIAG_INFO

C:\ORACLE\diag\rdbms\trainingglob\trainingglob\trace

tkprof C:\student\trace\trainingglob_ora_5092.trc c:\student\trace\trace1.txt sys=no sort=fchdsk
