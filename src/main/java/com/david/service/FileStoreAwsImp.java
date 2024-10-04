package com.david.service;

import com.amazonaws.services.s3.AmazonS3;
import com.amazonaws.services.s3.model.ObjectMetadata;
import lombok.SneakyThrows;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import java.io.File;

@Service
public class FileStoreAwsImp implements FileStoreInterface {

    @Autowired
    private AmazonS3 s3Client;

    @Value("${cloud.aws.s3.bucket}")
    private String BUCKET_NAME;

    @SneakyThrows
    @Override
    public String upload(MultipartFile file) {

        String name = file.getName();

        ObjectMetadata metadata = new ObjectMetadata();
        metadata.setContentLength(file.getSize());
        metadata.setContentType(file.getContentType());

        s3Client.putObject(BUCKET_NAME, name, file.getInputStream(), metadata);

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
