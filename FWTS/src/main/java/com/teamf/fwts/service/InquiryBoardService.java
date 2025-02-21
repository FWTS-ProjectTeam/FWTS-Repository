package com.teamf.fwts.service;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.teamf.fwts.dto.InquiryListDto;
import com.teamf.fwts.entity.InquiryBoard;
import com.teamf.fwts.mapper.InquiryBoardMapper;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class InquiryBoardService {
	private final InquiryBoardMapper inquiryBoardMapper;
	
	// 문의사항 수 확인
	public int count(Map<String, Object> params) {
	    return inquiryBoardMapper.count(params);
	}
	
	// 문의사항 내역 수 확인
	public int countByWriterId(Map<String, Integer> params) {
		return inquiryBoardMapper.countByWriterId(params.get("writerId"));
	}

	// 문의사항 조회
	public List<InquiryListDto> findAll(Map<String, Object> paging) {
	    return inquiryBoardMapper.findAll(paging);
	}
	
	// 문의사항 내역 조회
	public List<InquiryListDto> findByWriterId(Map<String, Integer> params) {
		return inquiryBoardMapper.findByWriterId(params);
	}

	// 문의사항 상세 조회
	public InquiryBoard findByInquiryId(int id) {
		return inquiryBoardMapper.findByInquiryId(id);
	}
	
	// 문의사항 작성
	@Transactional
	public void saveInquiry(InquiryBoard newInquiry) {
		inquiryBoardMapper.saveInquiry(newInquiry);
	}
	
	// 문의사항 수정
	@Transactional
	public void updateInquiry(InquiryBoard oldInquiry) {
		inquiryBoardMapper.updateInquiry(oldInquiry);
	}

	// 문의사항 삭제
	@Transactional
	public void deleteInquiryById(int id) {
		inquiryBoardMapper.deleteInquiryById(id);
	}

	// 답변 작성
	@Transactional
	public void saveReply(InquiryBoard newInquiry) {
		inquiryBoardMapper.saveReply(newInquiry);
	}
	
	// 답변 수정
	@Transactional
	public void updateReply(InquiryBoard oldInquiry) {
		inquiryBoardMapper.updateReply(oldInquiry);
	}
}