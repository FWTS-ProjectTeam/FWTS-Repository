package com.teamf.fwts.entity;

import java.util.Date;

import com.teamf.fwts.validation.NotEmptyHtml;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;
import lombok.Data;

@Data
public class NoticeBoard {
	private Integer noticeId;
	@NotBlank
	@Size(max = 64)
	private String noticeTitle;
	@NotEmptyHtml
	private String noticeContent;
	private Date createdDate;
}