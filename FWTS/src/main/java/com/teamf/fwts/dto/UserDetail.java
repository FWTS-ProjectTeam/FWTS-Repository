package com.teamf.fwts.dto;

import java.time.LocalDateTime;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@AllArgsConstructor // 모든 필드를 포함한 생성자 자동 생성
@NoArgsConstructor // 기본 생성자(매개변수 없음) 자동 생성
@Data
public class UserDetail {
    private int userId;                                                                                                                                                                  
    private String phoneNum;
    private String companyNum;
    private String businessRegistNo;
    private String companyName;
    private String ceoName;
    private String companyIntro;
    private String postalCode;
    private String address;
    private String addressDetail;
}
