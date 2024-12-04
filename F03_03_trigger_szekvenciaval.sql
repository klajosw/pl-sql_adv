SELECT * FROM SCOTT.bonus;
/
ALTER TABLE SCOTT.bonus ADD bonus_id NUMBER(6) NOT NULL;
/
ALTER TABLE SCOTT.bonus ADD CONSTRAINT pk_bonus PRIMARY KEY (bonus_id);
/
CREATE SEQUENCE SCOTT.seq_bonus;
/
CREATE OR REPLACE TRIGGER SCOTT.tr_bonus_i 
BEFORE INSERT ON SCOTT.bonus FOR EACH ROW
BEGIN
    --IF :new.bonus_id IS NULL THEN
    :new.bonus_id := /*SCOTT.*/seq_bonus.NEXTVAL;
END;
/
INSERT INTO SCOTT.bonus (ename) VALUES ('A'); --1
INSERT INTO SCOTT.bonus (ename) VALUES ('B'); --2
INSERT INTO SCOTT.bonus (ename) VALUES ('C'); --3
INSERT INTO SCOTT.bonus (bonus_id, ename) VALUES (10, 'D'); --4
INSERT INTO SCOTT.bonus (bonus_id, ename) VALUES (1, 'E'); --5
SELECT * FROM SCOTT.bonus;
ROLLBACK;
INSERT INTO SCOTT.bonus (ename) VALUES ('F'); --6
INSERT INTO SCOTT.bonus (ename) VALUES ('G1234567890123456789'); --nem veszik el sorszám, a trigger még nem fut
INSERT INTO SCOTT.bonus (ename) VALUES ('H'); --7
COMMIT;
