package com.example.demo;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import javax.xml.transform.TransformerException;
import java.io.File;
import java.io.IOException;


public class Iterator {

    public void iterateConfig() throws IOException, TransformerException {
        ObjectMapper mapper = new ObjectMapper();
        File from = new File("src/main/resources/config/configurations.json");
        JsonNode masterJSON = mapper.readTree(from);

        APIConsumer apiConsumer = new APIConsumer();
        DataTransformer datatransformer = new DataTransformer();

        for (int i=0 ; i<masterJSON.get("config").size(); i++)
            {
//              apiConsumer.callAPI(masterJSON.get("config").get(i));
                datatransformer.xsltTransformer(masterJSON.get("config").get(i));
            }
    }
}