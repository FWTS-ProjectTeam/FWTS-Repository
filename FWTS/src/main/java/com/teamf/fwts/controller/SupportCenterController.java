package com.teamf.fwts.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping("/support-center")
public class SupportCenterController {
	@GetMapping("/notice")
    public String noticeAll() {
    	return "support/notice";
    }
}