package com.teamf.fwts.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class HomeController {

    @GetMapping("/")
    public String home() {
        return "redirect:/productList"; // index.jsp 없이 바로 주문 페이지로 이동
    }
}
