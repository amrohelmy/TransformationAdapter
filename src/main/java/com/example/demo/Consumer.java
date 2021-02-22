package com.example.demo;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import org.w3c.dom.Document;
import org.xml.sax.SAXException;
import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.parsers.ParserConfigurationException;
import javax.xml.transform.*;
import javax.xml.transform.dom.DOMSource;
import javax.xml.transform.stream.StreamResult;
import javax.xml.transform.stream.StreamSource;
import java.io.File;
import java.io.FileWriter;
import java.io.IOException;

@Service
public class Consumer {

    private final Logger logger = LoggerFactory.getLogger(Consumer.class);

    public void parseCourse() {

        try {
            // fake end point that returns XML response
            String URL = "http://www.mocky.io/v2/5c8bdd5c360000cd198f831e";

            DocumentBuilderFactory factory = DocumentBuilderFactory.newInstance();
            DocumentBuilder builder = factory.newDocumentBuilder();
            Document doc = builder.parse(URL);

            // transform document to xml file
            TransformerFactory transformerFactory = TransformerFactory.newInstance();
            Transformer transformer = transformerFactory.newTransformer();
            DOMSource source = new DOMSource(doc);

            FileWriter writer = new FileWriter(new File("./src/main/temp/test.xml"));
            StreamResult result = new StreamResult(writer);
            transformer.transform(source, result);

            // transform using xslt
            Source xslt = new StreamSource(new File("./src/main/temp/transformer.xsl"));
            Source xml  = new StreamSource(new File("./src/main/temp/test.xml"));
            Result out  = new StreamResult(new File("./src/main/temp/result.html"));

            Transformer xslTransformer = transformerFactory.newTransformer(xslt);
            xslTransformer.transform(xml, out);


        } catch (ParserConfigurationException e) {
            e.printStackTrace();
        } catch (IOException e) {
            e.printStackTrace();
        } catch (SAXException e) {
            e.printStackTrace();
        } catch (TransformerConfigurationException e) {
            e.printStackTrace();
        } catch (TransformerException e) {
            e.printStackTrace();
        }
    }
}