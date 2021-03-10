package com.example.demo;

import com.amazonaws.auth.AWSCredentials;
import com.amazonaws.auth.AWSStaticCredentialsProvider;
import com.amazonaws.auth.BasicAWSCredentials;
import com.amazonaws.regions.Regions;
import com.amazonaws.services.s3.AmazonS3;
import com.amazonaws.services.s3.AmazonS3ClientBuilder;
import com.amazonaws.services.s3.model.Bucket;
import com.amazonaws.services.s3.model.PutObjectResult;

import java.io.File;
import java.util.List;

public class FileSender {

    AWSCredentials credentials = new BasicAWSCredentials("","");
    AmazonS3 s3client = AmazonS3ClientBuilder.standard().withCredentials(new AWSStaticCredentialsProvider(credentials)).withRegion(Regions.EU_CENTRAL_1).build();

    public void uploadFile(String bucketName, String filePath){
        // upload the file to the S3 bucket
        s3client.putObject(
                bucketName,
                "result.txt",
                new File(filePath)
        );
        System.out.println("File uploaded successfully: https://mydo-frontend.s3.eu-central-1.amazonaws.com/result.txt");
    }
}
