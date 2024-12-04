SELECT  OBJECT_TYPE, COUNT(*)
FROM ALL_OBJECTS
GROUP BY OBJECT_TYPE
ORDER BY OBJECT_TYPE;

C:\Installs\PLS3_Java\FileHelper.java
/
CREATE JAVA SOURCE NAMED "FileHelper" AS
import java.io.File;
public class FileHelper {
  public static String dirList(String dir) {
    File f = null;
    String[] paths;
    String dirlist = new String();
    try {    
      f = new File(dir);
      paths = f.list();
      for(String path:paths) {
        dirlist = dirlist + ":" + path;
      }
    } catch(Exception e) {
        dirlist = e.toString();
    }      
    return dirlist;
  } 
}
/
SELECT * FROM ALL_OBJECTS WHERE OBJECT_NAME LIKE '%FileHelper%';
/
--Hivatkozások feloldása, ha INVALID
ALTER JAVA CLASS "FileHelper" COMPILE;
ALTER JAVA CLASS "FileHelper" RESOLVE;

SELECT * FROM ALL_SOURCE WHERE NAME LIKE '%FileHelper%';
/
--Publikálás
CREATE OR REPLACE FUNCTION directory_list(p_dir VARCHAR2) 
RETURN VARCHAR2 IS LANGUAGE JAVA
NAME 'FileHelper.dirList(java.lang.String) return java.lang.String';
/
SELECT directory_list('C:\Installs') FROM DUAL; --szerveroldali könyvtár listázás
SELECT directory_list('Z:\') FROM DUAL; --Oracle processt futtató felhasználónak nincs Z meghajtója

GRANT EXECUTE ON directory_list TO STUDENT;
SELECT SYSTEM.directory_list('C:\Installs') FROM DUAL;

SELECT * FROM split(directory_list('C:\Installs'), ':');

