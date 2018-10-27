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

    @Value("${amazonProperties.endpointUrl}")
    private String endpointUrl;

    @Bean
    public AmazonS3 s3client() {

        InstanceProfileCredentialsProvider provider = new InstanceProfileCredentialsProvider(true);


        return  AmazonS3ClientBuilder.standard().withCredentials(provider).withRegion(Regions.US_EAST_1)
                .build();
    }
}