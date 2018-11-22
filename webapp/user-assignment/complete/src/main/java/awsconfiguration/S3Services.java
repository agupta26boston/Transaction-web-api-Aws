package awsconfiguration;

import org.springframework.context.annotation.Profile;
import org.springframework.web.multipart.MultipartFile;

@Profile("aws")
public interface S3Services {
    public void uploadFile(String keyName, MultipartFile file);

    public void deleteFile(String keyName);
}
