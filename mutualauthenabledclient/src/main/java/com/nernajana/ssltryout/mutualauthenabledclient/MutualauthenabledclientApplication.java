package com.nernajana.ssltryout.mutualauthenabledclient;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.cloud.openfeign.EnableFeignClients;


@EnableFeignClients
@SpringBootApplication
public class MutualauthenabledclientApplication {

	public static void main(String[] args) {

		System.setProperty("javax.net.ssl.trustStore", "../create-custom-certificates/basedir/leaves/donatello/truststore/donatello-truststore.jks");
		System.setProperty("javax.net.ssl.trustStorePassword", "donatellotrustpass");
		System.setProperty("javax.net.ssl.keyStore", "../create-custom-certificates/basedir/leaves/donatello/private/donatello.p12");
//		System.setProperty("javax.net.ssl.keyStoreType", "pkcs12");
		System.setProperty("javax.net.ssl.keyStorePassword", "donatellopass");

		SpringApplication.run(MutualauthenabledclientApplication.class, args);

	}

}
