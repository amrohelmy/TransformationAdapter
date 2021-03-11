package com.example.demo;

import com.amazonaws.auth.AWSCredentials;
import com.amazonaws.auth.AWSStaticCredentialsProvider;
import com.amazonaws.auth.BasicAWSCredentials;
import com.amazonaws.regions.Regions;
import com.amazonaws.services.s3.AmazonS3;
import com.amazonaws.services.s3.AmazonS3ClientBuilder;
import com.amazonaws.services.s3.model.Bucket;
import com.amazonaws.services.s3.model.PutObjectResult;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;
import org.springframework.stereotype.Service;

import java.io.File;
import java.util.List;

@Service
public class FileSender {

    private static final Logger logger = LoggerFactory.getLogger(FileSender.class);
    @Value("${AMAZON.S3.ACCESS-KEY}")
    private String accessKey;
    @Value("${AMAZON.S3.SECRET-KEY}")
    private String secretKey;
    @Value("${AMAZON.S3.REGION}")
    private String awsRegion;

    public void uploadFile(String bucketName, String filePath, String targetFileName){

        // initialise AWS S3 connection & client
        AWSCredentials credentials = new BasicAWSCredentials(accessKey,secretKey);
        AmazonS3 s3client = AmazonS3ClientBuilder.standard().withCredentials(new AWSStaticCredentialsProvider(credentials)).withRegion(Regions.valueOf(awsRegion)).build();

        // upload the file to the S3 bucket
        s3client.putObject(
                bucketName,
                targetFileName,
                new File(filePath)
        );
        logger.info("File with file name "+ targetFileName +" has been uploaded to S3 bucket "+ bucketName);
    }
}