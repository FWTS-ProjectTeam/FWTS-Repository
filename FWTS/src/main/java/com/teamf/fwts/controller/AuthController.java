package com.teamf.fwts.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.teamf.fwts.service.UserService;

@Controller
public class AuthController {
    @Autowired
    private UserService userService;

    // 로그인 페이지
    @GetMapping("/login")
    public String loginForm() {
    	return "auth/login";
    }
    
    // 회원가입 페이지
    @GetMapping("/sign-up")
    public String signupForm(@RequestParam(name = "page", defaultValue = "1") Integer p) {
    	if (p == 1) return "auth/signup-agreement"; // 약관동의 화면
    	else if (p == 2) return "auth/signup"; // 정보입력 화면
    	return "auth/signup-complete"; // 가입완료 화면
    }
    
    // 계정 찾기 페이지
    @GetMapping({"/find-account", "/find-account/id", "/find-account/password"})
    public String findAccountForm() {
    	return "auth/find-account";
    }
    
    // 아이디 찾기 결과 페이지
    @PostMapping("/find-account/id")
    public String findUsername(@RequestParam("email") String e) {
    	 return "auth/find-username-result";
    }
    
    // 인증번호 입력 페이지
    @PostMapping("/find-account/password")
    public String verifyForm() {
    	return "auth/verify";
    }
    
    // 비밀번호 재설정 페이지
    @GetMapping("/find-account/reset-password")
    public String resetPasswordForm() {
    	return "auth/reset-password";
    }
    
    // 비밀번호 재설정 완료 페이지
    @PostMapping("/find-account/reset-password")
    public String resetPassword() {
    	return "auth/reset-password-complete";
    }
}