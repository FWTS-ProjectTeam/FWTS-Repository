package com.teamf.fwts.entity;

import lombok.Data;

@Data
public class BankAccount {
	private Integer userId;
	private String bankName;
	private String accountNum;
}