package com.david.service;

import com.amazonaws.services.s3.AmazonS3;
import lombok.AllArgsConstructor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import java.io.File;

@Service
public class FileStoreAwsImp implements FileStoreInterface {

    @Autowired
    private AmazonS3 s3Client;

    @Value("${cloud.aws.s3.bucket}")
    private String BUCKET_NAME;

    @Override
    public String upload(File file) {

        String name = file.getName();

        s3Client.putObject(BUCKET_NAME, name, file);

        return BUCKET_NAME + "/" + name;
    }

    @Override
    public void delete(String keyName) {

        s3Client.deleteObject(BUCKET_NAME, keyName);
    }

    @Override
    public File download(String keyName) {
        return null;
    }
}
