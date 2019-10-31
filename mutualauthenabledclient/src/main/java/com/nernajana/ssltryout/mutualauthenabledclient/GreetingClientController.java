package com.nernajana.ssltryout.mutualauthenabledclient;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("greetingclient")
public class GreetingClientController {

    private final GreetingService greetingService;

    @Autowired
    public GreetingClientController(GreetingService greetingService) {
        this.greetingService = greetingService;
    }

    @GetMapping("hello")
    public String getHello(){
        String greeting = greetingService.getHello();
        return greeting;
    }
}
