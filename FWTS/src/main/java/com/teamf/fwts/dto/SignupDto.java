package com.teamf.fwts.dto;

import jakarta.validation.constraints.Max;
import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Pattern;
import jakarta.validation.constraints.Size;
import lombok.Data;

@Data
public class SignupDto {
	// 회원 기본 정보
	@NotNull
    @Size(max=320)
    @Pattern(regexp = "^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$")
    private String email;
	@NotNull
	@Size(min = 4, max = 15)
	@Pattern(regexp = "^[a-zA-Z0-9]+$")
	private String username;
	@NotNull
    @Size(min = 8, max = 20)
	@Pattern(regexp = "^(?=.*[a-zA-Z])(?=.*\\d)(?=.*[!@#$%^&*()_+=-])[A-Za-z\\d!@#$%^&*()_+=-]{8,20}$")
    private String password;
	@NotNull
	private String confirmPassword;
	@NotNull
    @Min(1) @Max(2)
    private Integer role;
    
    // 회원 상세 정보
	@NotNull
    @Pattern(regexp = "^(010)-\\d{4}-\\d{4}$")
    private String phoneNum;
    @Pattern(regexp = "^(\\d{2,3}-\\d{3,4}-\\d{4}|\\d{4}-\\d{4})?$")
    private String companyNum;
    @NotNull
    @Size(max = 12) 
    @Pattern(regexp = "^\\d{3}-\\d{2}-\\d{5}$")
    private String businessNo;
    @NotBlank
    @Size(max = 30)
    private String companyName;
    @NotBlank
    @Size(max = 30)
    private String ceoName;
    @NotNull
    @Pattern(regexp = "^\\d{8}$")
    private String openingDate;
    @NotNull
    @Pattern(regexp = "^\\d{5}$")
    private String postalCode;
    @NotBlank
    @Size(max = 60)
    private String address;
    @Size(max = 30)
    private String detailAddress;
}