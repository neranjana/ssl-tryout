import java.io.BufferedReader;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.net.URL;

public class SimpleHttpClient {

    public static void main(String[] args) throws Exception {
        String trustStorePath = args[0];
        String keyStorePath = args[1];
        System.setProperty("javax.net.ssl.trustStore", trustStorePath);
        System.setProperty("javax.net.ssl.keyStore", keyStorePath);
        System.setProperty("javax.net.ssl.keyStoreType", "pkcs12");
        System.setProperty("javax.net.ssl.keyStorePassword", "donatellopass");
        URL url = new URL("https://test1.tmnt.local:8443/");
        try ( InputStream urlInput = url.openStream()) {
            BufferedReader in = new BufferedReader(
                    new InputStreamReader(urlInput));
            String inputLine;
            StringBuffer response = new StringBuffer();

            while ((inputLine = in.readLine()) != null) {
                response.append(inputLine).append("\n");
            }
            in.close();

            //print result
            System.out.println(response.toString());


        } catch (Exception e) {
            e.printStackTrace();
        }

    }
}
