package nl.nn.group.hof.integration.adapter;

import com.fasterxml.jackson.databind.JsonNode;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import javax.xml.transform.*;
import javax.xml.transform.stream.StreamResult;
import javax.xml.transform.stream.StreamSource;
import java.io.File;

@Component
public class DataTransformer {

    private static final Logger logger = LoggerFactory.getLogger(DataTransformer.class);
    @Autowired
    private FileSender fileSender;

    public void xsltTransformer(JsonNode config) throws TransformerException {

        // transformation parameters
        Source xslt = new StreamSource(new File(config.get("xsltFileName").asText()));
        Source xml  = new StreamSource(new File(config.get("xmlFileName").asText()));
        Result out  = new StreamResult(new File(config.get("outputFileName").asText()));

        // transform the xml file
        TransformerFactory transformerFactory = TransformerFactory.newInstance();
        Transformer xslTransformer = transformerFactory.newTransformer(xslt);
        xslTransformer.transform(xml, out);

        logger.info("File with file name " + config.get("targetFileName").asText() + " has been transformed successfully ");

        // call the file sender to upload the transformed file to S3 bucket
        fileSender.uploadFile(config.get("targetS3BucketName").asText(), config.get("outputFileName").asText(), config.get("targetFileName").asText());
    }
}
