package com.teamf.fwts.entity;

import java.util.Date;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;
import lombok.Data;

@Data
public class InquiryBoard {
	private int inquiryId;
	private Users writer;
	@NotBlank
	@Size(max = 64)
	private String inquiryTitle;
	@NotBlank
	private String inquiryContent;
	private Date createdDate;
}