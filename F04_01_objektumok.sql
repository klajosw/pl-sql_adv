SELECT * FROM SCOTT.dept d;
/
CREATE OR REPLACE TYPE SCOTT.t_dept_obj IS OBJECT (
    deptno NUMBER(2),
    dname VARCHAR2(14),
    loc VARCHAR2(13),
    CONSTRUCTOR FUNCTION t_dept_obj(deptno NUMBER, dname VARCHAR2) RETURN SELF AS RESULT );
/
CREATE OR REPLACE TYPE BODY SCOTT.t_dept_obj IS
    CONSTRUCTOR FUNCTION t_dept_obj(deptno NUMBER, dname VARCHAR2) RETURN SELF AS RESULT IS
    BEGIN
        SELF.deptno := deptno;
        SELF.dname := UPPER(dname);
        RETURN;
    END;
END;
/
CREATE TABLE SCOTT.dept_obj OF SCOTT.t_dept_obj (deptno PRIMARY KEY);
/
INSERT INTO SCOTT.dept_obj
SELECT SCOTT.t_dept_obj(d.deptno, d.dname, d.loc) FROM SCOTT.dept d;
/
SELECT d.deptno, d.dname, d.loc FROM SCOTT.dept_obj d;
/
CREATE OR REPLACE TYPE SCOTT.t_emp_obj IS OBJECT (
    empno NUMBER(4),
    ename VARCHAR2(10),
    job VARCHAR2(9),
    mgr NUMBER(4),
    hire_date DATE,
    sal NUMBER(7,2),
    dept REF /*SCOTT.*/t_dept_obj,
    MEMBER FUNCTION get_total_sal RETURN NUMBER) NOT FINAL;
/
CREATE OR REPLACE TYPE BODY SCOTT.t_emp_obj IS
    MEMBER FUNCTION get_total_sal RETURN NUMBER IS
    BEGIN
        RETURN NVL(sal, 0);
    END;
END;    
/
CREATE TABLE SCOTT.emp_obj OF SCOTT.t_emp_obj (empno PRIMARY KEY);
/
CREATE OR REPLACE TYPE SCOTT.t_sales_obj UNDER SCOTT.t_emp_obj (
    comm NUMBER(7,2),
    OVERRIDING MEMBER FUNCTION get_total_sal RETURN NUMBER );
/
CREATE OR REPLACE TYPE BODY SCOTT.t_sales_obj IS
    OVERRIDING MEMBER FUNCTION get_total_sal RETURN NUMBER IS
    BEGIN
        RETURN NVL(sal, 0) + NVL(comm, 0);
    END;
END;
/
INSERT INTO SCOTT.emp_obj
SELECT SCOTT.t_emp_obj(e.empno, e.ename, e.job, e.mgr, e.hiredate, e.sal, REF(d))
FROM SCOTT.emp e JOIN SCOTT.dept_obj d ON e.deptno = d.deptno
WHERE e.job <> 'SALESMAN';
/
INSERT INTO SCOTT.emp_obj
SELECT SCOTT.t_sales_obj(e.empno, e.ename, e.job, e.mgr, e.hiredate, e.sal, REF(d), e.comm)
FROM SCOTT.emp e JOIN SCOTT.dept_obj d ON e.deptno = d.deptno
WHERE e.job = 'SALESMAN';
/
SELECT e.empno, e.ename, e.job, e.sal, e.dept, e.dept.dname FROM SCOTT.emp_obj e;

SELECT  e.empno, e.ename, e.job, e.sal, e.dept, e.dept.dname, 
        TREAT(VALUE(e) AS SCOTT.t_sales_obj).comm,
        e.get_total_sal()
FROM SCOTT.emp_obj e
WHERE   VALUE(e) IS OF (SCOTT.t_sales_obj);

SELECT * FROM ALL_TABLES WHERE OWNER = 'SCOTT';
SELECT * FROM DBA_TABLES WHERE OWNER = 'SCOTT';
SELECT * FROM ALL_TAB_COLS WHERE OWNER = 'SCOTT' AND TABLE_NAME LIKE '%OBJ';
SELECT * FROM ALL_OBJECT_TABLES WHERE OWNER IN ('SCOTT', 'OE');