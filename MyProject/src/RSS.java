import java.net.URL;  
import javax.xml.parsers.DocumentBuilder;  
import javax.xml.parsers.DocumentBuilderFactory;  
import org.w3c.dom.Document;  
import org.w3c.dom.Element;  
import org.w3c.dom.Node;  
import org.w3c.dom.NodeList;  
  
public class RSS {  
  
   private static RSS instance = null;  
  
   private URL rssURL;  
  
   private RSS() {}  
  
   public static RSS getInstance() {  
      if (instance == null)  
         instance = new RSS();  
      return instance;  
   }  
  
   public void setURL(URL url) {  
      rssURL = url;  
   }  
  
   public void writeFeed() {  
      try {  
         DocumentBuilder builder = DocumentBuilderFactory.newInstance().newDocumentBuilder();  
         Document doc = builder.parse(rssURL.openStream());  
  
         NodeList items = doc.getElementsByTagName("item");  
  
         for (int i = 0; i < items.getLength(); i++) {  
            Element item = (Element)items.item(i);  
            System.out.println(getValue(item, "title"));  
            System.out.println(getValue(item, "description"));  
            System.out.println(getValue(item, "link"));  
            System.out.println();  
         }  
      } catch (Exception e) {  
         e.printStackTrace();  
      }  
   }  
  
   public String getValue(Element parent, String nodeName) {  
      return parent.getElementsByTagName(nodeName).item(0).getFirstChild().getNodeValue();  
   }  
  
   public static void main(String[] args) {  
      try {  
         RSS reader = RSS.getInstance();  
         reader.setURL(new URL("https://trust.salesforce.com/rest/rss/EU2"));  
         reader.writeFeed();  
      } catch (Exception e) {  
         e.printStackTrace();  
      }  
   }  
}  