package com.trubochisty.truboserver.controller;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/")
public class homeController {
    @GetMapping("/")
    public String home() {
        return "Hello World";
    }
}
