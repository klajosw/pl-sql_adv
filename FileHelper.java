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
