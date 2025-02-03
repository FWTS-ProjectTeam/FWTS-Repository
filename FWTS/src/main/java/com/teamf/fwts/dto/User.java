package com.teamf.fwts.dto;

import java.util.Date;

import lombok.Data;

@Data
public class User {
    private int userId;
    private String username;
    private String password;
    private int role;
    private Date createdAt;
}