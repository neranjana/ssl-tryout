package com.neranjana.ssltryout.zuulexample;


import org.apache.http.impl.client.CloseableHttpClient;

import org.apache.http.impl.client.HttpClients;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.cloud.netflix.zuul.EnableZuulProxy;
import org.springframework.context.annotation.Bean;

import javax.net.ssl.KeyManagerFactory;
import javax.net.ssl.SSLContext;

import javax.net.ssl.TrustManagerFactory;

import java.io.FileInputStream;
import java.io.InputStream;

import java.security.KeyStore;
import java.security.SecureRandom;

@SpringBootApplication
@EnableZuulProxy
public class ZuulExampleApplication {
	@Value("${my.trustStore}")
	private String trustStorePath;
	@Value("${my.trustStorePassword}")
	private String trustStorePassword;
	@Value("${my.keyStore}")
	private String keyStorePath;
	@Value("${my.keyStoreType}")
	private String keyStoreType;
	@Value("${my.keyStorePassword}")
	private String keyStorePassword;


	public static void main(String[] args) {

		SpringApplication.run(ZuulExampleApplication.class, args);
	}

	@Bean
	public PreFilter preFilter() {
		return new PreFilter();
	}

	@Bean
	public PostFilter postFilter() {
		return new PostFilter();
	}

	@Bean
	public RouteFilter routeFilter() {
		return new RouteFilter();
	}

	@Bean
	public ErrorFilter errorFilter() {
		return new ErrorFilter();
	}

	@Bean
	public CloseableHttpClient httpClient() throws Throwable {

		KeyStore keyStore = KeyStore.getInstance(KeyStore.getDefaultType());
		try (InputStream in = new FileInputStream(keyStorePath)) {
			keyStore.load(in, keyStorePassword.toCharArray());
		}


		KeyManagerFactory keyManagerFactory =
				KeyManagerFactory.getInstance(KeyManagerFactory.getDefaultAlgorithm());
		keyManagerFactory.init(keyStore, keyStorePassword.toCharArray());


		KeyStore trustStore = KeyStore.getInstance(KeyStore.getDefaultType());
		try (InputStream in2 = new FileInputStream(trustStorePath)) {
			trustStore.load(in2, trustStorePassword.toCharArray());
		}


		TrustManagerFactory trustManagerFactory =
				TrustManagerFactory.getInstance(TrustManagerFactory.getDefaultAlgorithm());
		trustManagerFactory.init(trustStore);



		SSLContext sslContext = SSLContext.getInstance("TLS");
		sslContext.init(
				keyManagerFactory.getKeyManagers(),
				trustManagerFactory.getTrustManagers(),
				new SecureRandom());

		return HttpClients.custom().setSSLContext(sslContext)
           .build();
	}

}
