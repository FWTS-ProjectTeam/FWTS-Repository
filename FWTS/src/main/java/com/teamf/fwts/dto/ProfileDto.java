package com.teamf.fwts.dto;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Pattern;
import jakarta.validation.constraints.Size;
import lombok.Data;

@Data
public class ProfileDto {
	// 회원 상세 정보
	private Integer userId;
    @NotNull
    @Pattern(regexp = "^(010)-\\d{4}-\\d{4}$")
    private String phoneNum;
    @Pattern(regexp = "^(\\d{2,3}-\\d{3,4}-\\d{4}|\\d{4}-\\d{4})?$")
    private String companyNum;
    private String businessNo;
    @NotBlank
    @Size(max = 30)
    private String companyName;
    @NotBlank
    @Size(max = 30)
    private String ceoName;
    @NotNull
    @Pattern(regexp = "^\\d{5}$")
    private String postalCode;
    @NotBlank
    @Size(max = 60)
    private String address;
    @Size(max = 30)
    private String detailAddress;
    
    // 계좌 정보
    @Size(max = 10)
    private String bankName;
    @Size(max = 17)
    @Pattern(regexp = "^(\\d[\\d-]*\\d$)?$")
    private String accountNum;
}