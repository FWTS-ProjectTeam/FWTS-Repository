package com.teamf.fwts.controller;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class MainController {

    @GetMapping("/FWTS")
    public String home(Model model) {
        model.addAttribute("message", "환영합니다!"); // 뷰에서 사용할 데이터 전달
        return "main"; // index.html 또는 index.jsp 파일을 반환
    }
}
