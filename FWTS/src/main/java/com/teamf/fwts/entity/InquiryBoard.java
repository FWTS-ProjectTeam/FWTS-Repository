package com.teamf.fwts.entity;

import java.util.Date;

import com.teamf.fwts.validation.NotEmptyHtml;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;
import lombok.Data;

@Data
public class InquiryBoard {
	private Integer inquiryId;
	private Users writer;
	@NotBlank
	@Size(max = 64)
	private String inquiryTitle;
	@NotEmptyHtml
	private String inquiryContent;
	private Date createdDate;
	private String reply;
	private Date replyDate;
}