SELECT * FROM SCOTT.emp e WHERE e.mgr = 7839;
/
CREATE OR REPLACE PROCEDURE SCOTT.emp_tree
(p_empno SCOTT.emp.empno%TYPE, p_level NUMBER DEFAULT 1) IS
    --CURSOR cemp IS SELECT ....;
BEGIN
    --FOR emprec IN cemp LOOP
    DBMS_OUTPUT.PUT_LINE(LPAD('*', p_level*3, '+') || p_level || ' ' || p_empno);
    FOR emprec IN (SELECT e.empno, e.ename FROM SCOTT.emp e WHERE e.mgr = p_empno) LOOP
        SCOTT.emp_tree(emprec.empno, p_level + 1);        
    END LOOP;
END emp_tree;
/
BEGIN
    SCOTT.emp_tree(7839);
END;
/
CREATE OR REPLACE PROCEDURE SCOTT.emp_tree
(p_empno /*SCOTT.*/emp.empno%TYPE, p_level NUMBER DEFAULT 1) IS
    --CURSOR cemp IS SELECT ....;
BEGIN
    --FOR emprec IN cemp LOOP
    DBMS_OUTPUT.PUT_LINE(LPAD('*', p_level*3, '+') || p_level || ' ' || p_empno);
    FOR emprec IN (SELECT e.empno, e.ename FROM /*SCOTT.*/emp e WHERE e.mgr = p_empno) LOOP
        /*SCOTT.*/emp_tree(emprec.empno, p_level + 1);        
    END LOOP;
END emp_tree;
/
SELECT * FROM emp; --SCOTT felhasználóval mûködik
SELECT * FROM SCOTT.emp;
/
--STUDENT userrel:
SELECT * FROM SCOTT.emp; --STUDENT usernek: ORA-00942: table or view does not exist
/
BEGIN
    SCOTT.emp_tree(7839); --STUDENT usernek: PLS-00201: identifier 'SCOTT.EMP_TREE' must be declared
END;
/
--SYSTEM userrel:
GRANT EXECUTE ON SCOTT.emp_tree TO STUDENT; --Grant succeeded.
/
--STUDENT userrel:
SELECT * FROM SCOTT.emp; --STUDENT usernek: ORA-00942: table or view does not exist
/
BEGIN
    SCOTT.emp_tree(7839); --STUDENT userrel is sikeres
END;
/
CREATE OR REPLACE PROCEDURE SCOTT.emp_tree
(p_empno /*SCOTT.*/emp.empno%TYPE, p_level NUMBER DEFAULT 1) AUTHID CURRENT_USER /*DEFINER*/ IS
    --CURSOR cemp IS SELECT ....;
BEGIN
    --FOR emprec IN cemp LOOP
    DBMS_OUTPUT.PUT_LINE(LPAD('*', p_level*3, '+') || p_level || ' ' || p_empno);
    FOR emprec IN (SELECT e.empno, e.ename FROM /*SCOTT.*/emp e WHERE e.mgr = p_empno) LOOP
        /*SCOTT.*/emp_tree(emprec.empno, p_level + 1);        
    END LOOP;
END emp_tree;
/
--SYSTEM userrel:
BEGIN
    SCOTT.emp_tree(7839); --SYSTEM: ORA-06598: insufficient INHERIT PRIVILEGES privilege
END;
/
--STUDENT userrel:
BEGIN
    SCOTT.emp_tree(7839); --STUDENT: ORA-00942: table or view does not exist
END;
/
--SYSTEM userrel:
GRANT INHERIT PRIVILEGES ON USER SYSTEM TO SCOTT; --Grant succeeded.
/
BEGIN
    SCOTT.emp_tree(7839); --SYSTEM: ORA-00942: table or view does not exist
END;
/
CREATE OR REPLACE PROCEDURE SCOTT.emp_tree
(p_empno SCOTT.emp.empno%TYPE, p_level NUMBER DEFAULT 1) AUTHID CURRENT_USER /*DEFINER*/ IS
    --CURSOR cemp IS SELECT ....;
BEGIN
    --FOR emprec IN cemp LOOP
    DBMS_OUTPUT.PUT_LINE(LPAD('*', p_level*3, '+') || p_level || ' ' || p_empno);
    FOR emprec IN (SELECT e.empno, e.ename FROM SCOTT.emp e WHERE e.mgr = p_empno) LOOP
        SCOTT.emp_tree(emprec.empno, p_level + 1);        
    END LOOP;
END emp_tree;
/
BEGIN
    SCOTT.emp_tree(7839); --SYSTEM: sikeres
END;

