SELECT * FROM SCOTT.dept d;
/
CREATE TABLE SCOTT.dept_audit
(   event_date  TIMESTAMP DEFAULT SYSTIMESTAMP NOT NULL,
    event_user  VARCHAR2(30) DEFAULT USER NOT NULL,
    operation   CHAR(1) NOT NULL CONSTRAINT ck_dept_audit_operation CHECK (operation IN ('I', 'U', 'D')),
    deptno      NUMBER(2) NOT NULL,
    event       VARCHAR2(100) NOT NULL  );
/
CREATE OR REPLACE TRIGGER SCOTT.tr_dept_audit
AFTER INSERT OR UPDATE OR DELETE ON SCOTT.dept FOR EACH ROW 
BEGIN
    IF INSERTING THEN
        INSERT INTO /*SCOTT.*/dept_audit (operation, deptno, event)
        VALUES ('I', :new.deptno, 'DNAME=' || :new.dname || ',LOC=' || :new.loc);
    ELSIF UPDATING THEN
        INSERT INTO SCOTT.dept_audit (operation, deptno, event)
        VALUES ('U', :new.deptno, 
            'DNAME=' || CASE WHEN :old.dname <> :new.dname THEN 
                            :old.dname || '=>' || :new.dname 
                            ELSE 'NOTCHANGED' END ||
            ',LOC=' || CASE WHEN :old.loc <> :new.loc THEN
                            :old.loc || '=>' || :new.loc
                            ELSE 'NOTCHANGED' END);
    ELSIF DELETING THEN
        INSERT INTO SCOTT.dept_audit (operation, deptno, event)
        VALUES ('D', :old.deptno, 'DNAME=' || :old.dname || ',LOC=' || :old.loc);
    END IF;
END;
/
INSERT INTO SCOTT.dept VALUES (50, 'TRAINING', 'BUDAPEST');
UPDATE SCOTT.dept SET loc = loc || '2';
DELETE FROM SCOTT.dept WHERE deptno = 50;
SELECT * FROM SCOTT.dept_audit;
ROLLBACK;

DELETE FROM SCOTT.dept_audit;
COMMIT;

INSERT INTO SCOTT.dept VALUES (10, 'TRAINING', 'BUDAPEST');
INSERT INTO SCOTT.dept VALUES (50, 'TRAINING123456789', 'BUDAPEST');
