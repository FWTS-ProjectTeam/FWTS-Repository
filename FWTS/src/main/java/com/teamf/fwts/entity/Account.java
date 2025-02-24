package com.teamf.fwts.entity;

import lombok.Data;

@Data
public class Account {
	private Integer userId;
	private String bankName;
	private String accountNum;
}