package com.teamf.fwts.entity;

import lombok.Data;

@Data
public class UserDetails {
    private Integer userId;
    private String phoneNum;
    private String companyNum;
    private String businessNo;
    private String companyName;
    private String ceoName;
    private String postalCode;
    private String address;
    private String detailAddress;
}