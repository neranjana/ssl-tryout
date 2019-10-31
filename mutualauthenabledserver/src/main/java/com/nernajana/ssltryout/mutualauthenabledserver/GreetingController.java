package com.nernajana.ssltryout.mutualauthenabledserver;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("greetings")
public class GreetingController {
    @GetMapping("/hello")
    public String sayHello() {

        return "Hello if you can read this, mutual TLS works";
    }
}
