package nl.nn.group.hof.integration.adapter;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.apache.http.HttpResponse;
import org.apache.http.auth.AuthScope;
import org.apache.http.auth.UsernamePasswordCredentials;
import org.apache.http.client.CredentialsProvider;
import org.apache.http.client.HttpClient;
import org.apache.http.client.methods.HttpGet;
import org.apache.http.impl.client.BasicCredentialsProvider;
import org.apache.http.impl.client.HttpClientBuilder;
import org.apache.http.impl.client.HttpClients;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.http.client.ClientHttpRequestFactory;
import org.springframework.http.client.HttpComponentsClientHttpRequestFactory;
import org.springframework.http.converter.json.MappingJackson2HttpMessageConverter;
import org.springframework.http.converter.xml.MappingJackson2XmlHttpMessageConverter;
import org.springframework.stereotype.Component;
import org.springframework.web.client.RestTemplate;
import org.w3c.dom.Document;

import javax.xml.transform.TransformerException;
import java.io.File;
import java.io.IOException;
import java.util.Arrays;
import java.util.logging.XMLFormatter;

@Component
public class Iterator {

    private static final Logger logger = LoggerFactory.getLogger(Iterator.class);
    @Autowired
    private APIConsumer apiConsumer;
    @Autowired
    private DataTransformer datatransformer;

    public void iterateConfig() {

        try {
            // read the configuration file that contains all the flows
            ObjectMapper mapper = new ObjectMapper();
            File from = new File("src/main/resources/config/configurations.json");
            JsonNode masterJSON = mapper.readTree(from);

            // for each flow run the process of calling the api, transforming the file and finally uploading to S3
            for (int i=0 ; i<masterJSON.get("config").size(); i++)
                {
                    logger.info("Executing flow number "+ (i+1) +" has started");
    //              apiConsumer.callAPI(masterJSON.get("config").get(i));
                    datatransformer.xsltTransformer(masterJSON.get("config").get(i));
                }

        } catch (JsonProcessingException e) {
            e.printStackTrace();
        } catch (TransformerException e) {
            e.printStackTrace();
        } catch (IOException e) {
            e.printStackTrace();
        }
    }
}