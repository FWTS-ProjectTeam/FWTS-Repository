package com.teamf.fwts.dto;

import java.util.Date;

import lombok.Data;

@Data
public class NoticeListDto {
	private int noticeId;
	private String noticeTitle;
	private Date createdDate;
}