package com.nernajana.ssltryout.mutualauthenabledclient;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.cloud.openfeign.EnableFeignClients;


@EnableFeignClients
@SpringBootApplication
public class MutualauthenabledclientApplication {

	public static void main(String[] args) {

		System.setProperty("javax.net.ssl.trustStore", "../create-custom-certificates/basedir/leaves/wile_e_coyote/truststore/wile_e_coyote-truststore.jks");
		System.setProperty("javax.net.ssl.trustStorePassword", "wileecoyotetrustpass");
		System.setProperty("javax.net.ssl.keyStore", "../create-custom-certificates/basedir/leaves/wile_e_coyote/private/wile_e_coyote.p12");
		System.setProperty("javax.net.ssl.keyStorePassword", "wileecoyotepass");

		SpringApplication.run(MutualauthenabledclientApplication.class, args);

	}

}
