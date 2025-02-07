package com.teamf.fwts.service;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;

import com.teamf.fwts.dao.InquiryBoardDao;
import com.teamf.fwts.dto.InquiryListDto;
import com.teamf.fwts.entity.NoticeBoard;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class InquiryBoardService {
	private final InquiryBoardDao inquiryBoardDao;

	// 문의사항 조회
	public List<InquiryListDto> inquiryList(Map<String, Object> paging) {
		return inquiryBoardDao.inquiryList(paging);
	}
	
	// 문의사항 수 확인
	public int count() {
		return inquiryBoardDao.count();
	}

	// 문의사항 상세 조회
	public NoticeBoard inquiryOne(int id) {
		return inquiryBoardDao.inquiryOne(id);
	}
}
