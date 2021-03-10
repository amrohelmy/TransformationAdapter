package com.example.demo;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import javax.xml.transform.TransformerException;
import java.io.File;
import java.io.IOException;

public class Iterator {

//    private static final APIConsumer apiConsumer = new APIConsumer();
    private static final DataTransformer datatransformer = new DataTransformer();

    public void iterateConfig() throws IOException, TransformerException {

        // read the configuration file that contains all the flows
        ObjectMapper mapper = new ObjectMapper();
        File from = new File("src/main/resources/config/configurations.json");
        JsonNode masterJSON = mapper.readTree(from);

        // for each flow run the process of calling the api, transforming the file and finally uploading to S3
        for (int i=0 ; i<masterJSON.get("config").size(); i++)
            {
//              apiConsumer.callAPI(masterJSON.get("config").get(i));
                datatransformer.xsltTransformer(masterJSON.get("config").get(i));
            }
    }
}