package com.nernajana.ssltryout.mutualauthenabledclient;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class GreetingService {
    private final GreetingClient greetingClient;

    @Autowired
    public GreetingService(GreetingClient greetingClient) {
        this.greetingClient = greetingClient;
    }

    public String getHello() {
        return greetingClient.getHello().getBody();
    }
}
