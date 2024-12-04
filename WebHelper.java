import java.net.*;
import java.io.*;

public class WebHelper {
	
public static void main(String[] args) throws Exception {
	//teszt
	System.out.println(getURL("http://www.masterfield.hu", 0, 100));
}

public static String getURL(String urlstr, int start, int end) {
	try {
	        URL url = new URL(urlstr);
        	URLConnection yc = url.openConnection();
		String res = new String();
	        BufferedReader in = new BufferedReader(new InputStreamReader(
                                    yc.getInputStream()));
        	String inputLine;
	        while ((inputLine = in.readLine()) != null) 
			res = res + inputLine;	
	        in.close();
		return res.substring(start, end); 
	} catch (Exception e) {
		return e.getMessage();
	}
}
}