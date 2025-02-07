package com.teamf.fwts.dto;

import java.util.Date;

import com.teamf.fwts.entity.Users;

import lombok.Data;

@Data
public class InquiryListDto {
	private int inquiryId;
	private Users writer;
	private String inquiryTitle;
	private Date createdDate;
}