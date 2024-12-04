SELECT  OBJECT_TYPE, COUNT(*)
FROM ALL_OBJECTS
GROUP BY OBJECT_TYPE
ORDER BY OBJECT_TYPE;

C:\Installs\PLS3_Java\WebHelper.class
/
CREATE DIRECTORY javaext_dir AS 'C:\Installs\PLS3_Java';
/
SELECT * FROM ALL_DIRECTORIES;
/
CREATE JAVA CLASS USING BFILE(javaext_dir, 'WebHelper.class');
/
SELECT * FROM ALL_OBJECTS WHERE OBJECT_NAME LIKE '%WebHelper%';
/
ALTER JAVA CLASS "WebHelper" RESOLVE;
/
CREATE OR REPLACE FUNCTION geturl(p_url VARCHAR2, p_start NUMBER, p_end NUMBER)
RETURN VARCHAR2 IS 
LANGUAGE JAVA NAME 'WebHelper.getURL(java.lang.String, int, int) return java.lang.String';
/
SELECT geturl('http://mnbkozeparfolyam.hu/', 0, 1000) FROM DUAL;
SELECT geturl('https://masterfield.hu', 0, 100) FROM DUAL;
/*
the Permission ("java.net.SocketPermission" "masterfield.hu:80" "connect,resolve") 
has not been granted to SYSTEM. 
The PL/SQL to grant this is 
*/
/
BEGIN
  dbms_java.grant_permission( 'SYSTEM', 'SYS:java.net.SocketPermission', 'masterfield.hu:80', 'connect,resolve' );
END;
/

loadjava -f -user system/12345@training C:\Installs\PLS3_Java\WebHelper.class
