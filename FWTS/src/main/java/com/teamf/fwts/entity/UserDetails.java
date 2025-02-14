package com.teamf.fwts.entity;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Pattern;
import jakarta.validation.constraints.Size;
import lombok.Data;

@Data
public class UserDetails {
    private Integer userId;
    @NotNull
    @Pattern(regexp = "^(010)-\\d{4}-\\d{4}$")
    private String phoneNum;
    @Pattern(regexp = "^(\\d{2,3}-\\d{3,4}-\\d{4}|\\d{4}-\\d{4})$")
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
}