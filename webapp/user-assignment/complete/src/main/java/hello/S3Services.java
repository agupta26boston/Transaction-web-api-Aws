package hello;

import org.springframework.web.multipart.MultipartFile;

public interface S3Services {
    public void uploadFile(String keyName, MultipartFile file);

}
