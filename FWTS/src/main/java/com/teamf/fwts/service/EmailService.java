package com.teamf.fwts.service;

import java.time.LocalDateTime;

import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.mail.javamail.MimeMessageHelper;
import org.springframework.stereotype.Service;

import jakarta.mail.MessagingException;
import jakarta.mail.internet.MimeMessage;
import jakarta.servlet.http.HttpSession;
import util.EmailTemplateUtils;

@Service
public class EmailService {
	private final JavaMailSender mailSender;

    public EmailService(JavaMailSender mailSender) {
        this.mailSender = mailSender;
    }

    // 인증 코드 전송
    public void sendVerificationCode(String to, String verificationCode) {
        try {
            MimeMessage message = mailSender.createMimeMessage();
            MimeMessageHelper helper = new MimeMessageHelper(message, true, "UTF-8");

            helper.setTo(to);
            helper.setSubject("[생화24] 비밀번호 재설정 인증 코드 전송");

            // 새로운 HTML 템플릿 사용
            String htmlContent = EmailTemplateUtils.generateVerificationCodeEmail(verificationCode);
            helper.setText(htmlContent, true); // HTML 적용

            mailSender.send(message);
        } catch (MessagingException e) {
            e.printStackTrace();
        }
    }
    
    // 인증 코드 생성
    public String generateCode(String email, HttpSession session) {
    	String verificationCode = String.valueOf((int) (Math.random() * 900000) + 100000); // 인증 코드 생성
    	LocalDateTime expiryTime = LocalDateTime.now().plusMinutes(5); // 5분 후 만료
    	
        session.setAttribute("verificationCode", verificationCode);
        session.setAttribute("verificationCodeExpiry", expiryTime);
        session.setAttribute("email", email);
        
        return verificationCode;
    }
}