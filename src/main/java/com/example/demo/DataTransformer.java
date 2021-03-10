package com.example.demo;

import com.fasterxml.jackson.databind.JsonNode;
import javax.xml.transform.*;
import javax.xml.transform.stream.StreamResult;
import javax.xml.transform.stream.StreamSource;
import java.io.File;

public class DataTransformer {

    private static final FileSender fileSender = new FileSender();

    public void xsltTransformer(JsonNode config) throws TransformerException {

        // transformation parameters
        Source xslt = new StreamSource(new File("./src/main/resources/XSLT/INT001a.xsl"));
        Source xml  = new StreamSource(new File("./src/main/resources/XSLT/INT001.xml"));
        Result out  = new StreamResult(new File("./src/main/temp/result.txt"));

        // transform the xml file
        TransformerFactory transformerFactory = TransformerFactory.newInstance();
        Transformer xslTransformer = transformerFactory.newTransformer(xslt);
        xslTransformer.transform(xml, out);

        // call the file sender to upload the transformed file to S3 bucket
        fileSender.uploadFile("mydo-frontend","./src/main/temp/result.txt");
    }
}
