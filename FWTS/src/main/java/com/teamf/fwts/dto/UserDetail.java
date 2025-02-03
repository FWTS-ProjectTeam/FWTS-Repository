package com.teamf.fwts.dto;

import lombok.Data;

@Data
public class UserDetail {
    private int userId;
    private String email;
    private String phoneNum;
    private String companyNum;
    private String businessRegistNo;
    private String companyName;
    private String ceoName;
    private String postalCode;
    private String address;
    private String addressDetail;
}