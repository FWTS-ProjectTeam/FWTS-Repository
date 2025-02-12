package util;

import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;

import org.springframework.core.io.ClassPathResource;

public class EmailTemplateUtils {
    // HTML 템플릿을 읽고 인증 코드 적용
    public static String generateVerificationCodeEmail(String verificationCode) {
        try {
            // 이메일 템플릿 파일 읽기
            ClassPathResource resource = new ClassPathResource("templates/verification-code-email.html");
            String content = new String(Files.readAllBytes(resource.getFile().toPath()), StandardCharsets.UTF_8);

            // ${verificationCode}를 실제 인증 코드로 변경
            return content.replace("${verificationCode}", verificationCode);
        } catch (IOException e) {
            e.printStackTrace();
            return "<p>이메일을 로드하는 중 오류가 발생했습니다.</p>";
        }
    }
}