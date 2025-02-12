package com.teamf.fwts.dto;

import java.util.Date;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;
import lombok.Data;

@Data
public class ReplyDto {
	@NotBlank
	@Size(max = 2000)
	private String reply;
	private Date replyDate;
}