package com.teamf.fwts.service;

import java.time.LocalDateTime;
import java.util.HashMap;
import java.util.Map;

import org.springframework.stereotype.Service;

@Service
public class VerifyService {
	private final Map<String, VerificationEntry> codeStorage = new HashMap<>();
    private static final int EXPIRATION_MINUTES = 5; // 5분 후 만료

    // 인증 코드 및 생성 시간 저장하는 내부 클래스
    private static class VerificationEntry {
        String code;
        LocalDateTime timestamp;

        VerificationEntry(String code, LocalDateTime timestamp) {
            this.code = code;
            this.timestamp = timestamp;
        }
    }

    // 인증 코드 생성 및 저장 (유효기간 추가)
    public String generateCode(String email) {
        String code = String.valueOf((int) (Math.random() * 900000) + 100000);
        codeStorage.put(email, new VerificationEntry(code, LocalDateTime.now()));
        return code;
    }

    // 인증 코드 검증 (시간 제한 체크)
    public boolean verifyCode(String email, String inputCode) {
        if (!codeStorage.containsKey(email))
            return false;

        VerificationEntry entry = codeStorage.get(email);
        if (entry.timestamp.plusMinutes(EXPIRATION_MINUTES).isBefore(LocalDateTime.now())) {
            codeStorage.remove(email); // 만료된 코드 삭제
            return false;
        }

        return entry.code.equals(inputCode);
    }
}