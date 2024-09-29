package com.david.service;

import java.io.File;

public interface FileStoreInterface {

    String upload(File file);
    void delete(String keyName);
    File download(String keyName);
}
