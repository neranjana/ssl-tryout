package com.nernajana.ssltryout.mutualauthenabledclient;

import feign.codec.ErrorDecoder;
import org.springframework.context.annotation.Bean;

public class GreetingFeignClientConfiguration {

    @Bean
    public ErrorDecoder errorDecoder() {
        return new FeignClientErrorDecoder();
    }
}
