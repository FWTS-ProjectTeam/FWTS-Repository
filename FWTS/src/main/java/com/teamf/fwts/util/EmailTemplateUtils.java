package com.teamf.fwts.util;

import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;

import org.springframework.core.io.ClassPathResource;

public class EmailTemplateUtils {
	// HTML 템플릿을 읽고 반환하는 메서드
    private static String loadTemplate(String filePath) {
        try {
            ClassPathResource resource = new ClassPathResource(filePath);
            return new String(Files.readAllBytes(resource.getFile().toPath()), StandardCharsets.UTF_8);
        } catch (IOException e) {
            e.printStackTrace();
            return "<p>이메일 템플릿을 로드하는 중 오류가 발생했습니다.</p>";
        }
    }

    // 비밀번호 재설정 인증 코드 이메일 템플릿
    public static String generateVerificationCodeEmail(String verificationCode) {
        String content = loadTemplate("templates/verification-code-email.html");
        return content.replace("${verificationCode}", verificationCode);
    }

    // 회원가입 완료 이메일 템플릿
    public static String generateSignupEmail(String ceoName) {
    	String content = loadTemplate("templates/signup-confirmation-email.html");
        return content.replace("${ceoName}", ceoName);
    }
}