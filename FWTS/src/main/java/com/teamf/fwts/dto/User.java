package com.teamf.fwts.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import java.time.LocalDateTime;

@AllArgsConstructor // 모든 필드를 포함한 생성자 자동 생성
@NoArgsConstructor // 기본 생성자(매개변수 없음) 자동 생성
@Data
public class User {
    private int userId;
    private String username;
    private String email;
    private String password;
    private int role; // 0=관리자, 1=판매자, 2=구매자
    private LocalDateTime createdAt; // ✅ 날짜 타입 변경
}
 