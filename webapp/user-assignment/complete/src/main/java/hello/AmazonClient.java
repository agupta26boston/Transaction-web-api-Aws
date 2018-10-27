package hello;


import com.amazonaws.auth.*;
import com.amazonaws.auth.profile.ProfileCredentialsProvider;
import com.amazonaws.regions.Regions;
import com.amazonaws.services.s3.AmazonS3;
import com.amazonaws.services.s3.AmazonS3Client;
import com.amazonaws.services.s3.AmazonS3ClientBuilder;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.Profile;
import org.springframework.stereotype.Service;

import javax.annotation.PostConstruct;

@Configuration
@Profile("aws")
public class AmazonClient {

    @Value("${amazonProperties.region}")
    private String region;

    @Bean
    public AmazonS3 s3client() {
//
//        AWSCredentialsProviderChain providerChain= new AWSCredentialsProviderChain(InstanceProfileCredentialsProvider.getInstance(),new ProfileCredentialsProvider());
//
//
//        return AmazonS3ClientBuilder.standard().withCredentials(providerChain).build();
        AWSCredentials credentials= new BasicAWSCredentials("AKIAJJPCUOVQXQ2G5BUA","7K9UbKvqmDDLabS943398v7rV7jgoiFVxldV/Qz6");

        AmazonS3 s3client= AmazonS3ClientBuilder.standard().withCredentials(new AWSStaticCredentialsProvider(credentials)).withRegion(Regions.US_EAST_1).build();
        return s3client;


    }
}