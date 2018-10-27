package hello;

import com.amazonaws.AmazonClientException;
import com.amazonaws.AmazonServiceException;
import com.amazonaws.SdkClientException;
import com.amazonaws.services.s3.AmazonS3;
import com.amazonaws.services.s3.model.DeleteObjectRequest;
import com.amazonaws.services.s3.model.ObjectMetadata;
import com.amazonaws.services.s3.model.PutObjectRequest;
import com.amazonaws.services.s3.transfer.TransferManager;
import com.amazonaws.services.s3.transfer.TransferManagerBuilder;
import com.amazonaws.services.s3.transfer.Upload;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Profile;
import org.springframework.stereotype.Service;
import org.springframework.util.StringUtils;
import org.springframework.web.multipart.MultipartFile;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;

@Service
@Profile("aws")
public class S3ServicesImpl implements S3Services{

    private Logger logger = LoggerFactory.getLogger(S3ServicesImpl.class);

    @Autowired
    private AmazonS3 s3client;

    @Value("${amazonProperties.bucketName}")
    private String bucketName;
    @Override
    public void uploadFile(String keyName, MultipartFile file) {
        try {
            TransferManager tm = TransferManagerBuilder.standard().withS3Client(s3client).build();
            Upload upload = tm.upload(bucketName, keyName, convertFromMultipart(file));
            System.out.println("Object upload started");

            // Optionally, wait for the upload to finish before continuing.
            upload.waitForCompletion();
            System.out.println("Object upload complete");

            //ObjectMetadata metadata = new ObjectMetadata();
            //metadata.setContentLength(file.getSize());
            //s3client.putObject(new PutObjectRequest(bucketName, keyName,convertFromMultipart(file)));
            //saving the meta data onto the database

         //catch(IOException ioe) {
            //logger.error("IOException: " + ioe.getMessage() ," " +ioe);
        } catch (AmazonServiceException ase) {
            logger.info("Caught an AmazonServiceException from PUT requests, rejected reasons:");
            logger.info("Error Message:    " + ase.getMessage());
            logger.info("HTTP Status Code: " + ase.getStatusCode());
            logger.info("AWS Error Code:   " + ase.getErrorCode());
            logger.info("Error Type:       " + ase.getErrorType());
            logger.info("Request ID:       " + ase.getRequestId());
            throw ase;
        } catch (AmazonClientException ace) {
            logger.info("Caught an AmazonClientException: ");
            logger.info("Error Message: " + ace.getMessage());
            throw ace;
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    @Override
    public void deleteFile(String keyName) {
        try {
            s3client.deleteObject(new DeleteObjectRequest(bucketName, keyName));
        } catch(AmazonServiceException ase) {
            logger.info("Caught an AmazonServiceException from PUT requests, rejected reasons:");
            logger.info("Error Message:    " + ase.getMessage());
            logger.info("HTTP Status Code: " + ase.getStatusCode());
            logger.info("AWS Error Code:   " + ase.getErrorCode());
            logger.info("Error Type:       " + ase.getErrorType());
            logger.info("Request ID:       " + ase.getRequestId());
            throw ase;
        } catch (SdkClientException sce) {
            logger.info("Caught an SdkClientException: ");
            logger.info("Error Message: " + sce.getMessage());
            throw sce;
        }
    }


    public File convertFromMultipart(MultipartFile file) throws Exception
    {
        File convFile = new File("tmp/" + file.getOriginalFilename());
        if(!convFile.getParentFile().exists())
            convFile.getParentFile().mkdir();
        if(!convFile.exists())
            convFile.createNewFile();
        //FileOutputStream fos = new FileOutputStream(convFile);
        //fos.write(file.getBytes());
        //fos.close();
        return convFile;
    }


    }

