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
	@NotBlank
    @Size(max=320)
    @Pattern(regexp = "^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$",
    		 message = "유효한 이메일 주소 형식을 입력하세요.")
    private String email;
	@NotNull
	@Size(min = 4, max = 20, message = "아이디는 4~20자 이내여야 합니다.")
	@Pattern(regexp = "^[a-zA-Z0-9]+$", message = "아이디는 영문과 숫자만 사용할 수 있습니다.")
	private String username;
	@NotNull
    @Size(min = 8, max = 20, message = "비밀번호는 8~20자 이내여야 합니다.")
	@Pattern(regexp = "^(?=.*[a-zA-Z])(?=.*\\d)(?=.*[!@#$%^&*()_+=-])[A-Za-z\\d!@#$%^&*()_+=-]{8,20}$",
			 message = "비밀번호는 영문, 숫자, 특수문자를 포함해야 합니다.")
    private String password;
	@NotNull
    @Min(1) @Max(2)
    private Integer role;
    
    // 회원 상세 정보
    @Pattern(regexp = "^(010)-\\d{4}-\\d{4}$", message = "유효한 휴대폰 번호 형식을 입력하세요.")
    private String phoneNum;
    @Pattern(regexp = "^(\\d{2,3}-\\d{3,4}-\\d{4}|\\d{4}-\\d{4})?$",
            message = "유효한 업체 전화번호 형식을 입력하세요.")
    private String companyNum;
    @NotNull
    @Size(max = 12, message = "사업자 등록번호는 10자리여야 합니다.") 
    @Pattern(regexp = "^\\d{3}-\\d{2}-\\d{5}$", message = "유효한 사업자 등록번호 형식을 입력하세요.")
    private String businessNo;
    @NotBlank
    @Size(max = 30)
    private String companyName;
    @NotBlank
    @Size(max = 30)
    private String ceoName;
    @NotNull
    @Pattern(regexp = "^\\d{5}$", message = "우편번호는 5자리 숫자여야 합니다.")
    private String postalCode;
    @NotBlank
    @Size(max = 60)
    private String address;
    @Size(max = 30)
    private String detailAddress;
}