package com.teamf.fwts.entity;

import java.util.Date;

import lombok.Data;

@Data
public class Users {
    private Integer userId;
    private String email;
    private String username;
    private String password;
    private Integer role; // 관리자 0, 도매업자 1, 소매업자 2
    private boolean isLimited;
    private Date createdAt;
}