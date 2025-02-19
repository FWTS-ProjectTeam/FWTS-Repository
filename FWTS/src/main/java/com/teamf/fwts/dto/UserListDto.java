package com.teamf.fwts.dto;

import java.util.Date;

import lombok.Data;

@Data
public class UserListDto {
	// 회원 기본 정보
	private Integer userId;
	private String username;
	private String ceoName;
    private String email;
	private Integer role;
    private boolean isLimited;
    private Date createdAt;
    
    // 회원 상세 정보
    private String phoneNum;
    private String companyNum;
    private String businessNo;
    private String companyName;
    private String postalCode;
    private String address;
    private String detailAddress;
    
    // 회원 게좌 정보
    private String bankName;
	private String accountNum;
}