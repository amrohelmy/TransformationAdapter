package com.example.demo;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import javax.xml.transform.TransformerException;
import java.io.File;
import java.io.IOException;
import java.util.Date;

@Component
public class Iterator {

    private static final Logger logger = LoggerFactory.getLogger(Iterator.class);
//    @Autowired
//    private APIConsumer apiConsumer;
    @Autowired
    private DataTransformer datatransformer;

    public void iterateConfig() throws IOException, TransformerException {

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
    }
}