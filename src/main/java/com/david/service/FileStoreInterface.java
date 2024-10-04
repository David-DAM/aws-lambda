package com.david.service;

import org.springframework.web.multipart.MultipartFile;

import java.io.File;

public interface FileStoreInterface {

    String upload(MultipartFile file);

    void delete(String keyName);

    File download(String keyName);
}
