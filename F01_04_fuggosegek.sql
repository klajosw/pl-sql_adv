SELECT * FROM ALL_DEPENDENCIES WHERE OWNER = 'SCOTT';

C:\Installs\WINDOWS.X64_193000_db_home\rdbms\admin\utldtree.sql

/
BEGIN
    deptree_fill('TABLE', 'SCOTT', 'EMP');
END;
/
SELECT * FROM deptree;
SELECT * FROM ideptree;
/
SELECT * FROM ALL_SOURCE WHERE OWNER = 'SCOTT'
AND UPPER(TEXT) LIKE '%EMP%';
