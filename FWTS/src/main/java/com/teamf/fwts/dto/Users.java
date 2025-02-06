package com.teamf.fwts.dto;

import java.util.Date;

import lombok.Data;

@Data
public class Users {
    private int userId;
    private String email;
    private String username;
    private String password;
    private int role; // 관리자 0, 도매업자 1, 소매업자 2
    private boolean isSuspended;
    private Date createdAt;
}