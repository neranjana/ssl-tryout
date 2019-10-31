package com.nernajana.ssltryout.mutualauthenabledclient;

import org.springframework.cloud.openfeign.FeignClient;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;

@FeignClient(name="GreetingClient", url="https://tmnt.127.0.0.1.nip.io:9443/greetings/hello")
public interface GreetingClient {
    @GetMapping
    ResponseEntity<String> getHello();
}
