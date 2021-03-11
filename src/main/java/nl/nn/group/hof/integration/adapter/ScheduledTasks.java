package com.example.demo;

import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Date;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

import javax.xml.transform.TransformerException;

@Component
public class ScheduledTasks {

    private static final Logger logger = LoggerFactory.getLogger(ScheduledTasks.class);
    private static final SimpleDateFormat dateFormat = new SimpleDateFormat("HH:mm:ss");
    @Autowired
    private Iterator iterator;

    @Scheduled(fixedRate = 5000)
    public void reportCurrentTime() throws IOException, TransformerException {
        // log current date time
        logger.info("The transformation adapter started at {}", dateFormat.format(new Date()));
        // iterate over the flows
        iterator.iterateConfig();
    }
}