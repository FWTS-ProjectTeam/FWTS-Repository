package com.teamf.fwts.dto;

import java.util.Date;

import lombok.Data;

@Data
public class InquiryListDto {
	private Integer inquiryId;
	private String username;
	private String inquiryTitle;
	private Date createdDate;
	private Date replyDate;
}