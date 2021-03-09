package com.example.demo;

import com.fasterxml.jackson.databind.JsonNode;
import javax.xml.transform.*;
import javax.xml.transform.stream.StreamResult;
import javax.xml.transform.stream.StreamSource;
import java.io.File;

public class DataTransformer {

    public void xsltTransformer(JsonNode config) throws TransformerException {

        TransformerFactory transformerFactory = TransformerFactory.newInstance();
        Transformer transformer = transformerFactory.newTransformer();

        Source xslt = new StreamSource(new File("./src/main/resources/XSLT/INT001a.xsl"));
        Source xml  = new StreamSource(new File("./src/main/resources/XSLT/INT001.xml"));
        Result out  = new StreamResult(new File("./src/main/temp/result.txt"));

        Transformer xslTransformer = transformerFactory.newTransformer(xslt);
        xslTransformer.transform(xml, out);

        System.out.println(out);
    }
}
